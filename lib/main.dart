import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:lmrepaircrmapp/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const Lmcrm());
}

class Lmcrm extends StatelessWidget {
  const Lmcrm({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'LM Repair CRM',
      home: MyHomePage(),
    );
  }
}
