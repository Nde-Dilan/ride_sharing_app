import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ride_sharing_app/utils/bitmap_converter.dart';
import 'package:ride_sharing_app/utils/get_location_uptdate.dart';
// import 'package:ride_sharing_app/utils/show_ride_pop_up.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Set<Marker> _markers = {};
  Location locationController = Location();

  static const LatLng driver2Position =
       LatLng(3.951479764903749, 11.516876187997934);
  static const LatLng driver1Position =
      LatLng(3.9322991741267597, 11.519730058376451);
  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    asyncInitState();
    _addMarkers();
  }

  void asyncInitState() async {
    currentPosition =
        await getLocationUpdate(locationController, currentPosition, setState);
    currentPosition = const LatLng(3.951479764903749, 11.516876187997934);
    // print("This is inside the initState $currentPosition");
    _addMarkers();
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
                  const CameraPosition(target: driver2Position, zoom: 14),
              markers: {_markers.elementAt(2), _markers.elementAt(0)},
            ),
    );
  }

  void _addMarkers() async {
    final BitmapDescriptor driverIcon1 =
        await bitmapDescriptorFromSvgAsset('assets/icons/red_car.svg');
    final Marker driver1Marker = const Marker(
      markerId: MarkerId('Driver'),
      infoWindow: InfoWindow(title: "Car Driver", snippet: "Cameroon"),
      // icon: driverIcon1,
      position: driver1Position,
    );

    final BitmapDescriptor driverIcon2 =
        await bitmapDescriptorFromSvgAsset('assets/icons/green_car.svg');
    final Marker driver2Marker = Marker(
      markerId: const MarkerId('Driver 2'),
      infoWindow: const InfoWindow(title: "Car Driver", snippet: "Cameroon"),
      icon: driverIcon2,
      position: driver2Position,
    );

    final BitmapDescriptor passengerIcon =
        await bitmapDescriptorFromSvgAsset('assets/icons/passenger.svg');
    final Marker currentMarker = Marker(
      markerId: const MarkerId('passenger'),
      infoWindow:
          const InfoWindow(title: "Current Position", snippet: "Passenger"),
      icon: passengerIcon, //TODO: Change the position to the current position
      position: currentPosition!,
    );

    setState(() {
      _markers
        ..add(driver1Marker)
        ..add(driver2Marker)
        ..add(currentMarker);
    });
  }
}
