import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stolen_gear_app/views/register_device_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stolen Gear App',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: const RegisterDeviceScreen(),
    );
  }
}
