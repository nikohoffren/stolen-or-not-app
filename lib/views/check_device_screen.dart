import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stolen_gear_app/themes/app_colors.dart';
import 'package:stolen_gear_app/views/user_settings_page.dart';

class CheckDeviceScreen extends StatefulWidget {
  const CheckDeviceScreen({super.key});

  @override
  CheckDeviceScreenState createState() => CheckDeviceScreenState();
}

class CheckDeviceScreenState extends State<CheckDeviceScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _serialNumberController = TextEditingController();

  int _currentIndex = 0;
  bool _isLoading = false;
  TextSpan _deviceStatus = const TextSpan(text: '');

  void _onTabTapped(int index) => setState(() => _currentIndex = index);
  void _settingsButtonPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const UserSettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Theme(
            data: Theme.of(context).copyWith(
              inputDecorationTheme: const InputDecorationTheme(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryColor),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: AppColors.secondaryColor),
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: <Widget>[
                  TextFormField(
                    controller: _serialNumberController,
                    decoration: const InputDecoration(
                      labelText: 'Serial Number',
                      labelStyle: TextStyle(color: AppColors.white),
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
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                                _deviceStatus = const TextSpan(text: '');
                              });
                              final serialNumber = _serialNumberController.text;

                              //* Checking for stolen devices
                              final deviceSnapshot = await _db
                                  .collection('devices')
                                  .where('serialNumber',
                                      isEqualTo: serialNumber)
                                  .get();

                              //* If a device exists, check if it is stolen
                              if (deviceSnapshot.docs.isNotEmpty) {
                                var device = deviceSnapshot.docs.first.data();
                                _deviceStatus = device['isStolen']
                                    ? TextSpan(
                                        text:
                                            'WARNING! This device is reported stolen by ${device['ownerEmail']}!',
                                        style: const TextStyle(color: Colors.red))
                                    : const TextSpan(
                                        text:
                                            'This device is not reported stolen.',
                                        style: TextStyle(color: Colors.green));
                              } else {
                                _deviceStatus = const TextSpan(
                                    text:
                                        'Device with this serial number does not exist.',
                                    style: TextStyle(color: Colors.orange));
                              }

                              setState(() {
                                _isLoading = false;
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.white,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Check Device'),
                  ),
                  if (_deviceStatus.text?.isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RichText(
                        text: _deviceStatus,
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
