import 'package:flutter/material.dart';

class CheckBox extends StatefulWidget {
   bool isDriver;
   CheckBox({super.key, required this.isDriver});
  @override
  State<CheckBox> createState() => _CheckBoxState();
}

class _CheckBoxState extends State<CheckBox> {
  final ValueNotifier<bool> _isDriver = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isDriver,
      builder: (context, value, child) {
        return CheckboxListTile(
          title: const Text("I am a Driver", style: TextStyle(fontSize: 20)),
          value: value,
          onChanged: (bool? newValue) {
            _isDriver.value = newValue!;
            widget.isDriver = _isDriver.value;
          },
          controlAffinity: ListTileControlAffinity.leading,
        );
      },
    );
  }
}
