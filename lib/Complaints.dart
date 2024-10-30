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
 DateTime? selectedDate2;
 List<String> products=[];
 List<String> categories = [];
 String? selectedCategory;
 String? request;

  // Controllers for form fields
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController pincode=TextEditingController();
  final TextEditingController city=TextEditingController();
  final TextEditingController productname=TextEditingController();
  final TextEditingController complain=TextEditingController();

  final TextEditingController dateController1 = TextEditingController();
  final TextEditingController dateController2 = TextEditingController();

  String? _selectedValue;

  @override
  void initState() {
    super.initState();
   // _selectedValue = 'Iron';
    request='Complain';
    fetchCategories();
  }
  @override
  void dispose() {
    customerNameController.dispose();
    mobileNoController.dispose();
    addressController.dispose();
    city.dispose();
    pincode.dispose();
    dateController1.dispose();
    dateController2.dispose();
    super.dispose();
  }
 Future<void> fetchCategories() async {
   final response = await http.get(
     Uri.parse('http://localhost:3000/api/category'),
     headers: {
       'Content-Type': 'application/json',
     },
   );

   if (response.statusCode == 200) {
     final List<dynamic> categoryList = json.decode(response.body);
     setState(() {
       categories = categoryList.map((category) => category.toString()).toList();
     });
   } else {
     throw Exception('Failed to load categories');
   }
 }

 Future<void> fetchProductsForCategory(String categoryId) async {
   final response = await http.get(
       Uri.parse('http://localhost:3000/api/product?category=$categoryId'),
     headers: {
   'Content-Type': 'application/json',
   },
   );
//   print(response.body);

   if (response.statusCode == 200) {
     final List<dynamic> productList = json.decode(response.body);
     setState(() {
       products = productList.map((e) => e['productName'].toString()).toList();
       _selectedValue = null; // Reset product selection when category changes
     });
   } else {
     throw Exception('Failed to load products');
   }
 }
Future<void> createservicerequest(String Name,String phone,String address,String pdate,String wdate,String category,String product,String pincode,String city,String service,String complaint) async {
var url='http://localhost:3000/api/addcomplaints';

  var response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'fields':{

          "Phone Number":phone,
          "Customer name": Name,
          "address": address,
          "Purchase Date": pdate,
          "warranty expiry date": wdate,
          "Complain/Remark": complaint,
          "City": city,
          "pincode": pincode,
          "Request Type": service,
          "category": category,
          "product name": product,
        }
        }
      ));
if (response.statusCode == 200) {

  print('Record created successfully: ${response.body}');
} else {
  print('Failed to create record: ${response.statusCode} ${response.body}');
}

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

  Future<void> getcity (String pincode) async {
    final response = await http.get(Uri.parse("http://localhost:3000/api/pincode?pincode=$pincode"),headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },

    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final cityinfo = data['city'] ?? 'City not found';
      city.text = cityinfo;
    } else {
      city.text = 'Error fetching city';
    }
  }
 Future<void> _selectwarrantyDate(BuildContext context) async {
   final DateTime? picked = await showDatePicker(
     fieldLabelText: 'warranty expiry date',
     context: context,
     firstDate: DateTime(2000),
     lastDate: DateTime(2100),
     initialDate: selectedDate2 ?? DateTime.now(),

     initialDatePickerMode: DatePickerMode.day,
   );
   if (picked != null) {
     setState(() {
       selectedDate2 = picked;
       dateController2.text = "${picked.toLocal()}".split(' ')[0]; // Update the text field with the selected date

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
              TextField(
                controller: pincode,
                decoration: InputDecoration(labelText: "Pincode"),
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    getcity(value);
                  }
                }
              ),
              TextFormField(
                controller: city,
                decoration: InputDecoration(labelText: "City"),
                readOnly: true,
              ),

            DropdownButton(
                value: _selectedValue,

                items:products.map<DropdownMenuItem<String>>((String product){
                  return DropdownMenuItem<String>(value:product,child:Text(product,overflow: TextOverflow.ellipsis));}).toList()

                , onChanged:(productselected)
                {
                  setState(() {
                    _selectedValue=productselected;
                  });
                }
              ),
 DropdownButton(
          value: selectedCategory,
          onChanged: (newValue) {

            setState(() {
              selectedCategory = newValue as String?;
            });
            if (newValue != null) {
              fetchProductsForCategory(newValue); // Fetch products for the selected category
            }
          },
   items: categories.map<DropdownMenuItem<String>>((String category) {
     return DropdownMenuItem<String>(
       value: category,
       child: Text(category),
     );
   }).toList(),

        ),
               TextFormField(
                controller: dateController1,
                readOnly: true,
                 decoration: InputDecoration(labelText: "Purchase date"),
                onTap: () => _selectpurchaseDate(context),
               ),



              TextFormField(
                controller: dateController2,
                readOnly: true,
                decoration: InputDecoration(labelText: "Warranty expiry date"),
                onTap: ()=>_selectwarrantyDate(context),
              ),
              TextField(
                controller: complain,
                decoration: InputDecoration(labelText: "complain/remark"),
              ),
              DropdownButton(
                  value:request ,
                  items:[
                DropdownMenuItem(value:'Complain',child: Text('Complain'),),
                    DropdownMenuItem(value:'Service',child: Text('Service'),),
                    DropdownMenuItem(value:'Installation',child: Text('Installation')),
                    DropdownMenuItem(value:'demo',child:Text('demo')),
              ] , onChanged:(servicetype){
                setState(() {
                  request=servicetype;
                });
              } ),

              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  createservicerequest(customerNameController.text,mobileNoController.text,addressController.text,dateController1.text,dateController2.text,selectedCategory!,_selectedValue!,city.text,pincode.toString(),request!,complain.text);
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
