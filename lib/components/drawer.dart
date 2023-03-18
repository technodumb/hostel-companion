import 'package:flutter/material.dart';
import 'package:hostel_companion/components/min_text_button.dart';
import 'package:hostel_companion/controllers/provider/firebase_firestore_provider.dart';
import 'package:hostel_companion/global.dart';
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
              onPressed: () => PostComplaintDialog(),
            ),
            DrawerButtons(
                text: 'Check for updates',
                icon: Icons.update,
                onPressed: () => CheckForUpdatesDialog()),
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
                    )),
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
  final TextEditingController complaintController = TextEditingController();
  PostComplaintDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Post Complaint'),
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Complaint',
                  border: OutlineInputBorder(),
                ),
                maxLines: 5,
                controller: complaintController,
              ),
              const SizedBox(height: 20),
              MinTextButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => const AlertDialog(
                            title: Text('Complaint Posted'),
                            content: Text(
                                'Your complaint has been posted successfully.'),
                          ));
                },
                child: const Text('Post'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CheckForUpdatesDialog extends StatelessWidget {
  const CheckForUpdatesDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
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
