import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

const String _apiBaseUrl = 'https://limsonvercelapi2.vercel.app';
const String _addComplaintUrl = '$_apiBaseUrl/api/fsaddcomplaint';
const String _sendSmsUrl = '$_apiBaseUrl/api/fssendsms';

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

  const complaincollection({super.key, required this.token});

  @override
  State<complaincollection> createState() => _complaincollectionState();
}

class _complaincollectionState extends State<complaincollection> {
  final _formKey = GlobalKey<FormState>();
  DateTime? selectedDate;
  DateTime? selectedDate2;
  List<String> products = [];
  List<String> categories = [];
  List<String> brands = [];
  String? selectedCategory;
  String? selectedBrand;
  String? request;
  bool _showPdfButton = false;

  //String formattedDate = DateFormat('yyyy-MM-dd').format(datenow.);

  // Controllers for form fields
  final TextEditingController customerNameController = TextEditingController();
  final TextEditingController mobileNoController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController address3Controller = TextEditingController();
  final TextEditingController pincode = TextEditingController();
  final TextEditingController citycontroller = TextEditingController();
  final TextEditingController productname = TextEditingController();
  final TextEditingController complain = TextEditingController();

  final TextEditingController dateController1 = TextEditingController();
  final TextEditingController dateController2 = TextEditingController();

  String? _selectedValue;

