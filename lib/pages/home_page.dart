import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:ride_sharing_app/driver.dart';
import 'package:ride_sharing_app/utils/bitmap_converter.dart';
import 'package:ride_sharing_app/utils/get_location_uptdate.dart';
import 'package:ride_sharing_app/utils/show_ride_pop_up.dart';

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

  BitmapDescriptor markerIcon = BitmapDescriptor.defaultMarker;

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
    //Responsive design

    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;

    //Fields controller

    final TextEditingController _fromController = TextEditingController();
    final TextEditingController _toController = TextEditingController();

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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //TODO: When btn is clicked open a bottom sheet form
          showModalBottomSheet(
              backgroundColor: const Color(0xffffffff),
              context: context,
              // barrierDismissible: true,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      // key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const Text(
                            "Where are you going?",
                            style: TextStyle(
                                fontSize: 25,
                                color: Color.fromARGB(255, 0, 0, 0),
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
                            controller: _fromController,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'From',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 48,
                          ),
                          TextFormField(
                            controller: _toController,
                            decoration: InputDecoration(
                              labelText: 'To',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
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
                                  borderRadius: BorderRadius.circular(15.0),
                                  side: const BorderSide(
                                      color: Color(0xFFFF742F),
                                      width: 2.0,
                                      style: BorderStyle
                                          .solid), // Adjust the radius as needed
                                )),
                                minimumSize: const MaterialStatePropertyAll(
                                    Size(154, 54)),
                                backgroundColor: const MaterialStatePropertyAll(
                                    Color(0xffFF742F))),
                            onPressed: () async {
                              //Search using Google maps
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
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _addMarkers() async {
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

    final BitmapDescriptor passengerIcon =
        await addCustomIcon('assets/icons/passenger.png');
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
                    child: SvgPicture.asset("assets/icons/user.svg"),
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
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.message),
                title: const Text('Messages'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.dashboard),
                title: const Text('Dashboard'),
                onTap: () async {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.account_circle),
                title: const Text('Profile'),
                onTap: () async {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.payment),
                title: const Text('Payment Methods'),
                onTap: () async {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.help_center),
                title: const Text('Help Center'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                },
              ),
              ListTile(
                leading: const Icon(Icons.info),
                title: const Text('About Us'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
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
}
