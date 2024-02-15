import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

//image picker

import 'package:image_picker/image_picker.dart';

//firebase stuff
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ride_sharing_app/widgets/checkbox.dart';
import 'package:ride_sharing_app/widgets/phone_number.dart';

import 'package:google_sign_in/google_sign_in.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final bool _isDriver = false;
  String cniImage = "No Image Uploaded";
  // String dropdownValue = '+237';

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          title: const Text('🚔🚨 RideShare 🔥🚀'),
        ),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.all(19.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Create an acount',
                  style: TextStyle(fontSize: 24 * screenWidth / 400),
                ),
                const SizedBox(
                  height: 48,
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Add this line
                    ),
                  ),
                  validator: (value) {
                    validateEmail(value!);
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
                      borderRadius:
                          BorderRadius.circular(10.0), // Add this line
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
                PhoneInput(phoneController: _phoneController),
                const SizedBox(
                  height: 28,
                ),
                CheckBox(isDriver: _isDriver),
                const SizedBox(
                  height: 18,
                ),
                cniUploadPart(),
                const SizedBox(
                  height: 18,
                ),
                CreatYourAccountBtn(context),
                orPart(),
                signInWithGoogleBtn(context),
                const SizedBox(
                  height: 18,
                ),
              ],
            ),
          ),
        )));
  }

  TextButton CreatYourAccountBtn(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return TextButton(
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
        minimumSize:
            MaterialStateProperty.all<Size?>(Size(303 * screenWidth / 400, 54)),
        backgroundColor:
            MaterialStateProperty.all<Color?>(const Color(0xFFFFFFFF)),
      ),
      onPressed: () async {
        createAnAccount(context);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Create Your Account",
            style: TextStyle(
              fontSize: 19 * screenWidth / 400,
              color: const Color(0xffFF742F),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Row cniUploadPart() {
    String textMessage = "No files here";
    final double screenWidth = MediaQuery.of(context).size.width;

    return Row(
      children: <Widget>[
        Text("Upload CNI Image",
            style: TextStyle(
                fontSize: 20 * screenWidth / 400,
                color: const Color.fromARGB(255, 0, 0, 0),
                fontWeight: FontWeight.bold)),
        SizedBox(
          width: 14 * screenWidth / 400,
        ),
        ElevatedButton(
          onPressed: () async {
            final ImagePicker picker = ImagePicker();
            // Pick an image
            final XFile? image =
                await picker.pickImage(source: ImageSource.camera);

            if (image != null) {
              // Create a Reference to the file
              FirebaseStorage storage = FirebaseStorage.instance;
              Reference ref =
                  storage.ref().child("images/${DateTime.now().toString()}");

              // Upload the file
              UploadTask uploadTask = ref.putFile(File(image.path));
              print("File selected");

              // Get the download URL
              await uploadTask.whenComplete(() async {
                String downloadURL = await ref.getDownloadURL();
                cniImage = downloadURL;
                print('File Uploaded: $downloadURL');
                textMessage = "File Uploaded";
              }).catchError((onError) {
                print(onError);
                // return "Error";
              });
            } else {
              print("No file selected");
            }
          },
          child: Text(textMessage),
        ),
      ],
    );
  }

  void createAnAccount(BuildContext context) async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final phoneNumber = _phoneController.text;
    final isDriver = _isDriver;

    if (_formKey.currentState!.validate()) {
      try {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        print(credential);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Account created successfully'),
          ),
        );
        //Create a collection in firestore for the user, and take the
        // Create a new user with a first and last name
        final user = <String, dynamic>{
          "CNIImage": cniImage,
          "email": email,
          "isDriver": isDriver,
          "phone number": phoneNumber,
          "user_id": credential.user?.uid,
          "username": email.split('@').first,
        };

        final db = FirebaseFirestore.instance;

        // Add a new document with a generated ID
        await db.collection("users").add(user).then((DocumentReference doc) =>
            print('DocumentSnapshot added with ID: ${doc.id}'));
        // ignore: use_build_context_synchronously
        
          Navigator.pushNamed(context, '/sign-in',
              arguments: email.split('@').first);
        ;
        // ignore: nullable_type_in_catch_clause
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print("We have an error here $e");
      }
    }
  }
}

validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter your email';
  } else if (!RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(value)) {
    return 'Please enter a valid email address';
  }
  return null;
}

Padding orPart() {
  return const Padding(
    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
    child: Row(
      children: <Widget>[
        Expanded(
          child: Divider(
            color: Colors.black,
            height: 1.5,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: Text("Or"),
        ),
        Expanded(
          child: Divider(
            color: Colors.black,
            height: 1.5,
          ),
        ),
      ],
    ),
  );
}

TextButton signInWithGoogleBtn(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;

  return TextButton(
    onPressed: () async {
      UserCredential user = await signInWithGoogle();
      if (user.user?.displayName != null) {
        Navigator.pushNamed(context, '/home-page');
      }
    },
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
      minimumSize:
          MaterialStateProperty.all<Size?>(Size(303 * screenWidth / 400, 54)),
      backgroundColor:
          MaterialStateProperty.all<Color?>(const Color(0xFFFFFFFF)),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.g_mobiledata_outlined,
          color: Color(0xffFF742F),
        ),
        SizedBox(width: 10 * screenWidth / 400),
        Text(
          "Sign In With Google",
          style: TextStyle(
            fontSize: 19 * screenWidth / 400,
            color: const Color(0xffFF742F),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
