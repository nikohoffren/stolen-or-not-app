// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:stolen_gear_app/themes/app_colors.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  Future<void> _register() async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      //* Clear the error message
      setState(() {
        _errorMessage = null;
      });

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        setState(() {
          _errorMessage = 'The account already exists for that email.';
        });
      } else {
        setState(() {
          _errorMessage = 'An error occurred. Please try again.';
        });
        print(e);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred. Please try again.';
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Register',
              style: TextStyle(color: AppColors.white, fontSize: 24),
            ),
            const SizedBox(height: 20),
            if (_errorMessage != null)
              Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
              ),
            Form(
              key: _formKey,
              child: Theme(
                data: Theme.of(context).copyWith(
                  inputDecorationTheme: const InputDecorationTheme(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondaryColor),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: AppColors.secondaryColor),
                    ),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: AppColors.white),
                        ),
                        style: const TextStyle(color: AppColors.white),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: AppColors.white),
                        ),
                        obscureText: true,
                        style: const TextStyle(color: AppColors.white),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _register,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryColor,
                          foregroundColor: AppColors.white,
                        ),
                        child: const Text('Register'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
