import 'dart:convert';

import 'package:frontend/travel_experience_booking_tracking/domain/entities/agency_booking.dart';
import 'package:frontend/travel_experience_booking_tracking/domain/entities/traveler_booking.dart';
import 'package:frontend/travel_experience_booking_tracking/domain/interfaces/booking_interface.dart';
import 'package:frontend/travel_experience_booking_tracking/infrastructure/data_sources/booking_remote_provider.dart';
import 'package:frontend/travel_experience_booking_tracking/infrastructure/models/agency_booking_model.dart';
import 'package:frontend/travel_experience_booking_tracking/infrastructure/models/traveler_booking_model.dart';
import 'package:http/http.dart';

class BookingRepository implements BookingInterface {
  BookingRepository({
    required this.bookingRemoteDataProvider,
  });

  final BookingRemoteDataProvider bookingRemoteDataProvider;

  @override
  Future<TravelerBooking> getTravelerTripsBookingsDetails(String token) async {
    try {
      final Response response = await bookingRemoteDataProvider
          .getTravelerTripsBookingsDetails(token);
      return TravelerBookingModel.fromJson(jsonDecode(response.body));
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<List<AgencyBooking>> getAgencyTripsBookingsDetails(
      String token) async {
    try {
      final Response response =
          await bookingRemoteDataProvider.getAgencyTripsBookingsDetails(token);
      final List<dynamic> agencyBookingModelList = jsonDecode(response.body);

      return agencyBookingModelList
          .map((i) => AgencyBookingModel.fromJson(i))
          .toList();
    } catch (e) {
      throw Exception(e);
    }
  }
}
