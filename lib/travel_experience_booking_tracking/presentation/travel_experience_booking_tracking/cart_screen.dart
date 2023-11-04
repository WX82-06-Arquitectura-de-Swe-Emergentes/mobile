import 'package:flutter/material.dart';
import 'package:frontend/identity_access_management/api/index.dart';
import 'package:frontend/travel_experience_booking_tracking/presentation/travel_experience_booking_tracking/agency/agency_booking_screen.dart';
import 'package:frontend/travel_experience_booking_tracking/presentation/travel_experience_booking_tracking/traveler/traveler_booking_screen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final iamProvider = Provider.of<IdentityAccessManagementApi>(
      context,
      listen: false,
    );

    return iamProvider.isAgency()
        ? const AgencyBookingScreen()
        : const TravelerBookingScreen();
  }
}
