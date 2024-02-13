import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/icons/RideShare.png'),
            ),
            SizedBox(height: 20),
            Text(
              'RideShare 🚀',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text(
              'Developer Info',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 10),
            Text('Name: NDE HURICH DILAN'),
            SizedBox(height: 10),
            Text('Phone: +237694525931'),
            SizedBox(height: 10),
            Text("Email: techwithdilan2@gmail"),
          ],
        ),
      ),
    );
  }
}
