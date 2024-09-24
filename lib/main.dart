import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
       
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const complaincollection()
    );
  }
}

class complaincollection extends StatefulWidget {
  const complaincollection({super.key});

  @override
  State<complaincollection> createState() => _complaincollectionState();
}

class _complaincollectionState extends State<complaincollection> {
 final _formKey = GlobalKey<FormState>();

  // Controllers for form fields
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  // Add more controllers as per your UI design

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Manage Complaints"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: customerNameController,
                decoration: InputDecoration(labelText: "Customer Name"),
              ),
              TextFormField(
                controller: mobileNoController,
                decoration: InputDecoration(labelText: "Mobile No"),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: "Address"),
              ),
              // Add more fields from the form you see in the image

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add submit logic here
                },
                child: Text("Save"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
