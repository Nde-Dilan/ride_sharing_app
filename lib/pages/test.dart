import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ride_sharing_app/driver.dart';

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final Map<MarkerId, RiderData> ridersData = {
    const MarkerId('rider_1'): const RiderData(
      id: '1',
      name: 'John Doe',
      number: '+237 6 78 90 12 34',
      isActive: true,
      rating: '4.8',
      vehicleType: 'Sedan',
      position: LatLng(3.8720058, 11.5152754),
    ),
    // Add data for other riders
  };
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}


/**
 * E/Google Android Maps SDK(11191): Authorization failure.  Please see https://developers.google.com/maps/documentation/android-sdk/start for how to correctly set up the map.
E/Google Android Maps SDK(11191): In the Google Developer Console (https://console.developers.google.com)
E/Google Android Maps SDK(11191): Ensure that the "Maps SDK for Android" is enabled.
E/Google Android Maps SDK(11191): Ensure that the following Android Key exists:
E/Google Android Maps SDK(11191): 	API Key: AIzaSyDJND-vHwJxAFkRfdfn1tyK8P-RqtiLu2g
E/Google Android Maps SDK(11191): 	Android Application (<cert_fingerprint>;<package_name>): D6:BB:58:E4:78:81:45:55:77:6A:45:CD:5F:9C:E3:8D:47:43:51:3E;com.example.ride_sharing_app
 */