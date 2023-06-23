import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stolen_gear_app/themes/app_colors.dart';
import 'package:stolen_gear_app/views/user_settings_page.dart';

class CheckDeviceScreen extends StatefulWidget {
  const CheckDeviceScreen({Key? key}) : super(key: key);

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

  Widget _buildFAQModal(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          answer,
          style: const TextStyle(color: AppColors.white),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildFAQQuestion(String question, String answer) {
    return ListTile(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppColors.black,
            content: SingleChildScrollView(
              child: _buildFAQModal(question, answer),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  'Close',
                  style: TextStyle(color: AppColors.grey),
                ),
              ),
            ],
          ),
        );
      },
      title: Text(
        question,
        style: const TextStyle(color: AppColors.secondaryColor),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        color: AppColors.secondaryColor,
      ),
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
                      labelText: 'Serial Number or IMEI',
                      labelStyle: TextStyle(color: AppColors.white),
                    ),
                    style: const TextStyle(color: AppColors.white),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please enter the serial number or IMEI of the device';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isLoading = true;
                                  _deviceStatus = const TextSpan(text: '');
                                });
                                final serialNumber =
                                    _serialNumberController.text;

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
                                              'This device is reported stolen by ${device['ownerUsername']} at ${device['reportedAt'] != null ? DateFormat('d MMMM yyyy, HH:mm').format(device['reportedAt'].toDate()) : 'unknown time'}!',
                                          style: const TextStyle(
                                              color: Colors.red))
                                      : const TextSpan(
                                          text:
                                              'This device is not reported stolen.',
                                          style:
                                              TextStyle(color: Colors.green));
                                } else {
                                  _deviceStatus = const TextSpan(
                                      text:
                                          'Device with this serial number or IMEI does not exist.',
                                      style: TextStyle(color: Colors.orange));
                                }

                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.secondaryColor,
                        foregroundColor: AppColors.white,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text('Check Device'),
                    ),
                  ),
                  if (_deviceStatus.text?.isNotEmpty ?? false)
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: RichText(
                        text: _deviceStatus,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  const SizedBox(height: 20),
                  _buildFAQQuestion(
                    'What should I do if I see that the device is stolen?',
                    'If you suspect that a device is stolen, do not purchase or engage in any transaction involving the device. Contact your local law enforcement agency to report the stolen device and provide them with any relevant information or evidence you have. It is important to cooperate with authorities to help recover stolen devices and prevent further illegal activities.',
                  ),
                  _buildFAQQuestion(
                    'What is IMEI and where to find it?',
                    'IMEI stands for International Mobile Equipment Identity. It is a unique identification or serial number that all mobile phones and smartphones have. You can usually find the IMEI number on the back of your phone or by dialing *#06# on your phone\'s dial pad.',
                  ),
                  _buildFAQQuestion(
                    'What is Serial number?',
                    'The serial number is a unique identifier assigned to a device by the manufacturer. It is usually located on the back of the device or in the device settings. For phones and tablets, the IMEI number can be used as the serial number. For other devices, check the user manual or the manufacturer\'s website for more information.',
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
