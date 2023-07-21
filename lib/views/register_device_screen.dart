// ignore_for_file: unused_element, unused_field

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
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
  final _additionalInfoController = TextEditingController();
  String? _selectedCategory;
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _currentIndex = 0;
  bool _isLoading = false;
  bool _showDropdownMenu = false;
  File? _selectedImage;

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

  String getSerialNumberLabel() {
    if (_selectedCategory == 'Phones & Tablets') {
      return 'IMEI';
    } else {
      return 'Serial Number';
    }
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

  Future<void> _selectImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<String?> _uploadImageToFirebaseStorage() async {
    if (_selectedImage == null) return null;

    try {
      final userId = _auth.currentUser?.uid;
      final imageFileName =
          '${DateTime.now().millisecondsSinceEpoch}_$userId.jpg';
      final storageRef = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('device_images')
          .child(imageFileName);
      final uploadTask = storageRef.putFile(_selectedImage!);
      final snapshot = await uploadTask.whenComplete(() => null);
      final imageUrl = await snapshot.ref.getDownloadURL();
      return imageUrl;
    } catch (error) {
      print('Error uploading image to Firebase Storage: $error');
      return null;
    }
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
            child: ListView(
              children: <Widget>[
                InkWell(
                  onTap: _selectImage,
                  child: Container(
                    width: double.infinity,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.secondaryColor),
                      borderRadius: BorderRadius.circular(8.0),
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: _selectedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.camera_alt,
                                color: AppColors.secondaryColor,
                                size: 48,
                              ),
                              Text(
                                'Select an Image',
                                style: TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 10),
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
                  decoration: InputDecoration(
                    labelText: getSerialNumberLabel(),
                    labelStyle: const TextStyle(color: AppColors.white),
                  ),
                  style: const TextStyle(color: AppColors.white),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter the ${getSerialNumberLabel().toLowerCase()} of the device';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _additionalInfoController,
                  decoration: const InputDecoration(
                    labelText: 'Additional Info',
                    labelStyle: TextStyle(color: AppColors.white),
                  ),
                  style: const TextStyle(color: AppColors.white),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            final messenger = ScaffoldMessenger.of(context);
                            final name = _deviceNameController.text;
                            final serialNumber = _serialNumberController.text;
                            final additionalInfo =
                                _additionalInfoController.text;
                            final ownerEmail = _auth.currentUser?.email;
                            setState(() {
                              _isLoading = true;
                            });

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
                                      'Device with this serial number or IMEI already exists.'),
                                  backgroundColor: AppColors.secondaryColor,
                                ),
                              );
                              setState(() {
                                _isLoading = false;
                              });
                              return;
                            }

                            //* If not, continue with device registration
                            final imageUrl =
                                await _uploadImageToFirebaseStorage();
                            _db.collection('devices').add({
                              'userId': _auth.currentUser?.uid,
                              'name': name,
                              'serialNumber': serialNumber,
                              'additionalInfo': additionalInfo,
                              'ownerEmail': ownerEmail,
                              'category': _selectedCategory,
                              'isStolen': false,
                              'imageUrl': imageUrl,
                            }).then((_) {
                              messenger.showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Device registered successfully'),
                                  backgroundColor: Colors.green,
                                ),
                              );
                              setState(() {
                                _deviceNameController.clear();
                                _serialNumberController.clear();
                                _additionalInfoController.clear();
                                _selectedImage = null;
                                _isLoading = false;
                              });
                            }).catchError((error) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Error occurred while registering device: $error'),
                                  backgroundColor: AppColors.secondaryColor,
                                ),
                              );
                              setState(() {
                                _isLoading = false;
                              });
                            });
                          }
                        },
                  child: _isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Register Device'),
                ),
                const SizedBox(height: 20),
                _buildFAQQuestion(
                  'What is IMEI and where to find it?',
                  'IMEI stands for International Mobile Equipment Identity. It is a unique identification or serial number that all mobile phones and smartphones have. You can usually find the IMEI number on the back of your phone or by dialing *#06# on your phone\'s dial pad.',
                ),
                _buildFAQQuestion(
                  'What is Serial number?',
                  'The serial number is a unique identifier assigned to a device by the manufacturer. It is usually located on the back of the device or in the device settings. For phones and tablets, the IMEI number can be used as the serial number. For other devices, check the user manual or the manufacturer\'s website for more information.',
                ),
                _buildFAQQuestion(
                  'What should I enter in the Additional Info field?',
                  'The Additional Info field is optional and can be used to provide any additional details or information about the device. You can use this field to include specific features, accessories, or any other relevant information that you want to associate with the device.',
                ),
                _buildFAQQuestion(
                  'What should I do if my device gets lost or stolen?',
                  'If your registered device gets lost or stolen you can click the settings-icon on top-left of the screen, which will open the Settings menu. In there you can see all the devices you have registered. Next to the device name you can click the "Report stolen" button to report the device lost or stolen. Now, if someone checks the IMEI or serial number of the device, they can see immidiately that it is stolen and how to proceed from there.',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
