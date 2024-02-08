import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

Future<dynamic> getLocationUpdate(
    Location locationController, LatLng? currentPosition, setState) async {
  bool serviceEnabled;
  PermissionStatus permissionGranted;

  serviceEnabled = await locationController.serviceEnabled();
  if (serviceEnabled) {
    serviceEnabled = await locationController.requestService();
  } else {
    return null;
  }
  permissionGranted = await locationController.hasPermission();
  if (permissionGranted == PermissionStatus.denied) {
    permissionGranted = await locationController.requestPermission();
    if (permissionGranted != PermissionStatus.granted) {
      print("Permission not granted");
      return null;
    }
  }
  locationController.onLocationChanged.listen((LocationData currentLocation) {
      setState(() {
        // currentPosition =
        //     LatLng(currentLocation.latitude!, currentLocation.longitude!);
        currentPosition = const LatLng(3.974173294200666, 11.518428016082675);
        print("Current position ${currentPosition.toString()}");
      });
  });
  print(currentPosition);
        return currentPosition;
}
