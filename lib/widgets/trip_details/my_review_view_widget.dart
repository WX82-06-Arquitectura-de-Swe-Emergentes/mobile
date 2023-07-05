
import 'package:flutter/material.dart';
import 'package:frontend/models/review.dart';
import 'package:frontend/shared/globals.dart';
import 'package:intl/intl.dart';

class MyReviewViewWidget extends StatelessWidget {
  const MyReviewViewWidget({super.key, required this.reviews});

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.start, children:  [
          Text(
            'Reviews (${reviews.length})',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          )
        ],),
        const SizedBox(height: 16),
        reviews.isNotEmpty ?
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return ReviewItem(review: reviews[index]);
            },
          ),
        ) : const Text('No reviews yet.', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 40),
      ],
    );
  }
}

class ReviewItem extends StatelessWidget {
  const ReviewItem({Key? key, required this.review}) : super(key: key);

  final Review review;

  @override
  Widget build(BuildContext context) {
    final comment = review.comment;
    final rating = review.rating;
    final user = review.user;
    final createdAt = review.createdAt;

    final commentText = Text(comment,
        style: const TextStyle(
          fontSize: 14.0,
          color: Colors.white,
        ),
        maxLines: 4,
        overflow: TextOverflow.ellipsis);

    final readMoreButton = TextButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(comment,
                      style: const TextStyle(
                        fontSize: 14.0,
                        color: Colors.black45,
                      )),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: const Text('Read more'),
    );

    return Container(
      width: 300,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Globals.primaryColor,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundImage:
                      user.image != "" ? NetworkImage(user.image) : null,
                  child: user.image != "" ? null : const Icon(Icons.person),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 16.0,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            commentText,
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat.yMMMd().format(createdAt),
                  style: const TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
                readMoreButton,
              ],
            )
          ],
        ),
      ),
    );
  }
}