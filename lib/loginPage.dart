//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'authservice.dart';
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 // final FirebaseAuth _auth = FirebaseAuth.instance;
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = 'Support';
  }

  Future<void> loginUser(String phoneNumber, String password) async {
    // Call your Node.js backend for registration
    final response = await http.post(
      Uri.parse('https://limsonvercelapi2.vercel.app/api/fsauth'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': phoneNumber,
        'password': password,
        'app': selectedValue!,
      }),
    );

    if (response.statusCode == 200) {
      // User registered successfully
      print('User logged in successfully!');

     // Navigator.of(context).push(MaterialPageRoute(builder: ));
      
    } else {
      // Handle error
      print('Error: ${response.body}');
    }
  }



  // Future<void> loginUser(String phoneNumber, String password) async {
  //   // Call your Node.js backend for login
  //   final response = await http.post(
  //     Uri.parse('http://limsonvercelapi2.vercel.app/api/fsauth'),
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //     },
  //     body: jsonEncode(<String, String>{
  //       'phoneNumber': phoneNumber,
  //       'password': password,
  //     }),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     // Get custom token from response
  //     final token = jsonDecode(response.body)['token'];
  //
  //     // Sign in with custom token
  //     await _auth.signInWithCustomToken(token);
  //     print('User authenticated successfully!');
  //   } else {
  //     // Handle error
  //     print('Error: ${response.body}');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    TextEditingController username=TextEditingController();
    TextEditingController password=TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: <Widget>[
            TextFormField(
              controller: username,
              decoration: InputDecoration(labelText: "Phone"),
              keyboardType: TextInputType.phone,
            ),
            TextFormField(
              obscureText: true,
              controller: password,
              decoration: InputDecoration(
                  labelText: "Password"),
            ),

            // TextFormField(
            //
            // ),
            
            // ElevatedButton(
            //   onPressed: () => registerUser('1234567890', 'yourPassword'),
            //   child: Text('Register'),
            // ),
            ElevatedButton(
             onPressed: () => AuthService(baseUrl: 'https://limsonvercelapi2.vercel.app').authenticate(username.text,password.text,selectedValue.toString(),context),
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}