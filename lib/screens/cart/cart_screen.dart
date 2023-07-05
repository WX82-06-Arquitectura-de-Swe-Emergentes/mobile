import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/screens/cart/cart_list_screen.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    bool isAgency() {
      return authProvider.role == 'AGENCY';
    }

    return Scaffold(
      backgroundColor: Globals.backgroundColor,
      bottomNavigationBar: const AppBarBack(),
      appBar: AppBar(
        title: Text("${isAgency() ? "Agency" : "Traveler"} Bookings"),
        backgroundColor: Globals.redColor,
      ),
      body: const CartListScreen(),
    );
  }
}
