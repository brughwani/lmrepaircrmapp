import 'package:flutter/material.dart';
//import 'package:lmrepaircrmapp/LoginPage.dart';
import 'package:lmrepaircrmapp/Complaints.dart';
import 'package:lmrepaircrmapp/LoginPage.dart';

void main() async {
  runApp(Lmcrm());
}

class Lmcrm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      
      home: MyHomePage(), // Your home page widget
    );
  }
}