import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:frontend/firebase/chat/chat.dart';
import 'package:frontend/firebase/chat/chat_dao.dart';
import 'package:frontend/firebase/member/member_dao.dart';
import 'package:frontend/models/trip_item.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/trip_service.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/widgets/image_slider_widget.dart';
import 'package:frontend/widgets/trip_details/my_itinerary_view_widget.dart';
import 'package:frontend/widgets/trip_details/my_review_view_widget.dart';
import 'package:frontend/widgets/trip_details/section_display.widget.dart';
import 'package:intl/intl.dart';

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

  String formatPriceToPenTwoDecimals(double price) {
    return 'S/ ${price.toStringAsFixed(2)}';
  }

  double responsiveValue(double min, double max, int defaultValue) {
    if (MediaQuery.of(context).size.width < defaultValue) {
      return min;
    } else {
      return max;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TripItem>(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot<TripItem> snapshot) {
        if (snapshot.hasData) {
          final trip = snapshot.data as TripItem;

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
            body: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageSliderWidget(images: trip.images),
                    const SizedBox(height: 16.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(trip.name,
                                style: const TextStyle(
                                    fontSize: 24.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white)),
                          ),
                          const SizedBox(width: 8),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ElevatedButton(
                                    onPressed: () {
                                      createChat(trip);
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
                            trip.description,
                            style: const TextStyle(
                                fontSize: 14.0, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                    SectionDisplayWidget(
                        title: 'DESTINATION',
                        content: trip.destination.name,
                        icon: Icons.arrow_outward),
                    const SizedBox(
                        height: 24,
                        child: Divider(
                          color: Colors.white10,
                        )),
                    SectionDisplayWidget(
                        title: 'CATEGORY',
                        content: trip.category,
                        icon: Icons.arrow_outward),
                    const SizedBox(
                        height: 24,
                        child: Divider(
                          color: Colors.white10,
                        )),
                    SectionDisplayWidget(
                        title: 'SEASON',
                        content: trip.season.name,
                        icon: Icons.arrow_outward),
                    const SizedBox(
                        height: 24,
                        child: Divider(
                          color: Colors.white10,
                        )),
                    SectionDisplayWidget(
                        title: 'DATE',
                        content:
                            '${DateFormat('dd/MM').format(trip.startDate)} - ${DateFormat('dd/MM').format(trip.endDate)}',
                        icon: Icons.arrow_outward),
                    const SizedBox(height: 24.0),
                    MyItineraryViewWidget(
                      itineraries: trip.itineraries,
                    ),
                    const SizedBox(height: 24.0),
                    MyReviewViewWidget(reviews: trip.reviews),
                    const SizedBox(height: 24.0),
                  ]),
            )),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                // Lógica para comprar el viaje
              },
              label: const Text(''),
              icon: Row(
                children: [
                  Icon(Icons.shopping_cart, size: responsiveValue(16.0, 20.0, 400)),
                  SizedBox(width: responsiveValue(8.0, 12.0, 400)),
                  Text(formatPriceToPenTwoDecimals(trip.price),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: responsiveValue(12.0, 16.0, 400))),
                ],
              ),
              backgroundColor: Colors.red,
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          );
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 111, 111, 111),
            ),
          );
        }
      },
    );
  }
}
