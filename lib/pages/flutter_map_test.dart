import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// import 'package:geocoding/geocoding.dart';
import '../widgets/my_input.dart';
// import 'package:flutter_map/plugin_api.dart';

import 'package:geolocator_android/geolocator_android.dart';
import 'package:geolocator_apple/geolocator_apple.dart';

void _registerPlatformInstance() {
  if (Platform.isAndroid) {
    GeolocatorAndroid.registerWith();
  } else if (Platform.isIOS) {
    GeolocatorApple.registerWith();
  }
}

class MyAppMap extends StatefulWidget {
  const MyAppMap({super.key});

  @override
  _MyAppMapState createState() => _MyAppMapState();
}

class _MyAppMapState extends State<MyAppMap> {
  final end = TextEditingController();
  List<LatLng> routepoints = [const LatLng(52.05884, -1.345583)];

  late Future<Position> _currentPosition;

  @override
  void initState() {
    super.initState();
    _registerPlatformInstance();
    _currentPosition = getCurrentPosition();
  }

  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Position>(
      future: _currentPosition,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error getting location'));
        } else {
          Position position = snapshot.data!;
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'My App',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
              ),
              backgroundColor: Colors.grey[500],
            ),
            body: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter:
                        LatLng(position.latitude, position.longitude),
                    initialZoom: 17.2,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.ride_sharing_app',
                    ),
                    CurrentLocationLayer(
                        style: const LocationMarkerStyle(
                      markerSize: Size(40, 40),
                      markerDirection: MarkerDirection.heading,
                      marker: DefaultLocationMarker(
                        child: Icon(
                          Icons.navigation,
                          color: Colors.white,
                        ),
                      ),
                    )),
                     PolylineLayer(
                          polylineCulling: true,
                          polylines: [
                            Polyline(points: routepoints, color: Colors.blue, strokeWidth: 9)
                          ],
                        ),
                    Column(
                      children: [
                        myInput(controler: end, hint: 'Where are you going?'),
                        const SizedBox(height: 13),
                        elevateBtn(context, end),
                      ],
                    )
                  ],
                ),
              ],
            ),
          );
        }
      },
    );
  }

  elevateBtn(BuildContext context, TextEditingController end) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[500]),
        onPressed: () async {
          List<Location> end_l =
              await locationFromAddress(end.text, localeIdentifier: "en_CM");

          var v1 = await _currentPosition;
          var v3 = end_l[0].latitude;
          var v4 = end_l[0].longitude;
          print("object : ${end_l}");

          print("${end.text} : $v3, $v4");

          var url = Uri.parse(
              'http://router.project-osrm.org/route/v1/driving/${v1.longitude},${v1.latitude};$v4,$v3?steps=true&annotations=true&geometries=geojson&overview=full');
          var response = await http.get(url);
          print("response.body : ${response.body}");
          setState(() {
            routepoints = [];
            var routes = jsonDecode(response.body)['routes'][0]['geometry']
                ['coordinates'];
            for (int i = 0; i < routes.length; i++) {
              var route = routes[i].toString();
              route = route.replaceAll("[", "");
              route = route.replaceAll("]", "");
              var lat1 = route.split(',');
              var long1 = route.split(",");
              routepoints
                  .add(LatLng(double.parse(lat1[1]), double.parse(long1[0])));
            }
            print(routepoints);
          });
        },
        child: const Text('Press'));
  }
}
