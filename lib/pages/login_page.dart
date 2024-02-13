import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
    final args = ModalRoute.of(context)?.settings.arguments;
    String username;

    if (args != null) {
      username = args as String;
    } else {
      username = "Mr/Mrs";
    }

    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text('🚔🚨RideShare 🔥🚀'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(19.0),
        child: Form(
          key: _formKey,
          child: Builder(builder: (context) {
            return Column(
              children: <Widget>[
                Text(
                  'Login',
                  style: TextStyle(fontSize: 24 * screenWidth / 400),
                ),
                const SizedBox(
                  height: 48,
                ),
                Text(
                  'Hi $username, Wecome Back! 👋',
                  style: TextStyle(fontSize: 24 * screenWidth / 400),
                ),
                const SizedBox(
                  height: 18,
                ),
                Text(
                  "Hello again, you’ve been missed!",
                  style: TextStyle(fontSize: 17 * screenWidth / 400),
                ),
                const SizedBox(
                  height: 38,
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
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
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        side: const BorderSide(
                            color: Color(0xFFFF742F),
                            width: 2.0,
                            style: BorderStyle
                                .solid), // Adjust the radius as needed
                      )),
                      minimumSize: MaterialStatePropertyAll(
                          Size(303 * screenWidth / 400, 54)),
                      backgroundColor:
                          const MaterialStatePropertyAll(Color(0xffffffff))),
                  onPressed: () async {
                    signInUser(_emailController.text, _passwordController.text);
                  },
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                        fontSize: 25 * screenWidth / 400,
                        color: const Color(0xffFF742F), //6350FF
                        fontWeight: FontWeight.w500),
                  ),
                ),
                orPart(),
                signInWithGoogleBtn(context)
              ],
            );
          }),
        ),
      )),
    );
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
