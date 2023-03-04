import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoadScreen extends StatefulWidget {
  const LoadScreen({super.key});

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> {
  bool isLoggedIn = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getIsLoggedIn();
  }

  Widget build(BuildContext context) {
    // wait for 3 seconds and then navigate to home screen
    Future.delayed(const Duration(seconds: 3), () {
      if (isLoggedIn) {
        Navigator.pushNamed(context, '/home');
      } else {
        Navigator.pushNamed(context, '/login');
      }
    });
    // return a circular progress indicator
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Future<void> getIsLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  }
}
