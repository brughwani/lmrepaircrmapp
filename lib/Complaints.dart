import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:lmrepaircrmapp/loginPage.dart';

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Complain detail',
//       theme: ThemeData(
//
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: MyHomePage()
//     );
//   }
// }

class complaincollection extends StatefulWidget {
  final String token;

  const complaincollection({super.key,required this.token});

  @override
  State<complaincollection> createState() => _complaincollectionState();
}

class _complaincollectionState extends State<complaincollection> {
 final _formKey = GlobalKey<FormState>();
 DateTime? selectedDate;
 DateTime? selectedDate2;
 List<String> products=[];
 List<String> categories = [];
 List<String> brands=[];
 String? selectedCategory;
 String? selectedBrand;
 String? request;


 //String formattedDate = DateFormat('yyyy-MM-dd').format(datenow.);


 // Controllers for form fields
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller=TextEditingController();
  final TextEditingController address3Controller=TextEditingController();
  final TextEditingController pincode=TextEditingController();
  final TextEditingController citycontroller=TextEditingController();
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
    fetchbrands();

  }
  @override
  void dispose() {
    customerNameController.dispose();
    mobileNoController.dispose();
    address1Controller.dispose();
    address2Controller.dispose();
    address3Controller.dispose();
    citycontroller.dispose();
    pincode.dispose();
    dateController1.dispose();
    dateController2.dispose();
    super.dispose();
  }

 void _checkInputLength(String text, int requiredLength) {
   if (text.length != requiredLength) {
     HapticFeedback.vibrate(); // Trigger haptic feedback for invalid length
   }
 }

 Future<void> fetchbrands() async
 {
   final response= await http.get(
     Uri.parse('https://limsonvercelapi2.vercel.app/api/fsproductservice?level=brands'),
     headers: {
       'Content-Type': 'application/json',
       'Authorization':'Bearer ${widget.token}',
     },
   );
   if(response.statusCode==200)
     {
       final List<dynamic> brandlist=jsonDecode(response.body);
       setState(() {
         brands=brandlist.map((b)=>b.toString()).toList();
       });

//print(response.body);
     }
   else
     {
       throw Exception('Failed to load brands');
      // print(response.statusCode);
     }

 }

 Future<void> fetchCategories(String Brand) async {
   final response = await http.get(
     Uri.parse('https://limsonvercelapi2.vercel.app/api/fsproductservice?level=categories&brand=$Brand'),
     headers: {
       'Content-Type': 'application/json',
       'Authorization':'Bearer ${widget.token}',
     },
   );

   if (response.statusCode == 200) {
     print(response.body);
     final List<dynamic> categoryList = json.decode(response.body);
     setState(() {

       categories = categoryList.map((category) => category.toString()).toList();

     });
    // print(categories);
   } else {
     throw Exception('Failed to load categories');
   }
 }

 Future<void> fetchProductsForCategory(String Brand,String categoryId) async {
   final response = await http.get(
       Uri.parse('https://limsonvercelapi2.vercel.app/api/fsproductservice?level=products&brand=$Brand&category=$categoryId'),
     headers: {
   'Content-Type': 'application/json',
       'Authorization':'Bearer ${widget.token}',
   },
   );

  print(response.body);

   if (response.statusCode == 200) {
     final List<dynamic> productList = json.decode(response.body);
     setState(() {
       products = productList.map((e) => e['name'].toString()).toList();
       _selectedValue = null; // Reset product selection when category changes
     });
   } else {
     throw Exception('Failed to load products');
   }
 }
Future<void> createservicerequest(String Name,String phone,String address,String pincode,String cityname,String brand,String category,String product,String pdate,String wdate,String complaint,String service) async {
var url='https://limsonvercelapi2.vercel.app/api/fsaddcomplaint';
//var url2='http://localhost:3000/api/addcomplaint';
DateTime datenow = DateTime.now();
//print(datenow.toLocal().toString().split(' ')[0]);
String formattedDate = DateFormat('dd-MM-yyyy').format(datenow);
//print(formattedDate);
String Date2=datenow.toLocal().toString().split(' ')[0];



var response = await http.post(Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':'Bearer ${widget.token}',
      },
      body: jsonEncode({
        "fields":{
          "Customer name": Name,
          "Phone":"+91"+phone,
          "address": address,
          "pincode": pincode,
          "city": cityname,
          "Brand":brand,
          "Category":category,
          "Product name":product,
          "Purchase date": pdate,
          "warranty expiry date": wdate,
          "Complain/Remark": complaint,
          "Request Type": service,
    //      "date of complain":formattedDate
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
     print(picked);
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
      body: SingleChildScrollView(
        child: Padding(
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
        
                    decoration: InputDecoration(
                      labelText: 'Enter Phone Number',
                      hintText: '10-digit phone number',
                      border: OutlineInputBorder(),
                      enabledBorder: mobileNoController.text.length < 10
                          ? OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                      )
                          : OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      labelStyle: TextStyle(
                        color:mobileNoController.text.length != 10 ? Colors.red : Colors.green,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _checkInputLength(val, 10);
                      });
                    }
                ),
        
        
                TextFormField(
                  controller: address1Controller,
                  decoration: InputDecoration(labelText: "Address line 1"),
                ),
                TextFormField(
                  controller: address2Controller,
                  decoration: InputDecoration(labelText: "Address line 2"),
                ),
                TextFormField(
                  controller: address3Controller,
                  decoration: InputDecoration(labelText: "Address line 3"),
                ),
                TextField(
                  controller: pincode,
                  decoration: InputDecoration(labelText: "Pincode",
                  enabledBorder: pincode.text.length!=6 ? OutlineInputBorder(borderSide:BorderSide(color: Colors.red) ) :
                      OutlineInputBorder(borderSide:BorderSide(color: Colors.green) )
                  ),
            onChanged: (text) {
        setState(() {
          _checkInputLength(text,6);
        });
            },
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: citycontroller,
                  decoration: InputDecoration(labelText: "City"),
                ),

              DropdownButton(
                  value: selectedBrand,
                  items:brands.map<DropdownMenuItem<String>>((String brnd){
                return DropdownMenuItem<String>(value:brnd,child:Text(brnd));
              }).toList() , onChanged:(String? newbrnd){
                setState(() {
                  selectedBrand=newbrnd;
                  if(newbrnd!=null) {
                    print(123);
                    fetchCategories(newbrnd);
                  }
                });
              }),
        
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
                fetchProductsForCategory(selectedBrand!,newValue); // Fetch products for the selected category
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
                    createservicerequest(customerNameController.text,mobileNoController.text,address1Controller.text+","+address2Controller.text+","+address3Controller.text,pincode.text,citycontroller.text,selectedBrand!,selectedCategory!,_selectedValue!,dateController1.text,dateController2.text,complain.text,request!);
                    // Add submit logic here
                  },
                  child: Text("Save"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
