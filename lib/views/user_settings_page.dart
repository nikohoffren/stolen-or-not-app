import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:stolen_gear_app/themes/app_colors.dart';
import 'package:stolen_gear_app/widgets/app_bottom_navigation_bar.dart';
import 'package:stolen_gear_app/widgets/custom_app_bar.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({Key? key}) : super(key: key);

  @override
  UserSettingsPageState createState() => UserSettingsPageState();
}

class UserSettingsPageState extends State<UserSettingsPage> {
  int _currentIndex = 0;

  void _settingsButtonPressed(BuildContext context) {
    Navigator.pop(context);
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future<List<Map<String, dynamic>>> getUserDevices() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return [];

    final userDevicesSnapshot = await FirebaseFirestore.instance
        .collection('devices')
        .where('userId', isEqualTo: user.uid)
        .get();

    return userDevicesSnapshot.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: CustomAppBar(
        title: 'Settings',
        onSettingsIconPressed: () => _settingsButtonPressed(context),
      ),
      body: FutureBuilder(
        future: getUserDevices(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}',
                    style: const TextStyle(color: AppColors.white)));
          } else if (snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No devices found.',
                    style: TextStyle(color: AppColors.white)));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) {
                Map<String, dynamic> device = snapshot.data![index];
                return ListTile(
                  title: Text(device['name'],
                      style: const TextStyle(color: AppColors.white)),
                  subtitle: Text(device['serialNumber'],
                      style: const TextStyle(color: AppColors.grey)),
                  tileColor: AppColors.black,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  leading: const Icon(Icons.devices,
                      color: AppColors.secondaryColor),
                );
              },
            );
          }
        },
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: _currentIndex,
        onTabTapped: _onTabTapped,
      ),
    );
  }
}
