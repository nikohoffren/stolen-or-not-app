import 'package:flutter/material.dart';
import 'package:stolen_gear_app/themes/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginAndRegisterAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;

  const LoginAndRegisterAppBar({
    super.key,
    required this.title,
  }) : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  //* default size is 56.0
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
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
          Text(
            "  StolenOrNot?",
            style: GoogleFonts.abel(
              color: AppColors.secondaryColor,
              fontSize: 25.0
            ),
          ),
          Container(padding: const EdgeInsets.all(8.0), child: Text(title)),
        ],
      ),
    );
  }
}
