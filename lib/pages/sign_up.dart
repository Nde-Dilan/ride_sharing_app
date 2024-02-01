import 'dart:io';

import 'package:flutter/material.dart';

//Storage stuff

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // final storage = FirebaseStorage.instance;
  String dropdownValue = '+237';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RideShare'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(19.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                const Text(
                  'Create an acount',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 48,
                ),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(10.0), // Add this line
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
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
                Row(
                  children: <Widget>[
                    DropdownButton<String>(
                      value: dropdownValue, // Add this line
                      items: <String>['+247', '+91', '+33', '+237']
                          .map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(10.0), // Add this line
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 48,
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
                    minimumSize:
                        MaterialStateProperty.all<Size?>(const Size(303, 54)),
                    backgroundColor: MaterialStateProperty.all<Color?>(
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
                ),
                const SizedBox(
                  height: 48,
                ),
                Row(
                  children: <Widget>[
                    const Text("Upload CNI Image",
                        style: TextStyle(
                            fontSize: 20,
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold)),
                    const SizedBox(
                      width: 14,
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
                          Reference ref = storage
                              .ref()
                              .child("images/${DateTime.now().toString()}");

                          // Upload the file
                          UploadTask uploadTask = ref.putFile(File(image.path));
                          print("File selected");

                          // Get the download URL
                          await uploadTask.whenComplete(() async {
                            String downloadURL = await ref.getDownloadURL();
                            print('File Uploaded: $downloadURL');
                          }).catchError((onError) {
                            print(onError);
                          });
                        } else {
                          print("No file selected");
                        }
                      },
                      child: const Text('No files here'),
                    ),
                  ],
                ),
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
                    minimumSize:
                        MaterialStateProperty.all<Size?>(const Size(303, 54)),
                    backgroundColor: MaterialStateProperty.all<Color?>(
                        const Color(0xFFFFFFFF)),
                  ),
                  onPressed: () => {},
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create Your Account",
                        style: TextStyle(
                          fontSize: 19,
                          color: Color(0xffFF742F),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Padding orPart() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0),
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
}
