import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:lmrepaircrmapp/loginPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Log Flutter framework errors to console
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    debugPrint('══════ FLUTTER ERROR ══════');
    debugPrint(details.exceptionAsString());
    if (details.stack != null) {
      debugPrint(details.stack.toString());
    }
  };

  // Log asynchronous Dart / platform errors to console
  PlatformDispatcher.instance.onError = (error, stack) {
    debugPrint('══════ RUNTIME ASYNC ERROR ══════');
    debugPrint('Error: $error');
    debugPrint('Stack: $stack');
    return true;
  };

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
