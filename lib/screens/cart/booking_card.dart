import 'package:flutter/material.dart';
import 'package:frontend/models/booking.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/utils/global_utils.dart';
import 'package:intl/intl.dart';

class BookingCard extends StatelessWidget {
  const BookingCard({Key? key, required this.booking, required this.auth})
      : super(key: key);
  final Booking booking;
  final AuthenticationProvider auth;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Globals.primaryColor,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage.assetNetwork(
                      placeholder: 'images/loading.gif',
                      width: Utils.responsiveValue(context, 60.0, 80.0, 400),
                      height: Utils.responsiveValue(context, 60.0, 80.0, 400),
                      image: booking.thumbnail,
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'https://i.postimg.cc/44WWd61W/placeholder.png',
                          width:
                              Utils.responsiveValue(context, 60.0, 80.0, 400),
                          height:
                              Utils.responsiveValue(context, 60.0, 80.0, 400),
                        );
                      },
                    )),
                const SizedBox(width: 16.0),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(booking.tripName,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Utils.responsiveValue(
                                      context, 14.0, 16.0, 400),
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8.0),
                          Text('Booking #${booking.id}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Utils.responsiveValue(
                                      context, 10.0, 12.0, 400))),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(DateFormat('dd/MM/yyyy').format(booking.date),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Utils.responsiveValue(
                                      context, 10.0, 12.0, 400),
                                  fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8.0),
                          Row(
                            children: [
                              Container(
                                width: 12.0,
                                height: 12.0,
                                decoration: BoxDecoration(
                                  color: booking.status == 'CONFIRMED'
                                      ? Colors.green
                                      : Colors.red,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              SizedBox(
                                  width: Utils.responsiveValue(
                                      context, 2.0, 8.0, 400)),
                              Text(
                                  booking.status == 'CONFIRMED'
                                      ? 'Confirmed'
                                      : 'Cancelled',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: Utils.responsiveValue(
                                          context, 12.0, 14.0, 400))),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
