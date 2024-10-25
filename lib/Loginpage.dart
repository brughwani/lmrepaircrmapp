import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> registerUser(String phoneNumber, String password) async {
    // Call your Node.js backend for registration
    final response = await http.post(
      Uri.parse('http://your-node-server/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': phoneNumber,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      // User registered successfully
      print('User registered successfully!');
    } else {
      // Handle error
      print('Error: ${response.body}');
    }
  }

  Future<void> loginUser(String phoneNumber, String password) async {
    // Call your Node.js backend for login
    final response = await http.post(
      Uri.parse('http://your-node-server/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': phoneNumber,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Get custom token from response
      final token = jsonDecode(response.body)['token'];

      // Sign in with custom token
      await _auth.signInWithCustomToken(token);
      print('User authenticated successfully!');
    } else {
      // Handle error
      print('Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            
            ElevatedButton(
              onPressed: () => registerUser('1234567890', 'yourPassword'),
              child: Text('Register'),
            ),
            ElevatedButton(
              onPressed: () => loginUser('1234567890', 'yourPassword'),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}