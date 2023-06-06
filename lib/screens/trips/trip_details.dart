import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:frontend/firebase/chat/chat.dart';
import 'package:frontend/firebase/chat/chatDao.dart';
import 'package:frontend/firebase/member/memberDao.dart';
import 'package:frontend/firebase/message/messageDao.dart';
import 'package:frontend/models/review.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/services/api_service.dart';
import 'package:frontend/shared/globals.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetailsScreen extends StatefulWidget {
  final Trip trip;
  final AuthenticationProvider auth;

  TripDetailsScreen({Key? key, required this.trip, required this.auth})
      : super(key: key);

  @override
  _TripDetailsScreenState createState() => _TripDetailsScreenState();
}

class _TripDetailsScreenState extends State<TripDetailsScreen> {
  List<Review> reviews = [];
  bool showAllReviews = false;
  bool showAllItineraries = false;
  ChatDao chatDao = ChatDao();
  MessageDao messageDao = MessageDao();
  MemberDao memberDao = MemberDao();

  @override
  void initState() {
    super.initState();
    fetchTripReviews(widget.trip.id);
  }

  void fetchTripReviews(int tripId) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer ${widget.auth.token}'
    };
    String idString = tripId.toString();
    String url = '/ratings?tripId=$idString';
    final response = await ApiService.get(url, headers);
    setState(() {
      reviews =
          (response as List).map((data) => Review.fromJson(data)).toList();
    });
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
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Icon(Icons.location_on, color: Globals.redColor),
                    const SizedBox(height: 8.0),
                    Text(widget.trip.destination.name,
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.access_time, color: Globals.redColor),
                    const SizedBox(height: 8.0),
                    Text(widget.trip.category,
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.group_add, color: Globals.redColor),
                    const SizedBox(height: 8.0),
                    Text('${widget.trip.groupSize}+',
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
                Column(
                  children: [
                    Icon(Icons.flash_on, color: Globals.redColor),
                    const SizedBox(height: 8.0),
                    Text(
                        widget.trip.status == 'A' ? 'Available' : 'Unavailable',
                        style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            height: 300.0,
            child: Stack(
              children: [
                Positioned(
                  top: 0.0,
                  bottom: 0.0,
                  left: 0.0,
                  right: 0.0,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (details.delta.dx > 0) {
                        _pageController.previousPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      } else if (details.delta.dx < 0) {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      }
                    },
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: widget.trip.images.length,
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Scaffold(
                                  appBar: AppBar(
                                    backgroundColor: Colors.black,
                                  ),
                                  body: Center(
                                    child: Image.network(
                                      widget.trip.images[index],
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: Image.network(
                            widget.trip.images[index],
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        final username = widget.auth.username;
                        final agencyName = widget.trip.agencyName;
                        DatabaseReference chatRef = chatDao.getChatRef().push();
                        DatabaseReference memberRef =
                            memberDao.getMemberRef().push();

                        Chat chat = Chat(
                            title: widget.trip.name,
                            lastMessage: "",
                            timestamp: DateTime.now().millisecondsSinceEpoch);

                        chatRef.set(chat.toJson()).then((value) {
                          final chatId = chatRef.key;

                          DatabaseReference memberChatRef = FirebaseDatabase
                              .instance
                              .ref()
                              .child("members/${chatId}");
                          memberChatRef.set({username: true, agencyName: true});
                        });

                        // display a dialog to the user
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Chat'),
                                content: const Text(
                                    'You have successfully created a chat!'),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'))
                                ],
                              );
                            });

                      },
                      child: const Icon(Icons.chat, color: Colors.white),
                    )
                  ])),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PRICE',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  height: 2.0,
                  width: 50.0,
                  color: Globals.redColor,
                ),
                const SizedBox(height: 8.0),
                Text(
                  'S./${widget.trip.price}',
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'CATEGORY',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  height: 2.0,
                  width: 50.0,
                  color: Globals.redColor,
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.trip.category,
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'SEASON',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  height: 2.0,
                  width: 50.0,
                  color: Globals.redColor,
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.trip.season,
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'DESCRIPTION',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  height: 2.0,
                  width: 50.0,
                  color: Globals.redColor,
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.trip.destination.description,
                  style: const TextStyle(fontSize: 16.0, color: Colors.white),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ITINERARY',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  height: 2.0,
                  width: 50.0,
                  color: Globals.redColor,
                ),
                const SizedBox(height: 8.0),
                Column(
                  children: visibleItineraries.map((it) {
                    return Column(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8.0),
                              Text(
                                'DAY ${it.day}',
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              const Text(
                                'LOCATION',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text(
                                it.location,
                                style: const TextStyle(
                                    fontSize: 16.0, color: Colors.white),
                              ),
                              const SizedBox(height: 8.0),
                              const Text(
                                'ACTIVITIES',
                                style: TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: it.activities.map((activity) {
                                  return Row(children: [
                                    Text(
                                      activity,
                                      style: const TextStyle(
                                          fontSize: 16.0, color: Colors.white),
                                    )
                                  ]);
                                }).toList(),
                              ),
                              const SizedBox(height: 16.0),
                            ],
                          ),
                          const SizedBox(width: 16.0),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height:
                                  200.0, // Ajusta la altura del mapa según tus necesidades
                              child: GoogleMap(
                                  initialCameraPosition: CameraPosition(
                                    target: LatLng(it.latitude, it.longitude),
                                    zoom: 15.0,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId:
                                          const MarkerId('exact_location'),
                                      position:
                                          LatLng(it.latitude, it.longitude),
                                      infoWindow: const InfoWindow(
                                          title: 'Exact Location'),
                                    ),
                                  }),
                            ),
                          ),
                        ],
                      ),
                    ]);
                  }).toList(),
                ),
                if (!showAllItineraries) const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return Container(
                          color: Globals.backgroundColor,
                          height: MediaQuery.of(context).size.height * .9,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(width: 16.0),
                                  const Text(
                                    'Itineraries',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () =>
                                        Navigator.of(context).pop(),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: sortedItineraries.map((it) {
                                      return Column(children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  'DAY ${it.day}',
                                                  style: const TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 8.0),
                                                const Text(
                                                  'LOCATION',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Text(
                                                  it.location,
                                                  style: const TextStyle(
                                                      fontSize: 16.0,
                                                      color: Colors.white),
                                                ),
                                                const SizedBox(height: 8.0),
                                                const Text(
                                                  'ACTIVITIES',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                const SizedBox(height: 8.0),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: it.activities
                                                      .map((activity) {
                                                    return Row(children: [
                                                      Text(
                                                        activity,
                                                        style: const TextStyle(
                                                            fontSize: 16.0,
                                                            color:
                                                                Colors.white),
                                                      )
                                                    ]);
                                                  }).toList(),
                                                ),
                                                const SizedBox(height: 16.0),
                                              ],
                                            ),
                                            const SizedBox(width: 16.0),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Expanded(
                                              child: SizedBox(
                                                height:
                                                    200.0, // Ajusta la altura del mapa según tus necesidades
                                                child: GoogleMap(
                                                    initialCameraPosition:
                                                        CameraPosition(
                                                      target: LatLng(
                                                          it.latitude,
                                                          it.longitude),
                                                      zoom: 15.0,
                                                    ),
                                                    markers: {
                                                      Marker(
                                                        markerId: const MarkerId(
                                                            'exact_location'),
                                                        position: LatLng(
                                                            it.latitude,
                                                            it.longitude),
                                                        infoWindow:
                                                            const InfoWindow(
                                                                title:
                                                                    'Exact Location'),
                                                      ),
                                                    }),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ]);
                                    }).toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: const Text('See More'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Globals.redColor,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'REVIEWS',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8.0),
                Container(
                  height: 2.0,
                  width: 50.0,
                  color: Globals.redColor,
                ),
                const SizedBox(height: 8.0),
                Column(
                  children: visibleReviews.map((review) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8.0),
                                Row(
                                  children: List.generate(
                                        review.rating,
                                        (index) => const Icon(Icons.star,
                                            color: Colors.white, size: 16.0),
                                      ) +
                                      List.generate(
                                        5 - review.rating,
                                        (index) => const Icon(Icons.star_border,
                                            color: Colors.white, size: 16.0),
                                      ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  'by ${review.user.email} at ',
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text(
                                  review.comment,
                                  style: const TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                            const SizedBox(width: 16.0),
                          ],
                        ),
                      ],
                    );
                  }).toList(),
                ),
                if (!showAllReviews)
                  ElevatedButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext context) {
                          return Container(
                            height: MediaQuery.of(context).size.height * 0.9,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const SizedBox(width: 16.0),
                                    const Text(
                                      'Reviews',
                                      style: TextStyle(
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close),
                                      onPressed: () =>
                                          Navigator.of(context).pop(),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: sortedReviews.map((review) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const SizedBox(height: 8.0),
                                                    Row(
                                                      children: List.generate(
                                                            review.rating,
                                                            (index) =>
                                                                const Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .black,
                                                                    size: 16.0),
                                                          ) +
                                                          List.generate(
                                                            5 - review.rating,
                                                            (index) => const Icon(
                                                                Icons
                                                                    .star_border,
                                                                color: Colors
                                                                    .black,
                                                                size: 16.0),
                                                          ),
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Text(
                                                      'by ${review.user.email} at ',
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8.0),
                                                    Text(
                                                      review.comment,
                                                      style: const TextStyle(
                                                        fontSize: 16.0,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: 16.0),
                                                  ],
                                                ),
                                                const SizedBox(width: 16.0),
                                              ],
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: const Text('See More'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Globals.redColor,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
        ]),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Lógica para comprar el viaje
        },
        label: const Text(''),
        icon: const Icon(Icons.shopping_cart),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  final PageController _pageController = PageController();
}
