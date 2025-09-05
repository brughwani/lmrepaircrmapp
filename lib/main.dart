import 'package:flutter/material.dart';
//import 'package:lmrepaircrmapp/loginPage.dart';
import 'package:lmrepaircrmapp/Complaints.dart';
import 'package:lmrepaircrmapp/loginPage.dart';

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