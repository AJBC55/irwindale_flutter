import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<List<Marker>> loadMarkers() async {
  final String response = await rootBundle.loadString('assets/irwindalelocations.json');
  final data = json.decode(response);
  List<Marker> markers = List<Marker>.from(data.map((item) => Marker(
    markerId: MarkerId(item['name']),
    position: LatLng(item['lat'].toDouble(), item['lon'].toDouble()),
    infoWindow: InfoWindow(
      title: item['name'],
      snippet: item['description'],
    ),
    icon: BitmapDescriptor.defaultMarker,
  )));
  return markers;
}

class MapView extends StatelessWidget {
  final Future<List<Marker>> _markers = loadMarkers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Marker>>(
        future: _markers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PlatformMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(34.109298, -117.986247), // Example central coordinate
                zoom: 16.7,
                tilt: 40.0,
                bearing: 294.0,
              ),
              mapType: MapType.satellite,
              markers: Set<Marker>.of(snapshot.data!),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error loading markers"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}