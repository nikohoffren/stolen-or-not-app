// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stolen_gear_app/themes/app_colors.dart';
import 'package:stolen_gear_app/views/user_settings_page.dart';
import 'package:stolen_gear_app/widgets/privacy_policy.dart';

class AboutScreen extends StatefulWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  AboutScreenState createState() => AboutScreenState();
}

class AboutScreenState extends State<AboutScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _version = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  void _getAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = packageInfo.version;
    });
  }

  void _settingsButtonPressed() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const UserSettingsPage()),
    );
  }

  void _showAcknowledgments() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
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
                      title: const Text('Library 1',
                          style: TextStyle(color: Colors.white)),
                      subtitle: const Text('Description of Library 1',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Handle onTap for Library 1
                      },
                    ),
                    ListTile(
                      title: const Text('Library 2',
                          style: TextStyle(color: Colors.white)),
                      subtitle: const Text('Description of Library 2',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        // Handle onTap for Library 2
                      },
                    ),
                    // Add more ListTile widgets for each acknowledgment
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPrivacyPolicy() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            color: AppColors.primaryColor,
            child: Column(
              children: const [
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: PrivacyPolicy(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showBugReportModal() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final messageController = TextEditingController();

        return AlertDialog(
          title: const Text('Report a Bug'),
          content: TextField(
            controller: messageController,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Message',
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _sendBugReport(messageController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  void _sendBugReport(String reportMessage) async {
    final smtpServer = gmail('stolenornot.app@gmail.com',
        FlutterConfig.get('STOLEN_OR_NOT_EMAIL_PASSWORD'));

    final message = Message()
      ..from = const Address('stolenornot.app@gmail.com')
      ..recipients.add('stolenornot.app@gmail.com')
      ..subject = 'Bug Report - StolenOrNot?'
      ..text = reportMessage;

    try {
      final sendReport = await send(message, smtpServer);
      print('Bug report sent: $sendReport');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Bug Report Sent'),
          content: const Text('Thank you for reporting the bug!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } catch (error) {
      print('Error sending bug report: $error');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Error'),
          content:
              const Text('An error occurred while sending the bug report.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
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
                "StolenOrNot?",
                style: GoogleFonts.abel(
                  color: AppColors.secondaryColor,
                  fontSize: 32,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'Version: $_version',
                style: const TextStyle(
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
                'Contact: stolenornot.app@gmail.com',
                style: TextStyle(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _showAcknowledgments,
                child: const Text('Acknowledgments'),
              ),
              ElevatedButton(
                onPressed: _showPrivacyPolicy,
                child: const Text('Privacy Policy'),
              ),
              ElevatedButton(
                onPressed: _showBugReportModal,
                child: const Text('Report a Bug'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
