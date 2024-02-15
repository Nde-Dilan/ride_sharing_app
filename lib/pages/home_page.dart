import 'dart:convert' as convert;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart' as local;
import 'package:ride_sharing_app/driver.dart';
import 'package:ride_sharing_app/utils/convert_to_latlng.dart';
import 'package:ride_sharing_app/utils/decode_polyline.dart';
import 'package:ride_sharing_app/utils/network_utility.dart';
import 'package:ride_sharing_app/utils/show_ride_pop_up.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final Set<Marker> _markers = {};
  Map<PolylineId, Polyline> polylines = {};

  static const LatLng driver2Position =
      LatLng(3.951479764903749, 11.516876187997934);
  static const LatLng driver1Position =
      LatLng(3.9322991741267597, 11.519730058376451);
  LatLng? currentPosition;

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;
  late Future<Position> _currentPosition;
  //Drivers
  final RiderData driver1 = const RiderData(
    id: '1',
    name: "John Doe",
    number: "1234567890",
    isActive: true,
    position: driver1Position,
    vehicleType: "Toyota",
    rating: "4.5",
  );
  @override
  void initState() {
    super.initState();
    // initializeMarkers();
    // print("Markers: $_markers");
    _currentPosition = getCurrentPosition();
  }

  Future<void> initializeMarkers() async {
    await addMarkers();
  }

  Future<Position> getCurrentPosition() {
    return Geolocator.getCurrentPosition();
  }

  @override
  Widget build(BuildContext context) {
    //Responsive design

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    //Fields controller

    final TextEditingController destination = TextEditingController();
    final TextEditingController fromController = TextEditingController();
    final TextEditingController toController = TextEditingController();

    return FutureBuilder<Position>(
        future: _currentPosition,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
               drawer: drawer(screenWidth, screenHeight),
              appBar: AppBar(
                title: const Text("Your Map"),
                leading: Builder(builder: (context) {
                  return IconButton(
                    icon: SvgPicture.asset("assets/icons/menu.svg"),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                }),
                actions: [
                  IconButton(
                    icon: SvgPicture.asset("assets/icons/Notification.svg"),
                    onPressed: () {},
                  )
                ],
              ),
              body: Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.4,
                    ),
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 35,
                    ),
                    const Text("Getting things ready..."),
                  ],
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error getting location'));
          } else {
            Position position = snapshot.data!;
            return Scaffold(
              drawer: drawer(screenWidth, screenHeight),
              appBar: AppBar(
                title: const Text("Your Map"),
                leading: Builder(builder: (context) {
                  return IconButton(
                    icon: SvgPicture.asset("assets/icons/menu.svg"),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  );
                }),
                actions: [
                  IconButton(
                    icon: SvgPicture.asset("assets/icons/Notification.svg"),
                    onPressed: () {},
                  )
                ],
              ),
              body: Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: true,
                    mapType: MapType.hybrid,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(position.latitude, position.longitude),
                        zoom: 14),
                    polylines: Set<Polyline>.of(polylines.values),
                    markers:  <Marker>{
                      Marker(
                          markerId:  const MarkerId('Driver'),
                          infoWindow:  const InfoWindow(
                              title: "Car Driver1", snippet: "Cameroon"),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                              BitmapDescriptor.hueGreen),
                          position: driver1Position,
                          onTap: () => showRiderPopup(driver1, context)),
                    },
                    // markers: {_markers.elementAt(0), _markers.elementAt(1)},
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  //TODO: When btn is clicked open a bottom sheet form
                  showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: const Color(0xffffffff),
                      context: context,
                      // barrierDismissible: true,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Form(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // key: _formKey,
                                child: Column(
                                  children: <Widget>[
                                    const Text(
                                      "Where are you going?",
                                      style: TextStyle(
                                          fontSize: 25,
                                          color:
                                              Color.fromARGB(255, 15, 14, 14),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Divider(
                                      color: Color.fromARGB(255, 0, 0, 0),
                                      thickness: 2,
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    TextFormField(
                                      controller: fromController,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        icon: const Icon(Icons.location_on),
                                        hintText: "Current Location",
                                        labelText: 'From',
                                        helperText: "Current Location",
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 48,
                                    ),
                                    TextFormField(
                                      onChanged: (value) {},
                                      controller: toController,
                                      decoration: InputDecoration(
                                        labelText: 'To',
                                        icon: const Icon(Icons.location_on),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                      ),
                                      enableSuggestions: true,
                                      autocorrect: false,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter Where you are going to';
                                        }
                                        return null;
                                      },
                                    ),
                                    const SizedBox(
                                      height: 48,
                                    ),
                                    TextButton(
                                      style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            side: const BorderSide(
                                                color: Color(0xFFFF742F),
                                                width: 2.0,
                                                style: BorderStyle
                                                    .solid), // Adjust the radius as needed
                                          )),
                                          minimumSize:
                                              const MaterialStatePropertyAll(
                                                  Size(154, 54)),
                                          backgroundColor:
                                              const MaterialStatePropertyAll(
                                                  Color(0xffFF742F))),
                                      onPressed: () async {
                                        //Search using Google maps
                                        placeAutocomplete(fromController.text,
                                            'AIzaSyDXhM3t-i2ZfiPiG0AZYKJMDqm-ZVZSnUY');

                                        searchAndTraceRoute(fromController.text,
                                            toController.text);
                                        Navigator.pop(context);
                                      },
                                      child: const Text(
                                        "Go",
                                        style: TextStyle(
                                            fontSize: 25,
                                            color: Color(0xffffffff), //6350FF
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      });
                },
                label: const Text('Go ride!'),
                icon: const Icon(Icons.directions_car),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
            );
          }
        });
  }

  addMarkers() async {
    final BitmapDescriptor driverIcon1 =
        await addCustomIcon('assets/icons/Track.png');
    Marker driver1Marker = Marker(
        markerId: const MarkerId('Driver'),
        infoWindow: const InfoWindow(title: "Car Driver1", snippet: "Cameroon"),
        icon: driverIcon1,
        position: driver1Position,
        onTap: () => showRiderPopup(driver1, context));

    final BitmapDescriptor driverIcon2 =
        await addCustomIcon('assets/icons/green_car.svg');
    final Marker driver2Marker = Marker(
        markerId: const MarkerId('Driver 2'),
        infoWindow: const InfoWindow(title: "Car Driver2", snippet: "Cameroon"),
        icon: driverIcon2,
        position: driver2Position,
        onTap: () => showRiderPopup(driver1, context));

    print("Adding markers...");

    setState(() {
      _markers
        ..add(driver1Marker)
        ..add(driver2Marker);
    });
  }

  Future<BitmapDescriptor> addCustomIcon(String path) async {
    final icon =
        await BitmapDescriptor.fromAssetImage(const ImageConfiguration(), path);
    return icon;
  }

  drawer(double screenWidth, double screenHeight) {
    return Drawer(
      width: screenWidth * 0.60,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xfff8ad4b5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset(
                        "assets/icons/user.jpeg",
                        width: 80,
                        height: 80,
                      ),
                    ),
                  ),
                ),
                const Text(
                  'Dilan',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                  ),
                ),
                const Text(
                  'ndedilan504@gmail.com',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                leading: const Icon(Icons.history),
                title: const Text('History'),
                onTap: () {
                  Navigator.pushNamed(context, '/dashboard');
                },
              ),
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Messages'),
                onTap: () {
                  Navigator.pushNamed(context, '/dashboard');
                },
              ),
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.pushNamed(context, '/dashboard');
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Payment Methods'),
                onTap: () {
                  Navigator.pushNamed(context, '/payment');
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_center),
                title: const Text('Help Center'),
                onTap: () {
                  Navigator.pushNamed(context, '/help');
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About Us'),
                onTap: () {
                  Navigator.pushNamed(context, '/about-us');
                },
              ),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/sign-in');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void placeAutocomplete(String query, String apikey) async {
    Uri uri = Uri.https(
        "maps.googleapis.com",
        'maps/api/place/autocomplete/json', // unencoder path

        {
          "input": query, // query parameter
          "key": 'AIzaSyDXhM3t-i2ZfiPiG0AZYKJMDqm-ZVZSnUY',
        } // make sure you add your api key
        );
