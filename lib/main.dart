import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ride_sharing_app/firebase_options.dart';
import 'package:ride_sharing_app/pages/about_us.dart';
import 'package:ride_sharing_app/pages/dashboard.dart';
import 'package:ride_sharing_app/pages/help_center.dart';
import 'package:ride_sharing_app/pages/home_page.dart';
import 'package:ride_sharing_app/pages/landing_page.dart';
import 'package:ride_sharing_app/pages/login_page.dart';
import 'package:ride_sharing_app/pages/my_profile.dart';
import 'package:ride_sharing_app/pages/payment_methods.dart';
import 'package:ride_sharing_app/pages/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      initialRoute: '/',

      routes: {
        '/sign-up': (context) => const SignUpPage(),
        '/home-page': (context) => const MapPage(),
        '/sign-in': (context) => const LoginPage(),
        '/about-us': (context) =>  const AboutUsPage(),
        '/dashboard': (context) =>  const Dashboard(),
        '/payment': (context) =>  const PaymentMethod(),
        '/profile': (context) =>  const MyProfile(),
        '/help': (context) =>  const HelpCenter(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 233, 92, 50)),
        useMaterial3: true,
      ),
      // home: const MyAppMap(),
      // home: const MapPage(),
      // home: const MapSample(),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.photos,
      Permission.location,
      Permission.locationAlways,
    ].request();
    // print(statuses[Permission.camera]);
    // print(statuses[Permission.photos]);
  }

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return const WelcomePage();
  }
}
