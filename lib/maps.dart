import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

// sets a constant Initial Camera Position to the inital zoom and positioning of map
const initialCameraPosition = CameraPosition(
  target: LatLng(34.109298, -117.986247),
  zoom: 16.7,
  tilt: 40.0,
  bearing: 294.0,
);

Future<List<Marker>> loadMarkers(void Function(Marker) onTap) async {
  final String response =
      await rootBundle.loadString('assets/irwindalelocations.json');
  final data = json.decode(response);

  // pulls data from the irwindalelocations json file and maps data to each marker
  List<Marker> markers = List<Marker>.from(data.map((item) => Marker(
        markerId: MarkerId(item['name']),
        position: LatLng(item['lon'].toDouble(), item['lat'].toDouble()),
        icon: BitmapDescriptor.defaultMarker,
        onTap: () => onTap(Marker(
            markerId: MarkerId(item['name']),
            position: LatLng(item['lon'].toDouble(), item['lat'].toDouble()))),
      )));

  return markers;
}

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  PlatformMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<List<Marker>>(
            future: loadMarkers(zoomInOnMarker),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return PlatformMap(
                  initialCameraPosition: initialCameraPosition,
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  mapType: MapType.satellite,
                  markers: Set<Marker>.from(snapshot.data!),
                  myLocationEnabled: true,
                );
              } else if (snapshot.hasError) {
                return const Center(child: Text("Error loading markers"));
              }
              return const Center(child: CircularProgressIndicator());
            },
          ),

          // reset button added to top left corner to reset map to original position
          Positioned(
            top: 60,
            left: 20,
            child: IconButton(
                icon: const Icon(Icons.zoom_out_map_outlined, size: 40.0),
                onPressed: () => resetCamera(),
                color: const Color.fromARGB(255, 0, 0, 0),
                tooltip: 'Reset Zoom'),
          ),
        ],
      ),
    );
  }

  // zooms into marker position of the marker that is clicked on
  void zoomInOnMarker(Marker marker) {
    mapController?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: marker.position,
        zoom: 20.0,
        tilt: 40.0,
        bearing: 294.0,
      ),
    ));
  }

  // resets camera to original position
  void resetCamera() {
    mapController
        ?.animateCamera(CameraUpdate.newCameraPosition(initialCameraPosition));
  }
}
