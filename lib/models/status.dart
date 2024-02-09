import 'package:flutter/material.dart';

class Status {
  
   String statusText ;
   Color availableColor;
   Status({required this.statusText, required this.availableColor});
   
    static List<Status> statusList = [
      Status(statusText: "Available", availableColor: Colors.green),
      Status(statusText: "Busy", availableColor: Colors.red),
      Status(statusText: "Away", availableColor: Colors.yellow),
    ];
}
