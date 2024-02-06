import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ride_sharing_app/driver.dart';


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

  late final Marker _ubaBank = Marker(
      onTap: () {
        _showRiderPopup(const RiderData(
            id: "id",
            name: "name",
            number: '+237 6 78 90 12 34',
            isActive: true,
            rating: "rating",
            vehicleType: "vehicleType",
            position: ubaBank));
      },
      markerId: const MarkerId('destination'),
      infoWindow: const InfoWindow(title: "UBA", snippet: "Cameroon"),
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

  void _showRiderPopup(RiderData riderData) {
    final double screenWidth = MediaQuery.of(context).size.width;

    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        // height: 500,
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Adjust height based on content
          children: [
            const Center(
              child: Text(
                "Driver Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              children: [
                const Text(
                  "Name: ",
                  style: TextStyle(fontSize: 18),
                ),
                Text(riderData.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "Vehicle: ",
                  style: TextStyle(fontSize: 18),
                ),
                Text(riderData.vehicleType,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "Rating: ",
                  style: TextStyle(fontSize: 18),
                ),
                Text("${riderData.rating}/6 (over 500 ratings)",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Text(
                  "Available: ",
                  style: TextStyle(fontSize: 18),
                ),
                Text(riderData.isActive ? "True" : "False",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18)),
              ],
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 240, 37, 23)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(
                          color: Color.fromARGB(255, 240, 37, 23),
                          width: 2.0,
                          style:
                              BorderStyle.solid), // Adjust the radius as needed
                    )),
                    minimumSize:
                        MaterialStatePropertyAll(Size(screenWidth * 0.25, 54)),
                  ),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 255, 255, 255), //6350FF
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(
                  width: screenWidth * 0.2,
                ),
                TextButton(
                  onPressed: () => _launchCall(riderData.number),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 105, 235, 53)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),

                      side: const BorderSide(
                          color: Color.fromARGB(255, 105, 235, 53),
                          width: 2.0,
                          style:
                              BorderStyle.solid), // Adjust the radius as needed
                    )),
                    minimumSize:
                        MaterialStatePropertyAll(Size(screenWidth * 0.25, 54)),
                  ),
                  child: const Text(
                    "Call Driver",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromARGB(255, 255, 255, 255), //6350FF
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ],
        ),
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
          currentPosition = const LatLng(3.974173294200666, 11.518428016082675);
          print("Current position ${currentPosition.toString()}");
        });
      }
    });
  }

  _launchCall(String number) {}
}
