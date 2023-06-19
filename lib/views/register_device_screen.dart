import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stolen_gear_app/themes/app_colors.dart';

class RegisterDeviceScreen extends StatefulWidget {
  const RegisterDeviceScreen({super.key});

  @override
  RegisterDeviceScreenState createState() => RegisterDeviceScreenState();
}

class RegisterDeviceScreenState extends State<RegisterDeviceScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _serialNumberController = TextEditingController();
  final _deviceNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        title: const Text('Register Device'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _deviceNameController,
                decoration: const InputDecoration(
                  labelText: 'Device Name',
                  labelStyle: TextStyle(color: AppColors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white),
                  ),
                ),
                style: const TextStyle(color: AppColors.white),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the name of the device';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _serialNumberController,
                decoration: const InputDecoration(
                  labelText: 'Serial Number',
                  labelStyle: TextStyle(color: AppColors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.white),
                  ),
                ),
                style: const TextStyle(color: AppColors.white),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the serial number of the device';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final messenger = ScaffoldMessenger.of(context);
                    final name = _deviceNameController.text;
                    final serialNumber = _serialNumberController.text;

                    //* Checking for duplicate serial numbers
                    final duplicateSerialNumberSnapshot = await _db
                        .collection('devices')
                        .where('serialNumber', isEqualTo: serialNumber)
                        .get();

                    //* If a duplicate serial number exists, show a SnackBar
                    if (duplicateSerialNumberSnapshot.docs.isNotEmpty) {
                      messenger.showSnackBar(
                        const SnackBar(
                            content: Text(
                                'Device with this serial number already exists.')),
                      );
                      return;
                    }

                    //* If not, continue with device registration
                    _db.collection('devices').add({
                      'userId': _auth.currentUser?.uid,
                      'name': name,
                      'serialNumber': serialNumber,
                      'isStolen': false,
                    }).then((_) {
                      messenger.showSnackBar(
                        const SnackBar(
                            content: Text('Device registered successfully!')),
                      );
                    }).catchError((error) {
                      messenger.showSnackBar(
                        const SnackBar(
                            content: Text('Failed to register device.')),
                      );
                      print(error.toString());
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.white,
                ),
                child: const Text('Register Device'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}