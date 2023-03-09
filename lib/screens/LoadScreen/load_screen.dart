import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class LoadScreen extends StatefulWidget {
  @override
  _LoadScreenState createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  bool isSignedIn = false;

  Future<bool> checkInternetConnection() async {
    print("checkInternetConnection");
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(Duration(seconds: 5));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    } on TimeoutException catch (_) {
      return false;
    }
    return false;
  }

  void _checkInternetConnectionAndNavigate() async {
    print("checkInternetConnectionAndNavigate");
    bool isConnected = await checkInternetConnection();
    print("checkInternetConnectionAndNavigate");
    if (isConnected) {
      if (isSignedIn) {
        Navigator.pushNamed(context, '/home');
      } else {
        Navigator.pushNamed(context, '/login');
      }
    } else {
      _retryDialog();
    }
  }

  void _retryDialog() async {
    print("retryDialog");
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("No internet connection"),
            content:
                Text("Please check your internet connection and try again."),
            actions: <Widget>[
              TextButton(
                  child: Text("RETRY"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    _checkInternetConnectionAndNavigate();
                  })
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _checkInternetConnectionAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
