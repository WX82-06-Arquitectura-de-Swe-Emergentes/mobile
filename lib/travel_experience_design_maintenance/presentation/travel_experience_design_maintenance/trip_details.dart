// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:frontend/common/shared/globals.dart';
import 'package:frontend/common/utils/global_utils.dart';
import 'package:frontend/common/widgets/image_slider_widget.dart';
import 'package:frontend/customer_relationship_communication/infrastructure/database/realtime/realtime_database_service.dart';
import 'package:frontend/customer_relationship_communication/infrastructure/models/chat_model.dart';
import 'package:frontend/customer_relationship_communication/presentation/customer_relationship_communication/chat_conversation_screen.dart';
import 'package:frontend/identity_access_management/api/index.dart';
import 'package:frontend/injections.dart';
import 'package:frontend/travel_experience_booking_tracking/api/index.dart';
import 'package:frontend/travel_experience_design_maintenance/application/travel_experience_design_maintenance_facade_service.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip_item.dart';
import 'package:frontend/travel_experience_design_maintenance/presentation/widgets/my_itinerary_view_widget.dart';
import 'package:frontend/travel_experience_design_maintenance/presentation/widgets/my_review_view_widget.dart';
import 'package:frontend/travel_experience_design_maintenance/presentation/widgets/section_display.widget.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'dart:convert';

import 'package:provider/provider.dart';

class TripDetailsScreen extends StatefulWidget {
  final int tripId;
  final IdentityAccessManagementApi auth;

  const TripDetailsScreen({Key? key, required this.tripId, required this.auth})
      : super(key: key);

  @override
  State<TripDetailsScreen> createState() {
    return _TripDetailsScreenState();
  }
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  late RealtimeDatabaseService realtimeDatabaseService;
  late Map<String, dynamic>? paymentIntent;
  late dynamic bookingProvider;
  String existingChatId = '';
  dynamic tripData;

  @override
  void initState() {
    super.initState();
    realtimeDatabaseService = RealtimeDatabaseService();
    bookingProvider = Provider.of<TravelExperienceBookingTrackingApi>(
      context,
      listen: false,
    );
  }

  void getChatId(String chatTitle) async {
    final chatSnapshot =
        await realtimeDatabaseService.chatDao.getChatQuery().once();
    final chatData = chatSnapshot.snapshot.value as Map<dynamic, dynamic>?;

    if (chatData != null) {
      for (final entry in chatData.entries) {
        final chat = entry.value as Map<dynamic, dynamic>?;
        if (chat?['title'] == chatTitle) {
          setState(() {
            existingChatId = entry.key;
          });
          return;
        }
      }
    }
  }

  Future<TripItem> fetchData() async {
    var facadeService =
        serviceLocator<TravelExperienceDesignMaintenanceFacadeService>();
    return await facadeService.getTripById(widget.auth.token, widget.tripId);
  }

  void createChat(TripItem trip, int bookingId) async {
    final username = widget.auth.username;
    final agencyName = trip.agencyName;
    final chatTitle = "Booking-$bookingId-${trip.name}";

    getChatId(trip.name);

    // Check if chat with same title already exists
    final chatQuery = realtimeDatabaseService.chatDao
        .getChatQuery()
        .orderByChild('title')
        .equalTo(chatTitle);
    final chatSnapshot = await chatQuery.once();

    if (chatSnapshot.snapshot.value != null) {
      // Chat already exists, show error message to user
      _showDialog(chatTitle, existingChatId, 'Already exists',
          'A chat for this trip already exists');
      return;
    }

    ChatModel chat = ChatModel(
      id: '',
      title: chatTitle,
      lastMessage: '',
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    DatabaseReference chatRef =
        realtimeDatabaseService.chatDao.getChatRef().push();
    chatRef.set(chat.toJson()).then((value) {
      final chatId = chatRef.key;
      chatRef.update({'id': chatId});

      Map<String, dynamic> members = {
        username: true,
        agencyName: true,
      };

      realtimeDatabaseService.memberDao
          .getMemberRef()
          .child(chatId as String)
          .set(members);

      // Display success message to user
      _showDialog(chatTitle, chatId, 'Success', 'Chat created successfully');
    });
  }

  void _showDialog(
      String chatTitle, String chatId, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: const Text('Go to chat'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatConversationScreen(
                        chatTitle: chatTitle, id: existingChatId),
                  ),
                );
              },
            ),
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
      //STEP 1: Create payment intent
      paymentIntent = await createPaymentIntent(priceTrip, 'PEN');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  style: ThemeMode.dark,
                  merchantDisplayName: 'Damian'))
          .then((value) {});

      //STEP 2: Display Payment sheet
      displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
    }
  }

  displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        bookingProvider
            .createBooking(widget.auth.token, widget.tripId)
            .then((bookingId) {
          print('Booking ID: $bookingId');
          showDialog(
            context: context,
            builder: (_) => const AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100.0,
                  ),
                  SizedBox(height: 10.0),
                  Text("Payment Success!"),
                ],
              ),
            ),
          ).then((_) {
            createChat(tripData, bookingId);

            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 100.0,
                    ),
                    const SizedBox(height: 10.0),
                    const Text("Package reserved!"),
                    const SizedBox(height: 10.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/cart');
                      },
                      child: const Text('View My Packages'),
                    ),
                  ],
                ),
              ),
            );
          });
        });

        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed!"),
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
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 111, 111, 111),
            ),
          );
        }

        var data = snapshot.data as TripItem;
        tripData = data;

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
                              // if (widget.auth.isTraveler())
                              //   Column(
                              //       crossAxisAlignment:
                              //           CrossAxisAlignment.start,
                              //       children: [
                              //         ElevatedButton(
                              //             onPressed: () {
                              //               createChat(data);
                              //             },
                              //             child: const Icon(Icons.chat,
                              //                 color: Colors.white))
                              //       ]),
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
                if (data.status == "ACTIVE") {
                  await makePayment(
                      snapshot.hasData ? data.price.toInt().toString() : "0");
                }
              },
              label: const Text(''),
              icon: Row(
                children: [
                  data.status == "ACTIVE"
                      ? Icon(Icons.shopping_cart,
                          size: Utils.responsiveValue(context, 16.0, 20.0, 400))
                      : Icon(Icons.remove_shopping_cart,
                          size:
                              Utils.responsiveValue(context, 16.0, 20.0, 400)),
                  SizedBox(
                      width: Utils.responsiveValue(context, 8.0, 12.0, 400)),
                  Text(
                      (snapshot.hasData && data.status == "ACTIVE")
                          ? Utils.formatPriceToPenTwoDecimals(
                              data.price.toDouble())
                          : "SOLD OUT",
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
