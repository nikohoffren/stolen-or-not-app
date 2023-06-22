// ignore_for_file: use_build_context_synchronously
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:stolen_gear_app/themes/app_colors.dart';
import 'package:stolen_gear_app/views/main_screen.dart';
import 'package:stolen_gear_app/views/register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorMessage;

  bool _isLoading = false;

  Future<void> _signInWithEmailPassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        final localContext = context;

        Navigator.pushReplacement(
          localContext,
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          setState(() {
            _errorMessage = 'No user found for that email.';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            _errorMessage = 'Wrong password provided for that user.';
          });
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  Future<UserCredential> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    if (userCredential.user != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    }
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
    return userCredential;
  }

  void _register() {
    final localContext = context;

    Navigator.push(localContext,
        MaterialPageRoute(builder: (context) => const RegisterPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: _isLoading
          ? Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
              color: AppColors.secondaryColor,
              size: 150,
            ))
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ClipOval(
                    child: Image.asset(
                      'assets/images/stolen-gear-logo.jpeg',
                      fit: BoxFit.cover,
                      height: 120,
                      width: 120,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Stolen Gear",
                    style: GoogleFonts.abel(
                      color: AppColors.secondaryColor,
                      fontSize: 42,
                    ),
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
                            borderSide:
                                BorderSide(color: AppColors.secondaryColor),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: AppColors.secondaryColor),
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
                              onPressed:
                                  _isLoading ? null : _signInWithEmailPassword,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: AppColors.white,
                              ),
                              child: const Text('Sign In with Email'),
                            ),
                            const SizedBox(height: 10),
                            InkWell(
                              onTap: _isLoading
                                  ? null
                                  : () async {
                                      final UserCredential user =
                                          await _signInWithGoogle();
                                      if (user.user != null) {
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MainScreen(),
                                          ),
                                        );
                                      }
                                    },
                              child: Image.asset(
                                'assets/images/google_button.png',
                                height: 50.0,
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _isLoading ? null : _register,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryColor,
                                foregroundColor: AppColors.white,
                              ),
                              child: const Text('Register with Email'),
                            ),
                            const SizedBox(height: 20),
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
