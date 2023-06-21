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

  Stream<List<Map<String, dynamic>>> getUserDevices() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const Stream.empty();

    return FirebaseFirestore.instance
        .collection('devices')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return data;
            }).toList());
  }

  Future<void> reportStolenDevice(String deviceId, bool isStolen) async {
    await FirebaseFirestore.instance
        .collection('devices')
        .doc(deviceId)
        .update({'isStolen': !isStolen});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: CustomAppBar(
        title: 'Settings',
        onSettingsIconPressed: () => _settingsButtonPressed(context),
      ),
      body: StreamBuilder(
        stream: getUserDevices(),
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
                  title: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: device['name'],
                          style: const TextStyle(color: AppColors.white),
                        ),
                        if (device['isStolen'])
                          const TextSpan(
                            text: ' - You have reported this device stolen',
                            style: TextStyle(color: AppColors.red, fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  subtitle: Text(device['serialNumber'],
                      style: const TextStyle(color: AppColors.grey)),
                  tileColor: AppColors.black,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  leading: const Icon(Icons.devices,
                      color: AppColors.secondaryColor),
                  trailing: TextButton(
                    onPressed: () =>
                        reportStolenDevice(device['id'], device['isStolen']),
                    child: Text(
                      device['isStolen'] ? 'Unreport' : 'Report Stolen',
                      style: const TextStyle(color: AppColors.white),
                    ),
                  ),
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
