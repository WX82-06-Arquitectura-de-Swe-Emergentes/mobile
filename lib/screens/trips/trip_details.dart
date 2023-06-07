import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:frontend/firebase/chat/chat.dart';
import 'package:frontend/firebase/chat/chatDao.dart';
import 'package:frontend/firebase/member/memberDao.dart';
import 'package:frontend/models/review.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/trip_service.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/widgets/image_slider_widget.dart';
import 'package:frontend/widgets/trip_details/bar_info_display.widget.dart';
import 'package:frontend/widgets/trip_details/itinerary_view_widget.dart';
import 'package:frontend/widgets/trip_details/section_display.widget.dart';
import 'package:frontend/widgets/trip_details/review_view_widget.dart';

class TripDetailsScreen extends StatefulWidget {
  final Trip trip;
  final AuthenticationProvider auth;

  const TripDetailsScreen({Key? key, required this.trip, required this.auth})
      : super(key: key);

  @override
  State<TripDetailsScreen> createState() {
    return _TripDetailsScreenState();
  }
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  List<Review> reviews = [];
  bool showAllReviews = false;
  bool showAllItineraries = false;

  ChatDao chatDao = ChatDao();
  MemberDao memberDao = MemberDao();

  TripService tripService = TripService();

  @override
  void initState() {
    super.initState();
    tripService
        .getTripReviews(widget.auth.token, widget.trip.id)
        .then((value) => {
              setState(() {
                reviews = value;
              })
            });
  }

  void createChat() async {
    final username = widget.auth.username;
    final agencyName = widget.trip.agencyName;
    final chatTitle = widget.trip.name;

    // Check if chat with same title already exists
    final chatQuery =
        chatDao.getChatQuery().orderByChild('title').equalTo(chatTitle);
    final chatSnapshot = await chatQuery.once();
    if (chatSnapshot.snapshot.value != null) {
      // Chat already exists, show error message to user
      _showDialog('Error', 'A chat with this agency already exists.');
      return;
    }

    // Create new chat
    DatabaseReference chatRef = chatDao.getChatRef().push();
    DatabaseReference memberRef = memberDao.getMemberRef().push();

    Chat chat = Chat(
      title: chatTitle,
      lastMessage: '',
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    chatRef.set(chat.toJson()).then((value) {
      final chatId = chatRef.key;

      chatRef.update({'id': chatId});

      DatabaseReference memberChatRef =
          FirebaseDatabase.instance.ref().child('members/$chatId');
      memberChatRef.set({username: true, agencyName: true});
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

  @override
  Widget build(BuildContext context) {
    final sortedItineraries = widget.trip.itineraries.toList()
      ..sort((a, b) => a.day.compareTo(b.day));
    final visibleItineraries =
        showAllItineraries ? sortedItineraries : sortedItineraries.take(1);

    final sortedReviews = reviews.toList();
    final visibleReviews =
        showAllReviews ? sortedReviews : sortedReviews.take(3);

    return Scaffold(
      backgroundColor: Globals.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.trip.name,
          style: const TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Globals.redColor,
      ),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          BarInfoDisplayWidget(trip: widget.trip),
          const SizedBox(height: 16.0),
          ImageSliderWidget(images: widget.trip.images),
          const SizedBox(height: 16.0),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        createChat();
                      },
                      child: const Icon(Icons.chat, color: Colors.white),
                    )
                  ])),
          const SizedBox(height: 16.0),
          SectionDisplayWidget(
              title: 'CATEGORY', content: widget.trip.category),
          const SizedBox(height: 16.0),
          SectionDisplayWidget(title: 'SEASON', content: widget.trip.season),
          const SizedBox(height: 16.0),
          SectionDisplayWidget(
              title: 'DESCRIPTION', content: widget.trip.description),
          const SizedBox(height: 16.0),
          ItineraryViewWidget(
              visibleItineraries: visibleItineraries,
              sortedItineraries: sortedItineraries,
              showAllItineraries: showAllItineraries),
          const SizedBox(height: 16.0),
          ReviewViewWidget(
              sortedReviews: sortedReviews,
              visibleReviews: visibleReviews,
              showAllReviews: showAllReviews),
          const SizedBox(height: 16.0),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Lógica para comprar el viaje
        },
        label: const Text(''),
        icon: Row(
          children: [
            const Icon(Icons.shopping_cart),
            const SizedBox(width: 12),
            Text('S./${widget.trip.price}', style: TextStyle(fontSize: 16)),
          ],
        ),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  final PageController _pageController = PageController();
}
