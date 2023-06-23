import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stolen_gear_app/themes/app_colors.dart';
import 'package:stolen_gear_app/views/user_settings_page.dart';

class RegisterDeviceScreen extends StatefulWidget {
  const RegisterDeviceScreen({Key? key}) : super(key: key);

  @override
  RegisterDeviceScreenState createState() => RegisterDeviceScreenState();
}

class RegisterDeviceScreenState extends State<RegisterDeviceScreen>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _serialNumberController = TextEditingController();
  final _deviceNameController = TextEditingController();
  String? _selectedCategory;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _currentIndex = 0;
  bool _isLoading = false;
  bool _showDropdownMenu = false;

  final List<String> _deviceCategories = [
    'Phones & Tablets',
    'Musical Instruments',
    'Gaming Consoles',
    'Home Electronics',
    'Other',
  ];

  void _onTabTapped(int index) => setState(() => _currentIndex = index);
  void _settingsButtonPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const UserSettingsPage()),
    );
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _selectedCategory = _deviceCategories[0];
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                    controller: _deviceNameController,
                    decoration: const InputDecoration(
                      labelText: 'Device Name',
                      labelStyle: TextStyle(color: AppColors.white),
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
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.secondaryColor),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: DropdownButtonFormField<String>(
                      dropdownColor: AppColors.black,
                      value: _selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        labelStyle: TextStyle(color: AppColors.white),
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(color: AppColors.white),
                      items: _deviceCategories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(
                            category,
                            style: const TextStyle(color: AppColors.white),
                          ),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
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
                  ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              final messenger = ScaffoldMessenger.of(context);
                              final name = _deviceNameController.text;
                              final serialNumber = _serialNumberController.text;
                              final ownerEmail = _auth.currentUser?.email;
                              setState(() {
                                _isLoading = true;
                              });
                              //* Checking for duplicate serial numbers
                              final duplicateSerialNumberSnapshot = await _db
                                  .collection('devices')
                                  .where('serialNumber',
                                      isEqualTo: serialNumber)
                                  .get();

                              //* If a duplicate serial number exists, show a SnackBar
                              if (duplicateSerialNumberSnapshot
                                  .docs.isNotEmpty) {
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        'Device with this serial number or IMEI already exists.'),
                                    backgroundColor: AppColors.secondaryColor,
                                  ),
                                );
                                return;
                              }

                              //* If not, continue with device registration
                              _db.collection('devices').add({
                                'userId': _auth.currentUser?.uid,
                                'name': name,
                                'serialNumber': serialNumber,
                                'ownerEmail': ownerEmail,
                                'category': _selectedCategory,
                                'isStolen': false,
                              }).then((_) {
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text('Device registered successfully!'),
                                    backgroundColor: AppColors.secondaryColor,
                                  ),
                                );
                              }).catchError((error) {
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text('Failed to register device.'),
                                    backgroundColor: AppColors.secondaryColor,
                                  ),
                                );
                                print(error.toString());
                              }).whenComplete(() {
                                setState(() {
                                  _isLoading = false;
                                });
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                      foregroundColor: AppColors.white,
                    ),
                    child: _isLoading
                        ? LoadingAnimationWidget.staggeredDotsWave(
                            color: AppColors.secondaryColor,
                            size: 50,
                          )
                        : const Text('Register Device'),
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
