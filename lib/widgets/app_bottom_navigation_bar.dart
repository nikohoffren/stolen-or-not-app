import 'package:flutter/material.dart';
import 'package:stolen_gear_app/themes/app_colors.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabTapped;

  const AppBottomNavigationBar(
      {super.key, required this.currentIndex, required this.onTabTapped});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabTapped,
      backgroundColor: AppColors.primaryColor,
      unselectedItemColor: AppColors.grey,
      selectedItemColor:
          AppColors.secondaryColor,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.info),
          label: 'About',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.check),
          label: 'Check',
        )
      ],
    );
  }
}
