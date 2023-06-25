import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_config/flutter_config.dart';

import 'package:stolen_gear_app/views/login_page.dart';
import 'package:stolen_gear_app/views/main_screen.dart';
import 'package:stolen_gear_app/views/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterConfig.loadEnvVariables();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StolenOrNot?',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: const SplashScreen(), // Use SplashScreen as the initial route
    );
  }
}


class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<bool>(
      stream: authService.isLoggedIn,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show the SplashScreen while checking the authentication status
          return const SplashScreen();
        } else if (snapshot.hasData && snapshot.data!) {
          // User is logged in, navigate to MainScreen
          return const MainScreen();
        } else {
          // User is not logged in, navigate to LoginPage
          return const LoginPage();
        }
      },
    );
  }
}
