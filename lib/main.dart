
import 'package:flutter/material.dart';
import 'package:lmrepaircrmapp/LoginPage.dart';
import 'package:lmrepaircrmapp/Complaints.dart';

void main() async {
  runApp(Lmcrm());
}

class Lmcrm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      
      home: MyApp(), // Your home page widget
    );
  }
}