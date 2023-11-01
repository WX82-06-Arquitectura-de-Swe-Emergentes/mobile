import 'package:flutter/material.dart';
import 'package:frontend/models/agency_booking.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/booking_provider.dart';
import 'package:frontend/screens/cart/agency/agency_booking_card.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/utils/global_utils.dart';
import 'package:frontend/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class AgencyBookingScreen extends StatefulWidget {
  const AgencyBookingScreen({Key? key}) : super(key: key);

  @override
  State<AgencyBookingScreen> createState() {
    return _AgencyBookingScreenState();
  }
}

class _AgencyBookingScreenState extends State<AgencyBookingScreen> {
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
    final String? token = authProvider.token;
    await bookingProvider.getAgencyTripsBookingsDetails(token!);
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
    final bookingsDetails = bookingProvider.bookings;

    return Scaffold(
        backgroundColor: Globals.backgroundColor,
        bottomNavigationBar: const AppBarBack(),
        appBar: AppBar(
          title: const Text("Agency Bookings"),
          backgroundColor: Globals.redColor,
        ),
        body: ValueListenableBuilder<bool>(
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
                  await bookingProvider.getAgencyTripsBookingsDetails(token!);
                  setStateIfMounted(false);
                },
                child: bookingsDetails.isEmpty
                    ? const Center(
                        child: Text('No bookings found',
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.white)))
                    : BookingDetails(data: bookingsDetails),
              );
            }
          },
        ));
  }
}

class BookingDetails extends StatelessWidget {
  final List<AgencyBookingView> data;

  const BookingDetails({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      padding: EdgeInsets.all(Utils.responsiveValue(context, 8.0, 10.0, 400)),
      itemBuilder: (ct, i) => AgencyBookingCard(data: data.elementAt(i)),
      separatorBuilder: (_, __) =>
          SizedBox(height: Utils.responsiveValue(context, 8.0, 16.0, 400)),
      itemCount: data.length,
    );
  }
}
