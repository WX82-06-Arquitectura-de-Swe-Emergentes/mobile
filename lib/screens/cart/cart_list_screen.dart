import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/booking_provider.dart';
import 'package:frontend/screens/cart/booking_card.dart';
import 'package:frontend/utils/global_utils.dart';
import 'package:provider/provider.dart';

class CartListScreen extends StatefulWidget {
  const CartListScreen({Key? key}) : super(key: key);

  @override
  State<CartListScreen> createState() {
    return _CartListScreenState();
  }
}

class _CartListScreenState extends State<CartListScreen> {
  final isLoading = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();

    getData().then((value) {
      setState(() {
        isLoading.value = false;
      });
    });
  }

  Future<void> getData() async {
    final bookingProvider = Provider.of<BookingProvider>(
      context,
      listen: false,
    );
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    // if (bookingProvider.bookings.isEmpty) {
    final String? token = authProvider.token;
    final String? role = authProvider.role;
    await bookingProvider.getBookings(token!, role!);
    // }
  }

  void setStateIfMounted(f) {
    if (mounted) {
      setState(() {
        isLoading.value = f;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context, listen: true);
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );
    final bookings = bookingProvider.bookings;

    return ValueListenableBuilder<bool>(
      valueListenable: isLoading,
      builder: (ct, value, _) {
        if (value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return RefreshIndicator(
            onRefresh: () async {
              setStateIfMounted(true);
              final String? token = authProvider.token;
              final String? role = authProvider.role;
              await bookingProvider.getBookings(token!, role!);
              setStateIfMounted(false);
            },
            child: bookings.isEmpty
                ? const Center(
                    child: Text('No bookings found',
                        style: TextStyle(fontSize: 18.0, color: Colors.white)))
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(
                        Utils.responsiveValue(context, 8.0, 10.0, 400)),
                    itemBuilder: (ct, i) =>
                        BookingCard(booking: bookings[i], auth: authProvider),
                    separatorBuilder: (_, __) => SizedBox(
                        height: Utils.responsiveValue(context, 8.0, 16.0, 400)),
                    itemCount: bookings.length,
                  ),
          );
        }
      },
    );
  }
}
