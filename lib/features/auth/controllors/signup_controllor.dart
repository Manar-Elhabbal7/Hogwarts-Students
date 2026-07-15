import 'package:flutter/cupertino.dart';

class SignUpController {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confPassController = TextEditingController();
  bool obsPass = true;
  bool obsConf = true;
  bool isChecked = false;

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    confPassController.dispose();
  }

  String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
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

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passController.text) {
      return 'Passwords do not match';
    }
    return null;
  }
}
