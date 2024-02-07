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
      LatLng(3.8780000141637663, 11.516530312595192);
  static const LatLng driver1Position =
      LatLng(3.9458546821800256, 11.522115494775276);
  LatLng? currentPosition;

  @override
  void initState() {
    super.initState();
    getLocationUpdate(locationController, currentPosition, setState);
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
              markers: {_markers.elementAt(0), _markers.elementAt(1)},
            ),
    );
  }

  void _addMarkers() async {
    final BitmapDescriptor driverIcon1 =
        await bitmapDescriptorFromSvgAsset('assets/icons/red_car.svg');
    final Marker sourceMarker = Marker(
      markerId: const MarkerId('Driver'),
      infoWindow: const InfoWindow(title: "Car Driver", snippet: "Cameroon"),
      icon: driverIcon1,
      position: driver1Position,
    );

    final BitmapDescriptor driverIcon2 =
        await bitmapDescriptorFromSvgAsset('assets/icons/green_bus.svg');
    final Marker ubaMarker = Marker(
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
      position: const LatLng(3.9458546821800256, 11.522115494775276),
    );

    setState(() {
      _markers
        ..add(sourceMarker)
        ..add(ubaMarker)
        ..add(currentMarker);
    });
  }
}
