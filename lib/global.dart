import 'package:flutter/material.dart';

Map<String, String> error_messages = {
  'invalid-email': 'Enter a valid College Email ID',
  'not-in-list': 'Username or password is incorrect',
  'wrong-password': 'Username or password is incorrect',
  'email-already-in-use': 'Email already in use',
  'weak-password': 'Password is too weak',
  'too-many-requests': 'Too many requests',
  'network-request-failed': 'Network request failed',
  'user-disabled': 'User disabled',
  'operation-not-allowed': 'Operation not allowed',
  'email-already-exists': 'Email already exists',
  'operation-not-allowed': 'Operation not allowed. Please Contact the admins',
};

void showSnackBar(
    {required BuildContext context,
    Color color = Colors.red,
    required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(error_messages[message] ??
          'An error has occured. Please try again later.'),
      duration: const Duration(seconds: 2),
      backgroundColor: color,
    ),
  );
}
