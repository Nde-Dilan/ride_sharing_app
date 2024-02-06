import 'package:flutter/material.dart';

class PhoneInput extends StatefulWidget {
  final TextEditingController phoneController;
 const PhoneInput( {super.key, required this.phoneController});

  @override
  State<PhoneInput> createState() => _PhoneInputState();
}

class _PhoneInputState extends State<PhoneInput> {
  final ValueNotifier<String> countryPrefix = ValueNotifier<String>('+237');
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: countryPrefix,
        builder: ((context, value, child) {
          return Row(
            children: <Widget>[
              DropdownButton<String>(
                value: value, // Add this line
                items:
                    <String>['+247', '+91', '+33', '+237'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    countryPrefix.value = newValue!;
                  });
                },
              ),
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: widget.phoneController,
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
          );
        }));
  }
}
