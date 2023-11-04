import 'package:flutter/material.dart';
import 'package:frontend/common/shared/globals.dart';
import 'package:frontend/common/utils/global_utils.dart';
import 'package:frontend/identity_access_management/api/index.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/trip.dart';
import 'package:frontend/travel_experience_design_maintenance/presentation/travel_experience_design_maintenance/trip_details.dart';
import 'package:intl/intl.dart';

class TripCard extends StatelessWidget {
  const TripCard({Key? key, required this.trip, required this.auth})
      : super(key: key);
  final Trip trip;
  final IdentityAccessManagementApi auth;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Future.delayed(Duration.zero, () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TripDetailsScreen(tripId: trip.id, auth: auth),
            ),
          );
        });
      },
      child: Card(
        color: Globals.primaryColor,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FadeInImage.assetNetwork(
                        placeholder: 'images/loading.gif',
                        width:
                            Utils.responsiveValue(context, 100.0, 140.0, 400),
                        height:
                            Utils.responsiveValue(context, 80.0, 120.0, 400),
                        image: trip.thumbnail,
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'https://i.postimg.cc/44WWd61W/placeholder.png',
                            width: Utils.responsiveValue(
                                context, 100.0, 140.0, 400),
                            height: Utils.responsiveValue(
                                context, 80.0, 120.0, 400),
                          );
                        },
                      )),
                  const SizedBox(width: 16.0),
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(trip.name,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Utils.responsiveValue(
                                  context, 14.0, 16.0, 400),
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8.0),
                      Text(trip.destinationName,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Utils.responsiveValue(
                                  context, 10.0, 12.0, 400))),
                    ],
                  ))
                ],
              ),
              SizedBox(
                  height: Utils.responsiveValue(context, 12.0, 24.0, 400),
                  child: const Divider(
                    color: Colors.white10,
                  )),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Rating",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Utils.responsiveValue(
                                  context, 12.0, 14.0, 400))),
                      SizedBox(
                          width: Utils.responsiveValue(context, 4.0, 8.0, 400)),
                      Row(
                        children: [
                          Icon(Icons.star,
                              color: Colors.yellow,
                              size: Utils.responsiveValue(
                                  context, 16.0, 20.0, 400)),
                          SizedBox(
                              width: Utils.responsiveValue(
                                  context, 2.0, 8.0, 400)),
                          Text('${trip.averageRating}/5',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Utils.responsiveValue(
                                      context, 12.0, 14.0, 400))),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(flex: 1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Price",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Utils.responsiveValue(
                                  context, 12.0, 14.0, 400))),
                      SizedBox(
                          width: Utils.responsiveValue(context, 4.0, 8.0, 400)),
                      Text(Utils.formatPriceToPenTwoDecimals(trip.price),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Utils.responsiveValue(
                                  context, 12.0, 14.0, 400))),
                    ],
                  ),
                  const Spacer(flex: 1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Status",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Utils.responsiveValue(
                                  context, 12.0, 14.0, 400))),
                      SizedBox(
                          width: Utils.responsiveValue(context, 4.0, 8.0, 400)),
                      Row(
                        children: [
                          Container(
                            width: 12.0,
                            height: 12.0,
                            decoration: BoxDecoration(
                              color: trip.status == 'ACTIVE'
                                  ? Colors.green
                                  : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                              width: Utils.responsiveValue(
                                  context, 2.0, 8.0, 400)),
                          Text(trip.status == 'ACTIVE' ? 'Open' : 'Closed',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: Utils.responsiveValue(
                                      context, 12.0, 14.0, 400))),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(flex: 1),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Utils.responsiveValue(
                                  context, 12.0, 14.0, 400))),
                      SizedBox(
                          width: Utils.responsiveValue(context, 4.0, 8.0, 400)),
                      Text(
                          '${DateFormat('dd/MM').format(trip.startDate)} - ${DateFormat('dd/MM').format(trip.endDate)}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: Utils.responsiveValue(
                                  context, 12.0, 14.0, 400))),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
