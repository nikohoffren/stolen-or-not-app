import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:stolen_gear_app/themes/app_colors.dart';
import 'package:stolen_gear_app/views/user_settings_page.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  AboutScreenState createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _settingsButtonPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const UserSettingsPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                child: Image.asset(
                  'assets/images/stolen-gear-logo.jpeg',
                  fit: BoxFit.cover,
                  height: 200,
                  width: 200,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Stolen Gear",
                style: GoogleFonts.abel(
                  color: AppColors.secondaryColor,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Version: 1.0.0',
                style: TextStyle(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Developed by: Niko Hoffrén',
                style: TextStyle(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Contact: niko.hoffren@gmail.com',
                style: TextStyle(
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
