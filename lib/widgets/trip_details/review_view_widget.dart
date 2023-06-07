import "package:flutter/material.dart";
import "package:frontend/models/review.dart";
import 'package:frontend/shared/globals.dart';

class ReviewViewWidget extends StatelessWidget {
  const ReviewViewWidget(
      {super.key,
      required this.sortedReviews,
      required this.visibleReviews,
      required this.showAllReviews});

  final List<Review> sortedReviews;
  final Iterable<Review> visibleReviews;
  final bool showAllReviews;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
                      color: Globals.backgroundColor,
                      height: MediaQuery.of(context).size.height * 0.9,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(width: 16.0),
                              const Text(
                                'Reviews',
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16.0),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(
                                  16.0), // Define el padding que deseas
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
                                                        (index) => const Icon(
                                                            Icons.star,
                                                            color: Colors.white,
                                                            size: 16.0),
                                                      ) +
                                                      List.generate(
                                                        5 - review.rating,
                                                        (index) => const Icon(
                                                            Icons.star_border,
                                                            color: Colors.white,
                                                            size: 16.0),
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
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Globals.redColor,
              ),
              child: const Text('See More'),
            ),
        ],
      ),
    );
  }
}
