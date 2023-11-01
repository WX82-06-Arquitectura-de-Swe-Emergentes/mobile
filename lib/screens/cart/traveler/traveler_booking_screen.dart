import 'package:flutter/material.dart';
import 'package:frontend/models/booking_model.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/booking_provider.dart';
import 'package:frontend/screens/cart/traveler/traveler_booking_card.dart';
import 'package:frontend/shared/globals.dart';
import 'package:frontend/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class TravelerBookingScreen extends StatefulWidget {
  const TravelerBookingScreen({Key? key}) : super(key: key);

  @override
  State<TravelerBookingScreen> createState() {
    return _TravelerBookingScreenState();
  }
}

class _TravelerBookingScreenState extends State<TravelerBookingScreen> {
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
    await bookingProvider.getTravelerTripsBookingsDetails(token!);
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
    final bookingsDetails = bookingProvider.bookings;

    if (bookingsDetails == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    return DefaultTabController(
      length: 2, // Número de pestañas
      child: Scaffold(
        backgroundColor: Globals.backgroundColor,
        bottomNavigationBar: const AppBarBack(),
        appBar: AppBar(
          title: const Text(
            // Título de la AppBar
            'Mis Reservas',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.directions_car),
                text: 'Próximos',
              ),
              Tab(
                icon: Icon(Icons.directions_transit),
                text: 'Pasados',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Contenido de la pestaña 1
            UpcomingBookingsTab(data: bookingsDetails.upcomingBookings),
            // Contenido de la pestaña 2
            PastBookingsTab(data: bookingsDetails.pastBookings),
          ],
        ),
      ),
    );
  }
}

class UpcomingBookingsTab extends StatelessWidget {
  const UpcomingBookingsTab({Key? key, required this.data}) : super(key: key);
  final List<BookingModel> data;

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context, listen: true);
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    return RefreshIndicator(
      onRefresh: () async {
        final String? token = authProvider.token;
        await bookingProvider.getAgencyTripsBookingsDetails(token!);
      },
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final bookings = data[index];
          return TravelerBookingCard(data: bookings);
        },
      ),
    );
  }
}

class PastBookingsTab extends StatelessWidget {
  const PastBookingsTab({Key? key, required this.data}) : super(key: key);
  final List<BookingModel> data;

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context, listen: true);
    final authProvider = Provider.of<AuthenticationProvider>(
      context,
      listen: false,
    );

    return RefreshIndicator(
      onRefresh: () async {
        final String? token = authProvider.token;
        await bookingProvider.getAgencyTripsBookingsDetails(token!);
      },
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final bookings = data[index];
          return TravelerBookingCard(data: bookings);
        },
      ),
    );
  }
}