// its time to make the GET request
// its time to make the GEl request
    String? response = await NetworkUtility.fetchUrl(uri);

    if (response != null) {
      print("response : $response");
    }
  }

  Future<void> searchAndTraceRoute(String text, String text2) async {
    try {
      List<Location> endingLocation = await locationFromAddress(text2);
/*
https://maps.googleapis.com/maps/api/place/autocomplete/json
?input=${text2}
&location=37.76999%2C-122.44696
&radius=500
&types=establishment
&key=YOUR_API_KEY*/

      var startingLocation = await _currentPosition;
      var endingLocationLatitude = endingLocation[0].latitude;
      var endingLocationLongitude = endingLocation[0].longitude;

      print(
          "object: ${startingLocation.longitude},${startingLocation.latitude}");

      var url =
          'https://maps.googleapis.com/maps/api/directions/json?origin=${startingLocation.latitude},${startingLocation.longitude}&destination=$endingLocationLatitude,$endingLocationLongitude&key=AIzaSyCaUSSqsvNm3goVMBa5wj3gxHzFt0V1YUI';
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var jsonResponse = convert.jsonDecode(response.body);
        var routes = jsonResponse["routes"][0]["overview_polyline"]["points"];
        var points = convertToLatLng(decodePoly(routes));
        _addPolyLine(points);
        print("jsonResponse : $jsonResponse");
      } else {
        print('Request failed with status: ${response.statusCode}.');
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'Could not find any result for the supplied address or coordinates. Please try again'),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  void _addPolyLine(List<LatLng> points) {
    PolylineId id = const PolylineId("route");
    Polyline polyline = Polyline(
      polylineId: id,
      color: const Color.fromARGB(255, 231, 102, 15),
      points: points,
      width: 15,
    );
    setState(() {
      polylines[id] = polyline;
    });
  }
}
