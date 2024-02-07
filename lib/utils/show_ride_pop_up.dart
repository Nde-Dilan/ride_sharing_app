
  import 'package:flutter/material.dart';
import 'package:ride_sharing_app/driver.dart';

void showRiderPopup(RiderData riderData, BuildContext context) {
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
  
  _launchCall(String number) {
  }