import 'package:flutter/material.dart';

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
  final TextEditingController dateController = TextEditingController();

  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = 'Iron';
  }

  // Add more controllers as per your UI design
  Future<void> _selectDate(BuildContext context) async {
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
dateController.text = "${picked.toLocal()}".split(' ')[0]; // Update the text field with the selected date
     
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
                controller: dateController,
                readOnly: true,
                onTap: () => _selectDate(context),
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
