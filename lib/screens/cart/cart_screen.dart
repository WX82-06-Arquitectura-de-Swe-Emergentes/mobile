import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/cart/agency/agency_booking_screen.dart';
import 'package:frontend/screens/cart/traveler/traveler_booking_screen.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    return authProvider.isAgency()
        ? const AgencyBookingScreen()
        : const TravelerBookingScreen();
  }
}
