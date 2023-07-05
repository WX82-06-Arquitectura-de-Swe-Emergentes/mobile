import 'package:flutter/material.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/trip_provider.dart';
import 'package:frontend/screens/trips/trip_card.dart';
import 'package:frontend/utils/global_utils.dart';
import 'package:provider/provider.dart';

class RoleTripListScreen extends StatefulWidget {
  const RoleTripListScreen({Key? key}) : super(key: key);

  @override
  State<RoleTripListScreen> createState() {
    return _RoleTripListScreenState();
  }
}

class _RoleTripListScreenState extends State<RoleTripListScreen> {
  final isLoading = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();

    getData().then((value) {
      setStateIfMounted(false);
    });
  }

  Future<void> getData() async {
    final tripProvider = Provider.of<TripProvider>(context, listen: false);
    final authProvider =
        Provider.of<AuthenticationProvider>(context, listen: false);

    if (tripProvider.trips.isEmpty) {
      await tripProvider.getTripsByRoleViaToken(authProvider.token, null);
    }
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
    final tripProvider = Provider.of<TripProvider>(context);
    final authProvider = Provider.of<AuthenticationProvider>(context);

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
              await tripProvider.getTripsByRoleViaToken(
                  authProvider.token, null);
              setStateIfMounted(false);
            },
            child: tripProvider.trips.isEmpty
                ? const Center(
                    child: Text('No trips found',
                        style: TextStyle(color: Colors.white)))
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(
                        Utils.responsiveValue(context, 8.0, 16.0, 400)),
                    itemBuilder: (ct, i) => TripCard(
                        trip: tripProvider.trips[i], auth: authProvider),
                    separatorBuilder: (_, __) => SizedBox(
                        height: Utils.responsiveValue(context, 8.0, 16.0, 400)),
                    itemCount: tripProvider.trips.length,
                  ),
          );
        }
      },
    );
  }
}
