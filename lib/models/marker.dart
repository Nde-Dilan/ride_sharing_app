import 'package:google_maps_flutter/google_maps_flutter.dart';

class CustomMarker {
  late final Marker marker;

  CustomMarker({
    required LatLng position,
    required String markerId,
    required String title,
    required String snippet,
    required Function onTap,
  }) {
    marker = Marker(
      onTap: onTap as void Function()?,
      markerId: MarkerId(markerId),
      infoWindow: InfoWindow(title: title, snippet: snippet),
      icon: BitmapDescriptor.defaultMarker,
      position: position,
    );
  }
}
