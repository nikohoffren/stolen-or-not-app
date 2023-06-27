import 'package:flutter/material.dart';
import 'package:stolen_gear_app/themes/app_colors.dart';

class Acknowledgments extends StatelessWidget {
  const Acknowledgments({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryColor,
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Acknowledgments',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: const Text('Cupertino Icons'),
                  subtitle: const Text('Icon library for iOS-styled icons'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for Cupertino Icons acknowledgment
                  },
                ),
                ListTile(
                  title: const Text('Firebase'),
                  subtitle:
                      const Text('Authentication, Database, and Core Services'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for Firebase acknowledgment
                  },
                ),
                ListTile(
                  title: const Text('Cloud Firestore'),
                  subtitle:
                      const Text('NoSQL database for storing structured data'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for Cloud Firestore acknowledgment
                  },
                ),
                ListTile(
                  title: const Text('Firebase Core'),
                  subtitle:
                      const Text('Foundation library for Firebase services'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for Firebase Core acknowledgment
                  },
                ),
                ListTile(
                  title: const Text('Google Sign-In'),
                  subtitle:
                      const Text('Sign-in integration with Google accounts'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for Google Sign-In acknowledgment
                  },
                ),
                ListTile(
                  title: const Text('intl'),
                  subtitle: const Text(
                      'Internationalization and localization support'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for intl acknowledgment
                  },
                ),
                ListTile(
                  title: const Text('Google Fonts'),
                  subtitle: const Text('Customizable fonts from Google Fonts'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for Google Fonts acknowledgment
                  },
                ),
                ListTile(
                  title: const Text('Loading Animation Widget'),
                  subtitle:
                      const Text('Customizable loading animation widgets'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for Loading Animation Widget acknowledgment
                  },
                ),
                ListTile(
                  title: const Text('Image Picker'),
                  subtitle: const Text(
                      'Image selection from device gallery or camera'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for Image Picker acknowledgment
                  },
                ),
                ListTile(
                  title: const Text('Firebase Storage'),
                  subtitle: const Text(
                      'Cloud storage for storing and serving user-generated content'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for Firebase Storage acknowledgment
                  },
                ),
                ListTile(
                  title: const Text('Path'),
                  subtitle:
                      const Text('Manipulate, join, and search file paths'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for Path acknowledgment
                  },
                ),
                ListTile(
                  title: const Text('Page Transition'),
                  subtitle:
                      const Text('Customizable page transition animations'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for Page Transition acknowledgment
                  },
                ),
                ListTile(
                  title: const Text('Mailer'),
                  subtitle: const Text('Send email messages using SMTP'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for Mailer acknowledgment
                  },
                ),
                ListTile(
                  title: const Text('flutter_dotenv'),
                  subtitle:
                      const Text('Load environment variables from a .env file'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for flutter_dotenv acknowledgment
                  },
                ),
                ListTile(
                  title: const Text('flutter_config'),
                  subtitle: const Text(
                      'Load environment configuration from platform-specific sources'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for flutter_config acknowledgment
                  },
                ),
                ListTile(
                  title: const Text('Package Info Plus'),
                  subtitle:
                      const Text('Retrieve package information at runtime'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for Package Info Plus acknowledgment
                  },
                ),
                ListTile(
                  title: const Text('Flutter Email Sender'),
                  subtitle: const Text(
                      'Send email messages using platform-specific email clients'),
                  textColor: Colors.white,
                  onTap: () {
                    // Handle onTap for Flutter Email Sender acknowledgment
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
