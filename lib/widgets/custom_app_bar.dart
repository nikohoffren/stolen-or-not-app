import 'package:flutter/material.dart';
import 'package:stolen_gear_app/themes/app_colors.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback onSettingsIconPressed;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.onSettingsIconPressed,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize; // default is 56.0

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      title: Row(
        children: <Widget>[
          ClipOval(
            child: Image.asset(
              'assets/images/stolen-gear-logo.jpeg',
              fit: BoxFit.contain,
              height: 32,
            ),
          ),
          const Text(
            " Stolen Gear App",
            style: TextStyle(color: AppColors.secondaryColor),
          ),
          Container(padding: const EdgeInsets.all(8.0), child: Text(title)),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: onSettingsIconPressed,
        )
      ],
    );
  }
}
