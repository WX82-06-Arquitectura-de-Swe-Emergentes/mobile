import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:frontend/firebase/chat/chat.dart';
import 'package:frontend/firebase/chat/chat_dao.dart';
import 'package:frontend/firebase/member/member_dao.dart';
import 'package:frontend/models/trip_item.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/booking_provider.dart';
import 'package:frontend/services/trip_service.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/utils/global_utils.dart';
import 'package:frontend/widgets/image_slider_widget.dart';
import 'package:frontend/widgets/trip_details/my_itinerary_view_widget.dart';
import 'package:frontend/widgets/trip_details/my_review_view_widget.dart';
import 'package:frontend/widgets/trip_details/section_display.widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class TripDetailsScreen extends StatefulWidget {
  final int tripId;
  final AuthenticationProvider auth;

  const TripDetailsScreen({Key? key, required this.tripId, required this.auth})
      : super(key: key);

  @override
  State<TripDetailsScreen> createState() {
    return _TripDetailsScreenState();
  }
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  TripService tripService = TripService();
  ChatDao chatDao = ChatDao();
  MemberDao memberDao = MemberDao();
  late Map<String, dynamic>? paymentIntent;
  late BookingProvider bookingProvider;

  @override
  void initState() {
    super.initState();
    bookingProvider = Provider.of<BookingProvider>(
      context,
      listen: false,
    );
  }

  Future<TripItem> fetchData() async {
    return tripService
        .getTripById(widget.auth.token, widget.tripId)
        .then((value) {
      return value;
    });
  }

  void createChat(TripItem trip) async {
    final username = widget.auth.username;
    final agencyName = trip.agencyName;
    final chatTitle = trip.name;

    // Check if chat with same title already exists
    final chatQuery =
        chatDao.getChatQuery().orderByChild('title').equalTo(chatTitle);
    final chatSnapshot = await chatQuery.once();

    if (chatSnapshot.snapshot.value != null) {
      // Chat already exists, show error message to user
      _showDialog('Error', 'A chat with this agency already exists.');
      return;
    }

    Chat chat = Chat(
      title: chatTitle,
      lastMessage: '',
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    DatabaseReference chatRef = chatDao.getChatRef().push();
    chatRef.set(chat.toJson()).then((value) {
      final chatId = chatRef.key;
      chatRef.update({'id': chatId});

      Map<String, dynamic> members = {
        username: true,
        agencyName: true,
      };

      memberDao.getMemberRef().child(chatId as String).set(members);
    });

    // Display success message to user
    _showDialog('Chat', 'You have successfully created a chat!');
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> makePayment(String priceTrip) async {
    try {
      paymentIntent = await createPaymentIntent(priceTrip, 'PEN');

      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Damian'))
          .then((value) {});

      //STEP 3: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        bookingProvider.createBooking(widget.auth.token, widget.tripId);
        showDialog(
            context: context,
            builder: (_) => AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Pago exitoso!"),
                    ],
                  ),
                ));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Pago fallido!"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }

  createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return json.decode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  calculateAmount(String amount) {
    final calculatedAmout = (int.parse(amount)) * 100;
    return calculatedAmout.toString();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TripItem>(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot<TripItem> snapshot) {
        var data = snapshot.data as TripItem;

        return Scaffold(
          backgroundColor: Globals.backgroundColor,
          appBar: AppBar(
            title: const Text(
              "Trip details",
              style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Globals.redColor,
          ),
          body: snapshot.hasData
              ? SingleChildScrollView(
                  child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        PaginatedSlider(images: data.images),
                        const SizedBox(height: 16.0),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(data.name,
                                    style: const TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white)),
                              ),
                              if (widget.auth.isTraveler())
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            createChat(data);
                                          },
                                          child: const Icon(Icons.chat,
                                              color: Colors.white))
                                    ]),
                            ]),
                        const SizedBox(height: 24.0),
                        Row(
                          children: [
                            const Icon(
                              Icons.arrow_outward,
                              color: Colors.white,
                              size: 16.0,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              flex: 1,
                              child: Text(
                                data.description,
                                style: const TextStyle(
                                    fontSize: 14.0, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24.0),
                        SectionDisplayWidget(
                            title: 'DESTINATION',
                            content: data.destination.name,
                            icon: Icons.arrow_outward),
                        const SizedBox(
                            height: 24,
                            child: Divider(
                              color: Colors.white10,
                            )),
                        SectionDisplayWidget(
                            title: 'CATEGORY',
                            content: data.category,
                            icon: Icons.arrow_outward),
                        const SizedBox(
                            height: 24,
                            child: Divider(
                              color: Colors.white10,
                            )),
                        SectionDisplayWidget(
                            title: 'SEASON',
                            content: data.season.name,
                            icon: Icons.arrow_outward),
                        const SizedBox(
                            height: 24,
                            child: Divider(
                              color: Colors.white10,
                            )),
                        SectionDisplayWidget(
                            title: 'DATE',
                            content:
                                '${DateFormat('dd/MM').format(data.startDate)} - ${DateFormat('dd/MM').format(data.endDate)}',
                            icon: Icons.arrow_outward),
                        const SizedBox(height: 24.0),
                        MyItineraryViewWidget(
                          itineraries: data.itineraries,
                        ),
                        const SizedBox(height: 24.0),
                        MyReviewViewWidget(reviews: data.reviews),
                        const SizedBox(height: 24.0),
                      ]),
                ))
              : const Center(
                  child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 111, 111, 111),
                  ),
                ),
          floatingActionButton: Visibility(
            visible: widget.auth.isTraveler() && snapshot.hasData,
            child: FloatingActionButton.extended(
              onPressed: () async {
                await makePayment(
                    snapshot.hasData ? data.price.toInt().toString() : "0");
              },
              label: const Text(''),
              icon: Row(
                children: [
                  Icon(Icons.shopping_cart,
                      size: Utils.responsiveValue(context, 16.0, 20.0, 400)),
                  SizedBox(
                      width: Utils.responsiveValue(context, 8.0, 12.0, 400)),
                  Text(
                      Utils.formatPriceToPenTwoDecimals(
                          snapshot.hasData ? data.price.toDouble() : 0.0),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize:
                              Utils.responsiveValue(context, 12.0, 16.0, 400))),
                ],
              ),
              backgroundColor: Colors.red,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}
