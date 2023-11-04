import 'package:flutter/material.dart';
import 'package:frontend/common/utils/global_utils.dart';
import 'package:frontend/identity_access_management/api/index.dart';
import 'package:frontend/travel_experience_design_maintenance/api/index.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/filter_model.dart';
import 'package:frontend/travel_experience_design_maintenance/presentation/travel_experience_design_maintenance/trip_card.dart';
import 'package:provider/provider.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({Key? key}) : super(key: key);

  @override
  State<TripListScreen> createState() {
    return _TripListScreenState();
  }
}

class _TripListScreenState extends State<TripListScreen> {
  final isLoading = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    loadData().then((value) {
      setStateIfMounted(false);
    });
  }

  Future<void> loadData() async {
    final travelExperienceDesignMaintenanceProvider =
        Provider.of<TravelExperienceDesignMaintenanceApi>(context,
            listen: false);
    final iamProvider =
        Provider.of<IdentityAccessManagementApi>(context, listen: false);

    if (travelExperienceDesignMaintenanceProvider.trips.isEmpty) {
      await travelExperienceDesignMaintenanceProvider.getTrips(
          iamProvider.token, FilterModel());
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
    final travelExperienceDesignMaintenanceProvider =
        Provider.of<TravelExperienceDesignMaintenanceApi>(context);
    final iamProvider = Provider.of<IdentityAccessManagementApi>(context);

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
              await travelExperienceDesignMaintenanceProvider.getTrips(
                  iamProvider.token, FilterModel());
              setStateIfMounted(false);
            },
            child: travelExperienceDesignMaintenanceProvider.trips.isEmpty
                ? const Center(
                    child: Text('No trips found',
                        style: TextStyle(color: Colors.white)))
                : ListView.separated(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    padding: EdgeInsets.all(
                        Utils.responsiveValue(context, 8.0, 16.0, 400)),
                    itemBuilder: (ct, i) => TripCard(
                        trip: travelExperienceDesignMaintenanceProvider
                            .getTrip(i),
                        auth: iamProvider),
                    separatorBuilder: (_, __) => SizedBox(
                        height: Utils.responsiveValue(context, 8.0, 16.0, 400)),
                    itemCount: travelExperienceDesignMaintenanceProvider.size,
                  ),
          );
        }
      },
    );
  }
}
