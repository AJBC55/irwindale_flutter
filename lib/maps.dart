import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

const initialCameraPosition = CameraPosition(
  target: LatLng(34.109298, -117.986247),
  zoom: 16.7,
  tilt: 40.0,
  bearing: 294.0,
);

Future<List<Marker>> loadMarkers(
    void Function(Marker) zoomInOnMarker,
    void Function(Map<String, dynamic>, LatLng) showInfoBox,
    BuildContext context) async {
  final String response =
      await rootBundle.loadString('assets/irwindalelocations.json');
  final data = json.decode(response);

  List<Marker> markers = List<Marker>.from(data.map((item) => Marker(
        markerId: MarkerId(item['name']),
        position: LatLng(item['lon'].toDouble(), item['lat'].toDouble()),
        icon: BitmapDescriptor.defaultMarker,
        onTap: () {
          Marker marker = Marker(
              markerId: MarkerId(item['name']),
              position: LatLng(item['lat'].toDouble(), item['lon'].toDouble()));
          zoomInOnMarker(marker);
          showInfoBox(item, marker.position);
        },
      )));

  return markers;
}

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  PlatformMapController? mapController;
  Map<String, dynamic>? selectedData;
  LatLng? selectedPosition;

  @override
  void initState() {
    super.initState();
    loadMarkers(zoomInOnMarker, showInfoBox, context).then((loadedMarkers) {
      setState(() {
        markers = loadedMarkers;
      });
    });
  }

  List<Marker> markers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          markers.isNotEmpty
              ? PlatformMap(
                  initialCameraPosition: initialCameraPosition,
                  onMapCreated: (controller) {
                    mapController = controller;
                  },
                  mapType: MapType.satellite,
                  markers: Set<Marker>.from(markers),
                  myLocationEnabled: true,
                )
              : const Center(child: CircularProgressIndicator()),
          if (selectedData != null && selectedPosition != null)
            Positioned(
              bottom: 50,
              left: 10,
              right: 10,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 5),
                ),
                child: Card(
                  color: Colors.grey[200],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                selectedData!['name'].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                setState(() {
                                  selectedData = null;
                                  selectedPosition = null;
                                });
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 1),
                        Text('${selectedData!['description']}'),
                        SizedBox(height: 20),
                        if (selectedData!['img_link'] != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black, width: 3),
                              ),
                              child: Image.asset(
                                selectedData!['img_link'],
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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

  void resetCamera() {
    mapController
        ?.animateCamera(CameraUpdate.newCameraPosition(initialCameraPosition));
  }

  void showInfoBox(Map<String, dynamic> data, LatLng position) {
    resetCamera();
    setState(() {
      selectedData = data;
      selectedPosition = position;
    });
  }
}