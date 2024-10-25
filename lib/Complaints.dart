import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Complain detail',
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
 DateTime? selectedDate;
 

  // Controllers for form fields
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController dateController1 = TextEditingController();
  final TextEditingController dateController2 = TextEditingController();

  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = 'Iron';
  }
  @override
  void dispose() {
    customerNameController.dispose();
    mobileNoController.dispose();
    addressController.dispose();
    dateController1.dispose();
    dateController2.dispose();
    super.dispose();
  }

Future<void> createservicerequest() async {
var url='http://localhost:3000/api/addcomplaint';

  var response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'fields':{
        'customerName': customerNameController.text,
        'mobileNo': mobileNoController.text,
        'address': addressController.text,
        'date1': dateController1.text,
        'date2': dateController2.text,
        'category': _selectedValue!,
        }
        }
      ));
}
  // Add more controllers as per your UI design
  Future<void> _selectpurchaseDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      fieldLabelText: 'Purchase date',
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: selectedDate ?? DateTime.now(),

      initialDatePickerMode: DatePickerMode.day,
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
dateController1.text = "${picked.toLocal()}".split(' ')[0]; // Update the text field with the selected date
     
      });
    }
  }

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
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: "Pincode"),
              ),
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: "City"),
              ),
              // Add more fields from the form you see in the image
              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: "Product name"),
              ),
 DropdownButton(
          value: _selectedValue,
          onChanged: (newValue) {
            setState(() {
              _selectedValue = newValue;
            });
          },
          items: [
            DropdownMenuItem(
              child: Text('Iron'),
              value: 'Iron',
            ),
            DropdownMenuItem(
              child: Text('Gas Stove'),
              value: 'Gas Stove',
            ),
            DropdownMenuItem(
              child: Text('Cooker'),
              value: 'Cooker',
            ),
            DropdownMenuItem(
              child: Text('Mixer'),
              value: 'Mixer',
            ),
DropdownMenuItem(
              child: Text('Ceiling Fan'),
              value: 'Ceiling Fan',
            ),
            DropdownMenuItem(
              child: Text('Tower Fan'),
              value: 'Tower Fan',
            ),
            DropdownMenuItem(
              child: Text('Table Fan'),
              value: 'Table Fan',
            ),
            DropdownMenuItem(
              child: Text('Pedestal Fan'),
              value: 'Pedestal Fan',
            ),
            DropdownMenuItem(
              child: Text('Immersion Rod'),
              value: 'Immersion Rod',
            ),
             DropdownMenuItem(
              child: Text('Milk Madhani'),
              value: 'Milk Madhani',
            ),
          ],
        ),
               TextFormField(
                controller: dateController1,
                readOnly: true,
                 decoration: InputDecoration(labelText: "Purchase category"),
                onTap: () => _selectpurchaseDate(context),
               ),


              TextFormField(
                controller: addressController,
                decoration: InputDecoration(labelText: "Warranty expiry category"),
              ),
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
