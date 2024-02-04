import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

//AIzaSyBEK8mpjkwNXSjmNXOHwiBaXf0-F4H8ljM

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Location locationController = Location();

  static const LatLng ubaBank = LatLng(3.8780000141637663, 11.516530312595192);
  static const LatLng dispenssaire =
      LatLng(3.9458546821800256, 11.522115494775276);
  LatLng? currentPosition;
  late final Marker currentP = Marker(
      markerId: const MarkerId('Me'),
      infoWindow:
          const InfoWindow(title: "The User", snippet: "Current Position"),
      icon: BitmapDescriptor.defaultMarker,
      position: currentPosition!);

  late final Marker sourceDispenssaire = const Marker(
      markerId: MarkerId('source'),
      infoWindow: InfoWindow(title: "MESSASSI", snippet: "Cameroon"),
      icon: BitmapDescriptor.defaultMarker,
      position: dispenssaire);

  late final Marker _ubaBank = const Marker(
      markerId: MarkerId('destination'),
      infoWindow: InfoWindow(title: "UBA", snippet: "Cameroon"),
      icon: BitmapDescriptor.defaultMarker,
      position: ubaBank);

  @override
  void initState() {
    super.initState();
    getLocationUpdate();
  }

  @override
  Widget build(BuildContext context) {
    // final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: currentPosition == null
          ? Center(
              child: Column(children: [
              SizedBox(
                height: screenHeight * 0.5,
              ),
              const CircularProgressIndicator(),
              const Text("Loading ... ")
            ]))
          : GoogleMap(
              initialCameraPosition:
                  const CameraPosition(target: ubaBank, zoom: 14),
              markers: {sourceDispenssaire, _ubaBank, currentP},
            ),
    );
  }

  Future<void> getLocationUpdate() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locationController.serviceEnabled();
    if (serviceEnabled) {
      serviceEnabled = await locationController.requestService();
    } else {
      return;
    }
    permissionGranted = await locationController.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await locationController.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    locationController.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          // currentPosition =
          //     LatLng(currentLocation.latitude!, currentLocation.longitude!);
          currentPosition =
              const LatLng(3.974173294200666, 11.518428016082675);
          print("Current position ${currentPosition.toString()}");
        });
      }
    });
  }
}
