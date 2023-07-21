import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stolen_gear_app/themes/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onSettingsIconPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onSettingsIconPressed,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  //* default size is 56.0
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      title: Row(
        children: <Widget>[
          ClipOval(
            child: Image.asset(
              'assets/images/stolen-gear-logo.jpeg',
              fit: BoxFit.cover,
              height: 32,
              width: 32,
            ),
          ),
          // Text(
          //   "  StolenOrNot?",
          //   style: GoogleFonts.abel(
          //     color: AppColors.secondaryColor,
          //     fontSize: 25.0,
          //   ),
          // ),
          const Spacer(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Text(title),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Center(
            child: FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user?.uid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError || snapshot.data == null) {
                  return const Text('Error');
                } else {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>?;

                  if (userData != null) {
                    final username = userData['username'] ?? user?.email;
                    return Text(
                      username ?? 'No email',
                      style: const TextStyle(color: AppColors.white),
                    );
                  } else {
                    return const Text('');
                  }
                }
              },
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: onSettingsIconPressed,
        )
      ],
    );
  }
}
