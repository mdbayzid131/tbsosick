import 'package:get/get.dart';

class FormValidationController extends GetxController {
  // -------------------------------
  // Name
  // -------------------------------
  String? validName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your name';
    }
    if (value.trim().length < 3) {
      return 'Name must be at least 3 characters';
    }
    return null;
  }

  // -------------------------------
  // Username
  // -------------------------------
  String? validUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your username';
    }
    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(value.trim())) {
      return 'Username can contain letters, numbers, underscore';
    }
    return null;
  }

  // -------------------------------
  // Phone
  // -------------------------------
  String? validPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter phone number';
    }

    final phone = value.trim();

    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      return 'Phone number must be digits only';
    }

    if (phone.length < 10 || phone.length > 14) {
      return 'Phone number is not valid';
    }

    return null;
  }

  // -------------------------------
  // Email
  // -------------------------------
  String? validEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter your email';
    }

    final emailRegex =
    RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$');

    if (!emailRegex.hasMatch(value.trim())) {
      return 'Enter a valid email';
    }

    return null;
  }

  // -------------------------------
  // Password
  // -------------------------------
  String? validPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter password';
    }

    final password = value.trim();

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Password must include one uppercase letter';
    }

    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Password must include one lowercase letter';
    }

    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Password must include one number';
    }

    if (!RegExp(r'[!@#\$&*~]').hasMatch(password)) {
      return 'Password must include one special character';
    }

    return null;
  }

  // -------------------------------
  // Confirm Password
  // -------------------------------
  String? validConfirmPassword(String? value, String password) {
    if (value == null || value.trim().isEmpty) {
      return 'Confirm your password';
    }
    if (value.trim() != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  // -------------------------------
  // Date of Birth
  // -------------------------------
  String? validDOB(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Date of birth is required';
    }
    return null;
  }

  // -------------------------------
  // OTP
  // -------------------------------
  String? validOtp(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Enter OTP';
    }
    if (value.trim().length != 6) {
      return 'OTP must be 6 digits';
    }
    if (!RegExp(r'^[0-9]+$').hasMatch(value.trim())) {
      return 'OTP must be digits only';
    }
    return null;
  }

  // -------------------------------
  // Required Field
  // -------------------------------
  String? validRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  // -------------------------------
  // Min Length
  // -------------------------------
  String? validMinLength(String? value, int length, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (value.trim().length < length) {
      return '$fieldName must be at least $length characters';
    }
    return null;
  }
}
