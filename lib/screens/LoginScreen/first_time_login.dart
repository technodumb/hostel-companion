import 'package:flutter/material.dart';
import 'package:hostel_companion/controllers/provider/firebase_firestore_provider.dart';
import 'package:hostel_companion/global.dart';
import 'package:provider/provider.dart';

class FirstTimeLoginScreen extends StatelessWidget {
  FirstTimeLoginScreen({super.key});
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    FirebaseFirestoreProvider firebaseFirestoreProvider =
        Provider.of<FirebaseFirestoreProvider>(context);

    void showEmailPasswordResetDialog() {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Reset Password'),
          content: Text(
              'A password reset link has been sent to: \n${_emailController.text}\nLogin after resetting your password.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/login', (route) => false);
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                height: height * 0.4,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF3D00A0),
                      Color(0x7F001AA0),
                    ],
                  ),
                ),
                child: const Text(
                  "MACE Men's Hostel Companion App",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    // fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(30.0),
                child: Text(
                  'First Time Login?',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 24,
                  ),
                ),
              ),
              const Text(
                'Seems like this is your first time logging in.\nEnter your college mail ID to reset your password.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 30),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
                    SizedBox(
                      width: width * 0.9,
                      // height: 50,
                      child: TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: 'College Email ID',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 20),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your college email ID';
                          }
                          // format for regualr expression
                          // ignore: prefer_interpolation_to_compose_strings
                          if (!RegExp(r'^[a-z0-9]+@mace.ac.in$')
                              .hasMatch(value)) {
                            return 'Please enter a valid college email ID';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                    TextButton(
                      style: TextButton.styleFrom(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size.zero,
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        await firebaseFirestoreProvider.firstTimeSignUp(
                            _emailController.text,
                            firebaseFirestoreProvider.currentUsername);
                        String errorcode = firebaseFirestoreProvider.errorcode;
                        if (errorcode != '') {
                          showSnackBar(context: context, message: errorcode);
                        } else {
                          showEmailPasswordResetDialog();
                        }
                      },
                      child: Container(
                        height: 50,
                        width: 200,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [
                              Color(0xFFFF0000),
                              Color(0x7FFF0000),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
