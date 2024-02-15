import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ride_sharing_app/pages/login_page.dart';
import 'package:ride_sharing_app/pages/sign_up.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    final double screenWidth = MediaQuery.of(context).size.width;
    final double screenHeight = MediaQuery.of(context).size.height;
    double fontSizeText = 20;
    double adjustedFontSize = fontSizeText * screenWidth / 400;

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              Container(
                width: screenWidth * 0.75, // 75% of screen width
                height: screenHeight * 0.3, // 40% of screen height
                padding: const EdgeInsets.only(left: 10, top: 10),
                decoration: const BoxDecoration(
                  shape: BoxShape.rectangle,
                  // color: Color.fromARGB(31, 240, 84, 84)
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 0.0),
                  child: SvgPicture.asset("assets/icons/ride_share_new.svg"),
                ),
              ),
              SizedBox(
                  height: 48,
                  width: screenWidth * 0.75, // 75% of screen width
                  child: Center(
                    child: Text("RideShare 🔥🚀",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: adjustedFontSize,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold)),
                  )),
              SizedBox(
                  width: screenWidth * 0.75, // 75% of screen width
                  child: Center(
                    child: Text(
                        "RideShare 🚀 is a carpooling app that connects drivers and passengers in real-time. Join us now and enjoy the ride! 🚗",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: adjustedFontSize,
                            fontStyle: FontStyle.italic,
                            color: const Color(0xffFF742F),
                            fontWeight: FontWeight.bold)),
                  )),
              SizedBox(
                height: 48,
                width: screenWidth * 0.75, // 75% of screen width
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      // Privacy Policy
                      buildClickableText(
                        'Privacy Policy',
                        context,
                      ),

                      const Text(" and "),

                      // Terms & Conditions
                      buildClickableText(
                        'Terms & Conditions',
                        context,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      side: const BorderSide(
                          color: Color(0xFFFF742F),
                          width: 2.0,
                          style:
                              BorderStyle.solid), // Adjust the radius as needed
                    )),
                    minimumSize: MaterialStatePropertyAll(
                        Size(303 * screenWidth / 400, 54)),
                    backgroundColor:
                        const MaterialStatePropertyAll(Color(0xffffffff))),
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()))
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(
                      fontSize: 15 * screenWidth / 400,
                      color: const Color(0xffFF742F), //6350FF
                      fontWeight: FontWeight.w500),
                ),
              ),
              orPart(),
              TextButton(
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          15.0), // Adjust the radius as needed
                    )),
                    minimumSize: MaterialStatePropertyAll(
                        Size(303 * screenWidth / 400, 54)),
                    backgroundColor:
                        const MaterialStatePropertyAll(Color(0xffFF742F))),
                onPressed: () => {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignUpPage()))
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                      fontSize: 15 * screenWidth / 400,
                      color: const Color(0xffFFFFFF), //6350FF
                      fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 60,
              ),
              const Text("2023 © RideShare"),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildClickableText(String s, BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {},
      child: Text(s,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 15 * screenWidth / 400,
              color: const Color(0xff6350FF), //6350FF
              fontWeight: FontWeight.w500)),
    );
  }
}
