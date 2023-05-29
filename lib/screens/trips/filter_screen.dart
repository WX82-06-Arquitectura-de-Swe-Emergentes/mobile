import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:frontend/models/trip.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/destination_provider.dart';
import 'package:frontend/providers/trip_provider.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key, required this.token}) : super(key: key);
  final String? token;

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

enum Character { group, private }

class _FilterScreenState extends State<FilterScreen> {
  Character? _character = Character.group;
  final double _currentSliderValue = 20;
  final double _currentSliderValue1 = 1;
  String? _selectedDestination;
  List<Destination> destinations = [];

  @override
  void initState() {
    super.initState();
    
    getDestinations().then((value) {

      if(!value.isEmpty) {
        _selectedDestination = value[0].name;
      }

      setState(() {
        destinations = value;
      });
    });

  }

  Future getDestinations() async {
    final destinationProvider = Provider.of<DestinationProvider>(
      context,
      listen: false,
    );
    if (destinationProvider.destination.isEmpty) {
      return await destinationProvider.getDestinations(widget.token);
    } else {
      return destinationProvider.destination;
    }
  }

  void _applyFilters() {
    final Filter filters = Filter(
      destination: _selectedDestination,
      season: null,
    );
    final tripProvider = Provider.of<TripProvider>(
      context,
      listen: false,
    );

    tripProvider.getTripsFilter(widget.token, filters);

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final token = authProvider.token;

    print("destination selected $_selectedDestination");

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filter Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10.0),
            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                disabledItemFn: (String s) => s.startsWith('I'),
              ),
              items: destinations.map((e) => e.name).toList(),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: "Destinations",
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _selectedDestination = value;
                });
              },
              selectedItem: destinations.isNotEmpty ? destinations[0].name : null,
            )
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: _applyFilters,
          child: Text('Apply Filters'),
        ),
      ),
    );
  }
}
