import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

Map<String, String> errorMessages = {
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
};

void showSnackBar(
    {required BuildContext context,
    Color color = Colors.red,
    required String message}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(errorMessages[message] ??
          'An error has occured. Please try again later.'),
      duration: const Duration(seconds: 2),
      backgroundColor: color,
    ),
  );
}

Map<String, String> hostelName = {
  'DJ': 'Diamond Jubilee Hostel',
  'K': 'Kennedy Hostel',
  'MB': 'Mar Baselios Hostel',
  'HS1': 'Haile Selassie Hostel - I',
  'HS2': 'Haile Selassie Hostel - II',
};

class TestClass {
  static void callback(String id, DownloadTaskStatus status, int progress) {}
}
