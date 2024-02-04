import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ride_sharing_app/firebase_options.dart';
import 'package:ride_sharing_app/pages/sign_up.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('🚔🚨RideShare 🔥🚀'),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Padding(
                    padding: const EdgeInsets.all(19.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          const Text(
                            'Login',
                            style: TextStyle(fontSize: 24),
                          ),
                          const SizedBox(
                            height: 48,
                          ),
                          const Text(
                            'Hi Mr/Mme, Wecome Back! 👋',
                            style: TextStyle(fontSize: 24),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                          const Text(
                            "Hello again, you’ve been missed!",
                            style: TextStyle(fontSize: 17),
                          ),
                          const SizedBox(
                            height: 38,
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            validator: (value) {
                              validateEmail(value);
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 48,
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            ),
                            obscureText: true,
                            enableSuggestions: false,
                            autocorrect: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
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
                                    Size(303, 54)),
                                backgroundColor: const MaterialStatePropertyAll(
                                    Color(0xffffffff))),
                            onPressed: () async {
                              signInUser(_emailController.text,
                                  _passwordController.text);
                            },
                            child: const Text(
                              "Sign In",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: Color(0xffFF742F), //6350FF
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          orPart(),
                          TextButton(
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  side: const BorderSide(
                                    color: Color(0xFFFF742F),
                                    width: 2.0,
                                    style: BorderStyle.solid,
                                  ),
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all<Size?>(
                                  const Size(303, 54)),
                              backgroundColor:
                                  MaterialStateProperty.all<Color?>(
                                      const Color(0xFFFFFFFF)),
                            ),
                            onPressed: () => {print("Sign In With Google")},
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.g_mobiledata_outlined,
                                  color: Color(0xffFF742F),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Sign In With Google",
                                  style: TextStyle(
                                    fontSize: 19,
                                    color: Color(0xffFF742F),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                default:
                  final double screenHeight =
                      MediaQuery.of(context).size.height;
                  return Center(
                      child: Column(children: [
                    SizedBox(
                      height: screenHeight * 0.5,
                    ),
                    const CircularProgressIndicator(),
                    const Text("Loading ... ")
                  ]));
              }
            },
          ),
        ));
  }

  signInUser(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        print(credential);
        Navigator.pushNamed(context, '/home-page');
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
      }
    }
  }
}
