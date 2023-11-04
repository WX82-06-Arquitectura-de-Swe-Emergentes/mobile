import 'package:flutter/material.dart';
import 'package:frontend/common/shared/globals.dart';
import 'package:frontend/common/utils/global_utils.dart';
import 'package:frontend/travel_experience_design_maintenance/api/index.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/destination.dart';
import 'package:frontend/travel_experience_design_maintenance/domain/entities/season.dart';
import 'package:frontend/travel_experience_design_maintenance/infrastructure/models/filter_model.dart';

import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key, required this.token}) : super(key: key);
  final String token;

  @override
  State<FilterScreen> createState() {
    return _FilterScreenState();
  }
}

const double minPrice = 0;
const double maxPrice = 8000;

class _FilterScreenState extends State<FilterScreen> {
  RangeValues _currentRangeValues = const RangeValues(minPrice, maxPrice);
  dynamic _selectedDestination;
  dynamic _selectedSeason;
  List<Destination> destinations = [];
  List<Season> seasons = [];

  late TravelExperienceDesignMaintenanceApi
      travelExperienceDesignMaintenanceProvider;

  @override
  void initState() {
    super.initState();

    travelExperienceDesignMaintenanceProvider =
        Provider.of<TravelExperienceDesignMaintenanceApi>(context,
            listen: false);

    loadDestinations().then(
      (value) {
        if (mounted) {
          setState(() {
            destinations = value;
          });
        }
      },
    );

    loadSeasons().then(
      (value) {
        if (mounted) {
          setState(() {
            seasons = value;
          });
        }
      },
    );
  }

  void setFilterCallback(int currentIndex) {}

  Future loadDestinations() async {
    if (travelExperienceDesignMaintenanceProvider.destinations.isEmpty) {
      return await travelExperienceDesignMaintenanceProvider
          .getDestinations(widget.token);
    } else {
      return travelExperienceDesignMaintenanceProvider.destinations;
    }
  }

  Future loadSeasons() async {
    if (travelExperienceDesignMaintenanceProvider.seasons.isEmpty) {
      return await travelExperienceDesignMaintenanceProvider
          .getSeasons(widget.token);
    } else {
      return travelExperienceDesignMaintenanceProvider.seasons;
    }
  }

