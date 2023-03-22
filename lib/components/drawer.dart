import 'package:flutter/material.dart';
import 'package:hostel_companion/components/min_text_button.dart';
import 'package:hostel_companion/controllers/firebase/admin_data.dart';
import 'package:hostel_companion/controllers/firebase/user_data.dart';
import 'package:hostel_companion/controllers/provider/firebase_firestore_provider.dart';
import 'package:hostel_companion/controllers/provider/toggle_controller.dart';
import 'package:hostel_companion/global.dart';
import 'package:hostel_companion/model/user_model.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestoreProvider firestoreProvider =
        Provider.of<FirebaseFirestoreProvider>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        width: width * 0.8,
        child: Column(
          children: [
            Container(
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF5200FF),
                    Color(0x7F441B9C),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(15),
                    child: Text(
                      'MACE Men\'s Hostel Companion App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const Divider(
                    color: Colors.white,
                    thickness: 1,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Name: ${firestoreProvider.userModel.name}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            'College ID: ${firestoreProvider.userModel.id}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            'Hostel: ${hostelName[firestoreProvider.userModel.hostel]}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            'Room No: ${firestoreProvider.userModel.roomNo}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (firestoreProvider.isAdmin)
              DrawerButtons(
                text: 'Admin Panel',
                icon: Icons.admin_panel_settings,
                onPressed: () => Navigator.of(context).pushNamed('/admin'),
              ),
            DrawerButtons(
              text: 'Post Complaints',
              icon: Icons.note_add,
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => PostComplaintDialog(
                        userModel: firestoreProvider.userModel,
                      )),
            ),
            DrawerButtons(
                text: 'Change Password',
                icon: Icons.lock_reset,
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) => ChangePasswordDialog(
                          resetPassword:
                              firestoreProvider.firebaseAuth.resetPassword,
                          email: firestoreProvider.userModel.email,
                        ))),
            DrawerButtons(
              text: 'Logout',
              icon: Icons.logout,
              logout: true,
              onPressed: () => showDialog(
                context: context,
                builder: (context) => LogoutDialog(
                  signOut: firestoreProvider.signOut,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerButtons extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final IconData icon;
  final bool logout;
  const DrawerButtons(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPressed,
      this.logout = false});

  @override
  Widget build(BuildContext context) {
    return MinTextButton(
      onPressed: onPressed,
      child: Container(
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Icon(
              icon,
              size: 24,
              color: logout ? Colors.red : Colors.black,
            ),
            const SizedBox(width: 20),
            Text(
              text,
              style: TextStyle(
                color: logout ? Colors.red : Colors.black,
                fontSize: 15,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PostComplaintDialog extends StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController complaintController = TextEditingController();
  final UserModel userModel;
  PostComplaintDialog({super.key, required this.userModel});

  @override
  Widget build(BuildContext context) {
    AdminData adminData = AdminData();
    ToggleController toggleController = Provider.of<ToggleController>(context);

    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          // alignment: Alignment.center,
          // width: 300,
          width: width * 0.8,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Post Complaints',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),
              const SizedBox(height: 15),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Title: '),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        isDense: true,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.start,
                      textAlignVertical: TextAlignVertical.top,
                      controller: titleController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Write your complaint here',
                  contentPadding: EdgeInsets.all(10),
                  isDense: true,
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                ),
                textAlign: TextAlign.start,
                textAlignVertical: TextAlignVertical.top,
                maxLines: null,
                controller: complaintController,
              ),
              GestureDetector(
                onTap: () {
                  toggleController.toggleIsAnonymous();
                },
                child: Row(
                  children: [
                    // Checkbox for anonymous
                    Checkbox(
                      value: toggleController.isAnonymous,
                      onChanged: (value) {
                        toggleController.toggleIsAnonymous();
                      },
                    ),
                    const Text('Post Anonymously'),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  TextButton(
                    onPressed: () {
                      if (titleController.text.isNotEmpty &&
                          complaintController.text.isNotEmpty) {
                        if (DateTime.now().difference(
                                toggleController.lastComplaintDate) >
                            const Duration(minutes: 5)) {
                          adminData.postComplaint(
                            title: titleController.text,
                            complaint: complaintController.text,
                            userdata: toggleController.isAnonymous
                                ? 'Anonymous'
                                : "${userModel.name}?${userModel.hostel}?${userModel.roomNo}",
                          );
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Complaint posted successfully'),
                            ),
                          );
                          toggleController.setLastComplaintDate();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please wait 5 minutes before posting another complaint'),
                            ),
                          );
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Please fill all the fields'),
                          ),
                        );
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                    child: const Text('Post',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangePasswordDialog extends StatelessWidget {
  final Function(String) resetPassword;
  final String email;
  const ChangePasswordDialog(
      {super.key, required this.resetPassword, required this.email});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Change Password'),
      content: const Text('Are you sure you want to change your password?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            resetPassword(email).then((value) {
              Navigator.of(context).pop();
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Password Reset'),
                  content: const Text(
                      'A password reset link has been sent to your email'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Ok'))
                  ],
                ),
              );
            });
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}

class LogoutDialog extends StatelessWidget {
  final Function() signOut;
  const LogoutDialog({super.key, required this.signOut});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            signOut();
            Navigator.pushNamedAndRemoveUntil(
                context, '/login', (route) => false);
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
