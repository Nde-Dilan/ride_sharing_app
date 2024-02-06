import 'package:google_maps_flutter/google_maps_flutter.dart';

class RiderData {
  final String id;
  final String name;
  final String number;
  final bool isActive;
  final String rating;
  final String vehicleType;
  final LatLng position;

  // Add other relevant rider information

  const RiderData({
    required this.id,
    required this.name,
    required this.number,
    required this.isActive,
    required this.rating,
    required this.vehicleType,
    required this.position,
    // Initialize other data fields
  });
}