  void _applyFilters() {
    final FilterModel filters = FilterModel(
      destination: _selectedDestination,
      season: _selectedSeason,
      minPrice: _currentRangeValues.start,
      maxPrice: _currentRangeValues.end,
    );

    travelExperienceDesignMaintenanceProvider.getTrips(widget.token, filters);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Globals.backgroundColor,
        appBar: AppBar(
          title: const Text('Filter'),
          backgroundColor: Globals.redColor,
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                _applyFilters();
              },
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDestination = null;
                    _selectedSeason = null;
                    _currentRangeValues = const RangeValues(minPrice, maxPrice);
                  });
                },
                child: const Text(
                  'Reset',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Destination',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final destination = await showModalBottomSheet<
                                        String>(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return FractionallySizedBox(
                                            heightFactor: 0.9,
                                            child: Scaffold(
                                                backgroundColor:
                                                    Globals.backgroundColor,
                                                body: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.all(16),
                                                      child: Text(
                                                        'All Destinations',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: Utils
                                                            .responsiveValue(
                                                                context,
                                                                12.0,
                                                                24.0,
                                                                400),
                                                        child: const Divider(
                                                            color: Colors
                                                                .white24)),
                                                    Expanded(
                                                      child: ListView.builder(
                                                        itemCount:
                                                            destinations.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          final destination =
                                                              destinations[
                                                                  index];
                                                          final previousDestination =
                                                              index > 0
                                                                  ? destinations[
                                                                      index - 1]
                                                                  : null;
                                                          final showDivider =
                                                              previousDestination ==
                                                                      null ||
                                                                  destination.name[
                                                                          0] !=
                                                                      previousDestination
                                                                          .name[0];
                                                          return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              if (showDivider)
                                                                AlphabetDivider(
                                                                    text: destination
                                                                        .name[0]),
                                                              ListTile(
                                                                title: Text(
                                                                  destination
                                                                      .name,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                trailing: Icon(
                                                                  Icons
                                                                      .circle_rounded,
                                                                  color: _selectedDestination ==
                                                                          destination
                                                                              .name
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context,
                                                                      destination
                                                                          .name);
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                )));
                                      });
                                    });
                                setState(() {
                                  _selectedDestination = destination;
                                });
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    'View All',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ),
                    if (_selectedDestination != null)
                      Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.all(12),
                            child: Text(
                              '$_selectedDestination',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          )),
                    SizedBox(
                        height: Utils.responsiveValue(context, 12.0, 24.0, 400),
                        child: const Divider(color: Colors.white24)),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Season',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                final season = await showModalBottomSheet<
                                        String>(
                                    context: context,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return StatefulBuilder(builder:
                                          (BuildContext context,
                                              StateSetter setState) {
                                        return FractionallySizedBox(
                                            heightFactor: 0.9,
                                            child: Scaffold(
                                                backgroundColor:
                                                    Globals.backgroundColor,
                                                body: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    const Padding(
                                                      padding:
                                                          EdgeInsets.all(16),
                                                      child: Text(
                                                        'All Seasons',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                        height: Utils
                                                            .responsiveValue(
                                                                context,
                                                                12.0,
                                                                24.0,
                                                                400),
                                                        child: const Divider(
                                                            color: Colors
                                                                .white24)),
                                                    Expanded(
                                                      child: ListView.builder(
                                                        itemCount:
                                                            seasons.length,
                                                        itemBuilder:
                                                            (BuildContext
                                                                    context,
                                                                int index) {
                                                          final season =
                                                              seasons[index];
                                                          final previousSeason =
                                                              index > 0
                                                                  ? seasons[
                                                                      index - 1]
                                                                  : null;
                                                          final showDivider =
                                                              previousSeason ==
                                                                      null ||
                                                                  season.name[
                                                                          0] !=
                                                                      previousSeason
                                                                          .name[0];
                                                          return Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              if (showDivider)
                                                                AlphabetDivider(
                                                                    text: season
                                                                        .name[0]),
                                                              ListTile(
                                                                title: Text(
                                                                  season.name,
                                                                  style:
                                                                      const TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        20,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                                trailing: Icon(
                                                                  Icons
                                                                      .circle_rounded,
                                                                  color: _selectedSeason ==
                                                                          season
                                                                              .name
                                                                      ? Colors
                                                                          .red
                                                                      : Colors
                                                                          .white,
                                                                ),
                                                                onTap: () {
                                                                  Navigator.pop(
                                                                      context,
                                                                      season
                                                                          .name);
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                )));
                                      });
                                    });
                                setState(() {
                                  _selectedSeason = season;
                                });
                              },
                              child: const Row(
                                children: [
                                  Text(
                                    'View All',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                            )
                          ]),
                    ),
                    if (_selectedSeason != null)
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            '$_selectedSeason',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    SizedBox(
                        height: Utils.responsiveValue(context, 12.0, 24.0, 400),
                        child: const Divider(color: Colors.white24)),
                    Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  // Season Filter
                                  const Text(
                                    'Price',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    'S/.${_currentRangeValues.start.round()} - S/.${_currentRangeValues.end.round()}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                    ),
                                  ),
                                ]),
                            const SizedBox(height: 16),
                            RangeSlider(
                              values: _currentRangeValues,
                              min: minPrice,
                              max: maxPrice,
                              divisions: 50,
                              labels: RangeLabels(
                                _currentRangeValues.start.round().toString(),
                                _currentRangeValues.end.round().toString(),
                              ),
                              onChanged: (RangeValues values) {
                                setState(() {
                                  _currentRangeValues = values;
                                });
                              },
                            ),
                          ],
                        )),
                  ],
                )),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    _applyFilters();
                  },
                  child: const Text('Apply Changes'),
                ),
              ),
            )
          ],
        ));
  }
}

class AlphabetDivider extends StatelessWidget {
  final String text;

  const AlphabetDivider({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Container(
            // set color transparent
            color: Globals.primaryColor,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )),
      ),
    ]);
  }
}
