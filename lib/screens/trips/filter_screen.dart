import 'package:flutter/material.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({Key? key}) : super(key: key);

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
              'Confirmation time',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            Slider(
              value: _currentSliderValue1,
              max: 24,
              divisions: 24,
              label: _currentSliderValue1.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _currentSliderValue1 = value;
                });
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Type of tour',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            ListTile(
              title: const Text('In group'),
              leading: Radio<Character>(
                value: Character.group,
                groupValue: _character,
                onChanged: (Character? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Private'),
              leading: Radio<Character>(
                value: Character.private,
                groupValue: _character,
                onChanged: (Character? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Categories',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            ListTile(
              title: const Text('Private'),
              leading: Radio<Character>(
                value: Character.group,
                groupValue: _character,
                onChanged: (Character? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Private'),
              leading: Radio<Character>(
                value: Character.group,
                groupValue: _character,
                onChanged: (Character? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Private'),
              leading: Radio<Character>(
                value: Character.group,
                groupValue: _character,
                onChanged: (Character? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Private'),
              leading: Radio<Character>(
                value: Character.group,
                groupValue: _character,
                onChanged: (Character? value) {
                  setState(() {
                    _character = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 15),
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
