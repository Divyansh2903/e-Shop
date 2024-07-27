import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pingolearn_assignment/constants/colors.dart';
import 'package:pingolearn_assignment/screens/auth/login_screen.dart';
import 'package:pingolearn_assignment/screens/home_screen.dart';
import 'package:pingolearn_assignment/services/firebase_services.dart';
import 'package:pingolearn_assignment/utils/app_spacing.dart';
import 'package:pingolearn_assignment/utils/navigation.dart';
import 'package:pingolearn_assignment/utils/showSnackbar.dart';
import 'package:pingolearn_assignment/widgets/primary_button.dart';
import 'package:pingolearn_assignment/widgets/textfield.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseService _firebaseService = FirebaseService();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
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

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      User? user = await _firebaseService.signUpWithEmailPassword(
        emailController.text,
        passwordController.text,
      );

      if (user != null) {
        try {
          await _firebaseService.storeUserEmailAndName(
            user.uid,
            emailController.text,
            nameController.text,
          );
        } catch (e) {
          showSnackBar(context, "Error storing data");
        }
      } else {
        showSnackBar(context, "Error signing up");
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
                          controller: nameController,
                          hintText: "Name",
                          validator: _validateName,
                        ),
                        AppSpacing.height(20),
                        GlobalTextField(
                          controller: emailController,
                          hintText: "Email",
                          validator: _validateEmail,
                        ),
                        AppSpacing.height(20),
                        GlobalTextField(
                          controller: passwordController,
                          hintText: "Password",
                          obscureText: true,
                          validator: _validatePassword,
                        ),
                        const Spacer(),
                        Center(
                          child: PrimaryButton(
                            text: "Signup",
                            onTap: _signup,
                          ),
                        ),
                        AppSpacing.height(20),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                const TextSpan(
                                  text: "Already have an account? ",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                                TextSpan(
                                  text: "Login",
                                  style: const TextStyle(
                                      color: AppColors.primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      navigate(context, const LoginScreen());
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
