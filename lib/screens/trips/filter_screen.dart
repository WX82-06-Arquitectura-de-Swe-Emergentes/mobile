import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:frontend/providers/auth_provider.dart';
import 'package:frontend/providers/destination_provider.dart';
import 'package:frontend/providers/season_provider.dart';
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
  double _currentSliderValue = 20;
  double _currentSliderValue1 = 1;
  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    final token = authProvider.token;

    final destinationProvider =
        Provider.of<DestinationProvider>(context, listen: false);
    final destinations = destinationProvider.destination;

    final seasonPorvider = Provider.of<SeasonProvider>(context, listen: false);
    final seasons = seasonPorvider.season;

    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            const Text(
              'Filters',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.black),
            ),
            const SizedBox(height: 20),
            const Text(
              'Price',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Slider(
              value: _currentSliderValue,
              max: 1000,
              divisions: 500,
              label: _currentSliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                });
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Destination',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Enter your destination',
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              'Categories',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 5),
            ValueListenableBuilder(
              valueListenable: ValueNotifier(_character),
              builder: (ct, value, _) => DropdownSearch<String>(
                  //mode: Mode.MENU,
                  //showSelectedItem: true,
                  items: destinations.map((e) => e.name).toList(),
                  //label: "Menu mode",
                  // hint: "country in menu mode",
                  // popupItemDisabled: (String s) => s.startsWith('I'),
                  onChanged: print,
                  selectedItem: "Brazil"),
            ),
            const SizedBox(height: 15),
            const Text(
              'Seasons',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 5),
            DropdownSearch<String>(
                //mode: Mode.MENU,
                //showSelectedItem: true,
                items: seasons.map((e) => e.name).toList(),
                //label: "Menu mode",
                // hint: "country in menu mode",
                // popupItemDisabled: (String s) => s.startsWith('I'),
                onChanged: print,
                selectedItem: "Brazil"),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Accept'),
            )
          ],
        ),
      ),
    );
  }
}
