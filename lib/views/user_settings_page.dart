// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stolen_gear_app/themes/app_colors.dart';
import 'package:stolen_gear_app/widgets/custom_app_bar.dart';
import 'package:stolen_gear_app/views/login_page.dart';
import 'package:intl/intl.dart';

class UserSettingsPage extends StatefulWidget {
  const UserSettingsPage({Key? key}) : super(key: key);

  @override
  UserSettingsPageState createState() => UserSettingsPageState();
}

class UserSettingsPageState extends State<UserSettingsPage> {
  int _currentIndex = 0;
  final _usernameController = TextEditingController();

  // Fetch user's info from Firebase
  User? getUser() {
    return FirebaseAuth.instance.currentUser;
  }

  @override
  void initState() {
    super.initState();
    fetchAndSetUserName();
  }

  Future<void> fetchAndSetUserName() async {
    final user = getUser();
    if (user != null) {
      final DocumentSnapshot docSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnap.exists) {
        Map<String, dynamic>? data = docSnap.data() as Map<String, dynamic>?;
        setState(() {
          _usernameController.text =
              data?['username'] ?? user.displayName ?? '';
        });
      } else {
        setState(() {
          _usernameController.text = user.displayName ?? '';
        });
      }
    }
  }

  Future<void> updateUsername(BuildContext context, String newUsername) async {
    final user = getUser();
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({'username': newUsername});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username successfully updated!'),
          backgroundColor: AppColors.secondaryColor,
        ),
      );
    }
  }

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
        .update({
      'isStolen': !isStolen,
      'reportedAt': !isStolen ? FieldValue.serverTimestamp() : null
    });
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = getUser();
    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: CustomAppBar(
        title: 'Settings',
        onSettingsIconPressed: () => _settingsButtonPressed(context),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                if (user?.photoURL != null)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ClipOval(
                      child: Image.network(
                        user!.photoURL!,
                        fit: BoxFit.cover,
                        height: 70,
                        width: 70,
                      ),
                    ),
                  ),
                Expanded(
                  child: TextFormField(
                    controller: _usernameController,
                    decoration: const InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(color: AppColors.white),
                    ),
                    style: const TextStyle(color: AppColors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextButton(
                    onPressed: () {
                      updateUsername(context, _usernameController.text);
                      FocusScope.of(context).unfocus();
                    },
                    child: const Text('Change Username',
                        style: TextStyle(color: AppColors.white)),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: getUserDevices(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                      child: LoadingAnimationWidget.staggeredDotsWave(
                    color: AppColors.secondaryColor,
                    size: 50,
                  ));
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Error: ${snapshot.error}',
                          style: const TextStyle(color: AppColors.white)));
                } else if (snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text('No devices found.',
                          style: TextStyle(color: AppColors.white)));
                } else {
                  return Column(
                    children: <Widget>[
                      const Divider(
                        color: AppColors.secondaryColor,
                        thickness: 2.0,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Registered devices',
                          style: TextStyle(
                            color: AppColors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (BuildContext context, int index) {
                            Map<String, dynamic> device = snapshot.data![index];
                            return ListTile(
                              title: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: device['name'],
                                      style: const TextStyle(
                                          color: AppColors.white),
                                    ),
                                    if (device['isStolen'])
                                      TextSpan(
                                        text:
                                            ' - You have reported this device stolen at ${device['reportedAt'] != null ? DateFormat('d MMMM yyyy, HH:mm').format(device['reportedAt'].toDate()) : 'unknown time'}',
                                        style: const TextStyle(
                                            color: AppColors.red, fontSize: 12),
                                      ),
                                  ],
                                ),
                              ),
                              subtitle: Text(device['serialNumber'],
                                  style:
                                      const TextStyle(color: AppColors.grey)),
                              tileColor: AppColors.black,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 8.0),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0)),
                              leading: const Icon(Icons.devices,
                                  color: AppColors.secondaryColor),
                              trailing: TextButton(
                                onPressed: () => reportStolenDevice(
                                    device['id'], device['isStolen']),
                                child: Text(
                                  device['isStolen']
                                      ? 'Unreport'
                                      : 'Report Stolen',
                                  style:
                                      const TextStyle(color: AppColors.white),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _signOut,
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.logout),
      ),
    );
  }
}
