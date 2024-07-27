import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pingolearn_assignment/constants/colors.dart';
import 'package:pingolearn_assignment/screens/auth/registration_screen.dart';
import 'package:pingolearn_assignment/services/firebase_services.dart';
import 'package:pingolearn_assignment/utils/app_spacing.dart';
import 'package:pingolearn_assignment/utils/navigation.dart';
import 'package:pingolearn_assignment/utils/showSnackbar.dart';
import 'package:pingolearn_assignment/widgets/primary_button.dart';
import 'package:pingolearn_assignment/widgets/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();
  final _formKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    return null;
  }

  void _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      User? user = await _firebaseService.signInWithEmailPassword(
          emailController.text, passwordController.text);

      print(user);
      if (user == null) {
        showSnackBar(
          context,
          "Please enter correct email and password",
        );
      } else {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppSpacing.height(10),
                        const Text(
                          "e-Shop",
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          ),
                        ),
                        const Spacer(),
                        GlobalTextField(
                          controller: emailController,
                          hintText: "Email",
                          validator: _validateEmail,
                        ),
                        AppSpacing.height(20),
                        GlobalTextField(
                          controller: passwordController,
                          hintText: "Password",
                          validator: _validatePassword,
                        ),
                        const Spacer(),
                        Center(
                            child: PrimaryButton(text: "Login", onTap: _login)),
                        AppSpacing.height(20),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "New here? ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                TextSpan(
                                  text: "Signup",
                                  style: const TextStyle(
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.pop(context);
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                        AppSpacing.height(50),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}