  @override
  void initState() {
    super.initState();
    // _selectedValue = 'Iron';
    request = 'Complain';
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

  Future<pw.Document> _generatePdfDocument() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(32),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(
                          'LM REPAIR SERVICES',
                          style: pw.TextStyle(
                            fontSize: 24,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.blue900,
                          ),
                        ),
                        pw.SizedBox(height: 4),
                        pw.Text(
                          'Service Request Job Sheet',
                          style: pw.TextStyle(
                            fontSize: 14,
                            color: PdfColors.grey700,
                          ),
                        ),
                      ],
                    ),
                    pw.Text(
                      DateTime.now().toLocal().toString().split(' ')[0],
                      style: const pw.TextStyle(
                        fontSize: 12,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
                pw.Divider(thickness: 2, color: PdfColors.blue900),
                pw.SizedBox(height: 20),

                // Customer Details Header
                pw.Text(
                  'Customer Details',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                  children: [
                    _buildPdfTableRow('Customer Name', customerNameController.text),
                    _buildPdfTableRow('Phone', '+91 ${mobileNoController.text}'),
                    _buildPdfTableRow('Address', '${address1Controller.text}, ${address2Controller.text}, ${address3Controller.text}'),
                    _buildPdfTableRow('City', citycontroller.text),
                    _buildPdfTableRow('Pincode', pincode.text),
                  ],
                ),
                pw.SizedBox(height: 24),

                // Request Details Header
                pw.Text(
                  'Request & Appliance Details',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
                  children: [
                    _buildPdfTableRow('Request Type', request ?? ''),
                    _buildPdfTableRow('Brand', selectedBrand ?? ''),
                    _buildPdfTableRow('Category', selectedCategory ?? ''),
                    _buildPdfTableRow('Product Name', _selectedValue ?? ''),
                    _buildPdfTableRow('Purchase Date', dateController1.text),
                    _buildPdfTableRow('Warranty Expiry', dateController2.text),
                  ],
                ),
                pw.SizedBox(height: 24),

                // Complain/Remark Header
                pw.Text(
                  'Complain / Remark Details',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue800,
                  ),
                ),
                pw.SizedBox(height: 10),
                pw.Container(
                  width: double.infinity,
                  padding: const pw.EdgeInsets.all(12),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                  ),
                  child: pw.Text(
                    complain.text.isNotEmpty ? complain.text : 'No remarks specified.',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ),
                pw.Spacer(),

                // Footer
                pw.Divider(thickness: 1, color: PdfColors.grey300),
                pw.SizedBox(height: 8),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                      'Thank you for choosing LM Repair Services',
                      style: pw.TextStyle(
                        fontSize: 10,
                        fontStyle: pw.FontStyle.italic,
                        color: PdfColors.grey600,
                      ),
                    ),
                    pw.Text(
                      'System Generated Copy',
                      style: pw.TextStyle(
                        fontSize: 10,
                        color: PdfColors.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );

    return pdf;
  }

  Future<void> _showPdfActions(BuildContext context) async {
    final pdfDoc = await _generatePdfDocument();
    final pdfBytes = await pdfDoc.save();
    final fileName = 'LM_Complaint_${customerNameController.text.replaceAll(' ', '_')}.pdf';

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.print, color: Colors.blueAccent),
                title: const Text('Print PDF'),
                onTap: () async {
                  Navigator.pop(context);
                  await Printing.layoutPdf(
                    onLayout: (PdfPageFormat format) async => pdfBytes,
                    name: fileName,
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.share, color: Colors.green),
                title: const Text('Share PDF (WhatsApp, Email, etc.)'),
                onTap: () async {
                  Navigator.pop(context);
                  await Printing.sharePdf(
                    bytes: pdfBytes,
                    filename: fileName,
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  pw.TableRow _buildPdfTableRow(String label, String value) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            label,
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11),
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(8),
          child: pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ),
      ],
    );
  }

  void _checkInputLength(String text, int requiredLength) {
    if (text.length != requiredLength) {
      HapticFeedback.vibrate(); // Trigger haptic feedback for invalid length
    }
  }

  Future<void> fetchbrands() async {
    final response = await http.get(
      Uri.parse(
          'https://limsonvercelapi2.vercel.app/api/fsproductservice?level=brands'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> brandlist = jsonDecode(response.body);
      setState(() {
        brands = brandlist.map((b) => b.toString()).toList();
      });

//print(response.body);
    } else {
      throw Exception('Failed to load brands');
      // print(response.statusCode);
    }
  }

  Future<void> fetchCategories(String Brand) async {
    final response = await http.get(
      Uri.parse(
          'https://limsonvercelapi2.vercel.app/api/fsproductservice?level=categories&brand=$Brand'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> categoryList = json.decode(response.body);
      setState(() {
        categories =
            categoryList.map((category) => category.toString()).toList();
      });
      // print(categories);
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> fetchProductsForCategory(String Brand, String categoryId) async {
    final response = await http.get(
      Uri.parse(
          'https://limsonvercelapi2.vercel.app/api/fsproductservice?level=products&brand=$Brand&category=$categoryId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${widget.token}',
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

  Future<bool> createservicerequest(
      String name,
      String phone,
      String address,
      String pincode,
      String cityname,
      String brand,
      String category,
      String product,
      String pdate,
      String wdate,
      String complaint,
      String service) async {
    var url = _addComplaintUrl;
//var url2='http://localhost:3000/api/addcomplaint';
//print(datenow.toLocal().toString().split(' ')[0]);
//print(formattedDate);

    try {
      var response = await http.post(Uri.parse(url),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${widget.token}',
          },
          body: jsonEncode({
            "fields": {
              "Customer name": name,
              "Phone": "+91$phone",
              "address": address,
              "pincode": pincode,
              "city": cityname,
              "Brand": brand,
              "Category": category,
              "Product name": product,
              "Purchase date": pdate,
              "warranty expiry date": wdate,
              "Complain/Remark": complaint,
              "Request Type": service,
              //      "date of complain":formattedDate
            }
          }));
      if (response.statusCode == 200) {
        debugPrint('Record created successfully: ${response.body}');
        return true;
      } else {
        debugPrint(
            'Failed to create record: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (error) {
      debugPrint('Failed to create record: $error');
      return false;
    }
  }

  Future<bool> sendComplaintSms(String name, String phone, String brand,
      String product, String service) async {
    final normalizedPhone = phone.startsWith('+91') ? phone : '+91$phone';
    final customerName = name.trim().isEmpty ? 'Customer' : name.trim();
    final message =
        'Dear $customerName, your $service request for $brand $product has been registered. We will contact you shortly.';

    try {
      final response = await http.post(
        Uri.parse(_sendSmsUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'phone': normalizedPhone,
          'message': message,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        debugPrint('SMS sent successfully: ${response.body}');
        return true;
      }

      debugPrint('Failed to send SMS: ${response.statusCode} ${response.body}');
      return false;
    } catch (error) {
      debugPrint('Failed to send SMS: $error');
      return false;
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
        dateController1.text = "${picked.toLocal()}"
            .split(' ')[0]; // Update the text field with the selected date
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
        dateController2.text = "${picked.toLocal()}"
            .split(' ')[0]; // Update the text field with the selected date
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
                        color: mobileNoController.text.length != 10
                            ? Colors.red
                            : Colors.green,
                      ),
                    ),
                    onChanged: (val) {
                      setState(() {
                        _checkInputLength(val, 10);
                      });
                    }),
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
                  decoration: InputDecoration(
                      labelText: "Pincode",
                      enabledBorder: pincode.text.length != 6
                          ? OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red))
                          : OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.green))),
                  onChanged: (text) {
                    setState(() {
                      _checkInputLength(text, 6);
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
                    items: brands.map<DropdownMenuItem<String>>((String brnd) {
                      return DropdownMenuItem<String>(
                          value: brnd, child: Text(brnd));
                    }).toList(),
                    onChanged: (String? newbrnd) {
                      setState(() {
                        selectedBrand = newbrnd;
                        if (newbrnd != null) {
                          print(123);
                          fetchCategories(newbrnd);
                        }
                      });
                    }),
                DropdownButton(
                    value: _selectedValue,
                    items: products
                        .map<DropdownMenuItem<String>>((String product) {
                      return DropdownMenuItem<String>(
                          value: product,
                          child:
                              Text(product, overflow: TextOverflow.ellipsis));
                    }).toList(),
                    onChanged: (productselected) {
                      setState(() {
                        _selectedValue = productselected;
                      });
                    }),
                DropdownButton(
                  value: selectedCategory,
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategory = newValue as String?;
                    });
                    if (newValue != null) {
                      fetchProductsForCategory(selectedBrand!,
                          newValue); // Fetch products for the selected category
                    }
                  },
                  items: categories
                      .map<DropdownMenuItem<String>>((String category) {
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
                  decoration:
                      InputDecoration(labelText: "Warranty expiry date"),
                  onTap: () => _selectwarrantyDate(context),
                ),
                TextField(
                  controller: complain,
                  decoration: InputDecoration(labelText: "complain/remark"),
                ),
                DropdownButton(
                    value: request,
                    items: [
                      DropdownMenuItem(
                        value: 'Complain',
                        child: Text('Complain'),
                      ),
                      DropdownMenuItem(
                        value: 'Service',
                        child: Text('Service'),
                      ),
                      DropdownMenuItem(
                          value: 'Installation', child: Text('Installation')),
                      DropdownMenuItem(value: 'demo', child: Text('demo')),
                    ],
                    onChanged: (servicetype) {
                      setState(() {
                        request = servicetype;
                      });
                    }),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        final complaintSaved = await createservicerequest(
                            customerNameController.text,
                            mobileNoController.text,
                            address1Controller.text +
                                "," +
                                address2Controller.text +
                                "," +
                                address3Controller.text,
                            pincode.text,
                            citycontroller.text,
                            selectedBrand!,
                            selectedCategory!,
                            _selectedValue!,
                            dateController1.text,
                            dateController2.text,
                            complain.text,
                            request!);
                        if (!context.mounted) return;

                        if (!complaintSaved) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Complaint registration failed')),
                          );
                          return;
                        }

                        setState(() {
                          _showPdfButton = true;
                        });

                        final smsSent = await sendComplaintSms(
                            customerNameController.text,
                            mobileNoController.text,
                            selectedBrand!,
                            _selectedValue!,
                            request!);
                        if (!context.mounted) return;

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              smsSent
                                  ? 'Complaint registered and SMS sent'
                                  : 'Complaint registered, but SMS failed',
                            ),
                          ),
                        );
                      },
                      child: const Text("Save"),
                    ),
                    if (_showPdfButton) ...[
                      const SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () => _showPdfActions(context),
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text("Print/Share PDF"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
