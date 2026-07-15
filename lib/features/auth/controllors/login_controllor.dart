import 'package:flutter/cupertino.dart';

class LoginController {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  bool obsPass = true;
  bool isChecked = false;

  void dispose() {
    emailController.dispose();
    passController.dispose();
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email address';
    }
    final eRegex = RegExp(r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!eRegex.hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }
}
