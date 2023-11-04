import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView(
      {Key? key,
      required this.location,
      required this.latitude,
      required this.longitude})
      : super(key: key);
  final String location;
  final double latitude;
  final double longitude;

  @override
  State<MapView> createState() {
    return _MapViewState();
  }
}

class _MapViewState extends State<MapView> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final LatLng center = LatLng(widget.latitude, widget.longitude);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location),
        backgroundColor: Colors.green[700],
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: center,
          zoom: 15.0,
        ),
        markers: {
          Marker(
            markerId: const MarkerId('exact_location'),
            position: center,
          ),
        },
      ),
    );
  }
}
