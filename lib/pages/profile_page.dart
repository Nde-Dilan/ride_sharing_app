import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ProfilePage extends StatelessWidget {
  final String name;
  final String vehicleType;
  final String phoneNumber;

  final bool isActive;
  final String rating;
  final LatLng position;

  const ProfilePage({
    super.key,
    required this.name,
    required this.vehicleType,
    required this.phoneNumber,
    required this.isActive,
    required this.rating,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth * 0.05;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Driver Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjust height based on content
            children: [
              const Center(
                child: Text(
                  "Driver Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset("assets/icons/user.jpeg"),
                  ),
                ),
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Text(
                    "Name: ",
                    style: TextStyle(fontSize: fontSize),
                  ),
                  Text(name,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: fontSize)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Vehicle: ",
                    style: TextStyle(fontSize: fontSize),
                  ),
                  Text(vehicleType,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: fontSize)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Rating: ",
                    style: TextStyle(fontSize: fontSize),
                  ),
                  Expanded(
                    child: RatingBar.builder(
                      initialRating: 3,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        size: 1,
                        color: Colors.amber,
                      ),
                      onRatingUpdate: (rating) {
                        print(rating);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Available: ",
                    style: TextStyle(fontSize: fontSize),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isActive ? Colors.green : Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () async {
                      try {
                        if (await canLaunchUrl(Uri.parse(
                            "whatsapp://send?phone=+237694525931&text=hi%20there!%20I%20am%20interested%20in%20your%20service."))) {
                          await launchUrl(Uri.parse(
                              "whatsapp://send?phone=+237694525931&text=hi%20there!%20I%20am%20interested%20in%20your%20service."));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Whatsapp not installed")));
                        }

                        print("Chatting with driver");
                      } catch (e) {
                        print(e.toString());
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 21, 184, 224)),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(
                            color: Color.fromARGB(255, 21, 184, 224),
                            width: 2.0,
                            style: BorderStyle
                                .solid), // Adjust the radius as needed
                      )),
                      minimumSize: MaterialStatePropertyAll(
                          Size(screenWidth * 0.25, 54)),
                    ),
                    child: Text(
                      "Let's chat 📩",
                      style: TextStyle(
                          fontSize: fontSize,
                          color: Color.fromARGB(255, 255, 255, 255), //6350FF
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(
                    width: screenWidth * 0.2,
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {},
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 105, 235, 53)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15.0),

                          side: const BorderSide(
                              color: Color.fromARGB(255, 105, 235, 53),
                              width: 2.0,
                              style: BorderStyle
                                  .solid), // Adjust the radius as needed
                        )),
                        minimumSize: MaterialStatePropertyAll(
                            Size(screenWidth * 0.15, 54)),
                      ),
                      child: Text(
                        "Call Me 📞",
                        style: TextStyle(
                            fontSize: fontSize,
                            color: const Color.fromARGB(
                                255, 255, 255, 255), //6350FF
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
