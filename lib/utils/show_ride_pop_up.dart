import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:ride_sharing_app/driver.dart';

void showRiderPopup(RiderData riderData, BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double _fontSize = screenWidth * 0.05;
  showModalBottomSheet(
    context: context,
    builder: (context) => SingleChildScrollView(
      child: Container(
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
                Text(
                  "Name: ",
                  style: TextStyle(fontSize: _fontSize),
                ),
                Text(riderData.name,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: _fontSize)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Vehicle: ",
                  style: TextStyle(fontSize: _fontSize),
                ),
                Text(riderData.vehicleType,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: _fontSize)),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                  "Rating: ",
                  style: TextStyle(fontSize: _fontSize),
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
                  style: TextStyle(fontSize: _fontSize),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: riderData.isActive ? Colors.green : Colors.red,
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
                  child: Text(
                    "Cancel",
                    style: TextStyle(
                        fontSize: _fontSize,
                        color:
                            const Color.fromARGB(255, 255, 255, 255), //6350FF
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
                        MaterialStatePropertyAll(Size(screenWidth * 0.15, 54)),
                  ),
                  child: Text(
                    "Call Driver",
                    style: TextStyle(
                        fontSize: _fontSize,
                        color:
                            const Color.fromARGB(255, 255, 255, 255), //6350FF
                        fontWeight: FontWeight.w500),
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

_launchCall(String number) {}
