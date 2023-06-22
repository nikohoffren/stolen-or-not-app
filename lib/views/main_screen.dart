import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stolen_gear_app/themes/app_colors.dart';
import 'package:stolen_gear_app/views/about_screen.dart';
import 'package:stolen_gear_app/views/check_device_screen.dart';
import 'package:stolen_gear_app/views/register_device_screen.dart';
import 'package:stolen_gear_app/views/user_settings_page.dart';
import 'package:stolen_gear_app/widgets/app_bottom_navigation_bar.dart';
import 'package:stolen_gear_app/widgets/custom_app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class MainScreenState extends State<MainScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final _serialNumberController = TextEditingController();
  final _deviceNameController = TextEditingController();

  int _currentIndex = 0;
  bool _isLoading = false;

  final List<Widget> _children = [
    const RegisterDeviceScreen(),
    const CheckDeviceScreen(),
    const AboutScreen()
  ];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _settingsButtonPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const UserSettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: CustomAppBar(
        title: '',
        onSettingsIconPressed: _settingsButtonPressed,
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}
