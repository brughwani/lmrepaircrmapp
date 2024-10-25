
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:lmrepaircrmapp/Complaints.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();

}

class _MyHomePageState extends State<MyHomePage> {
  String? selectedValue;
  
  @override
  void initState() {
    super.initState();
    selectedValue = '';
  }

  

  Future<void> loginUser(String phoneNumber, String password,String role) async {
    // Call your Node.js backend for login
    final response = await http.post(
      Uri.parse('localhost:3000/loginUser'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phoneNumber': phoneNumber,
        'password': password,
        'role': selectedValue!
      }),
    );

    if (response.statusCode == 200) {
      // Get custom token from response
      final token = jsonDecode(response.body)['token'];

      // Sign in with custom token
      
      Navigator.of(context).push(MaterialPageRoute(builder: (context)=>MyApp()));
      
    } else {
      // Handle error
      print('Error: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneNumber=TextEditingController();
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
              controller: phoneNumber,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: "Phone Number"),

            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: password,
              decoration: InputDecoration(
                
                labelText: "Password"),

            ),
            DropdownButton(
              hint: Text('Select Role'),
              value: selectedValue,
              items: [
              DropdownMenuItem(
                child: Text('Karigar'),
                value: 'Karigar',
                ),
              DropdownMenuItem(
                child: Text('Support'),
                value: 'Support',
                ),
                
          ], onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },),
            
            Row(
              children: [
          
            ElevatedButton(
              onPressed: () => loginUser(phoneNumber.text,password.text,selectedValue!),
              child: Text('Login'),
            ),
          ],
            ),
             ],
      )
         ),
         
    );
        
      
    
  }
}