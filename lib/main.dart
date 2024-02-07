import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ride_sharing_app/pages/home_page.dart';
import 'package:ride_sharing_app/pages/landing_page.dart';
import 'package:ride_sharing_app/pages/login_page.dart';
import 'package:ride_sharing_app/pages/sign_up.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of my application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',

      initialRoute: '/',
      routes: {
        '/sign-up': (context) => const SignUpPage(),
        '/sign-in': (context) => const LoginPage(),
        '/home-page': (context) => const MapPage(),
      },
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 233, 92, 50)),
        useMaterial3: true,
      ),
      home: const MapPage(),
      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
    ].request();
    print(statuses[Permission.camera]);
    print(statuses[Permission.photos]);
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
