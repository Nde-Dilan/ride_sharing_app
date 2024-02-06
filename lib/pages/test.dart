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
    number:'+237 6 78 90 12 34',
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