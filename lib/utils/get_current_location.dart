 import 'package:google_maps_flutter/google_maps_flutter.dart';

Marker getCurrentP(currentPosition) {
    return Marker(
        markerId: const MarkerId('Me'),
        infoWindow:
            const InfoWindow(title: "The User", snippet: "Current Position"),
        icon: BitmapDescriptor.defaultMarker,
        position: currentPosition!);
  }