import 'package:flutter/material.dart';
import 'package:hostel_companion/components/min_text_button.dart';
import 'package:hostel_companion/controllers/provider/firebase_firestore_provider.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestoreProvider _firestoreProvider =
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
                  Padding(
                    padding: const EdgeInsets.all(15),
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
                  Divider(
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
                            'Name: ${_firestoreProvider.userModel.name}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            'College ID: ${_firestoreProvider.userModel.id}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            'Hostel: ${_firestoreProvider.userModel.hostel}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                          Text(
                            'Room No: ${_firestoreProvider.userModel.roomNo}',
                            style: TextStyle(
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
            DrawerButtons(
              text: 'Admin Panel',
              icon: Icon(Icons.admin_panel_settings),
              onPressed: () => Navigator.of(context).pushNamed('/admin'),
            ),
            DrawerButtons(
              text: 'Post Complaints',
              icon: Icon(Icons.note_add),
              onPressed: () => PostComplaintDialog(context),
            ),
            DrawerButtons(
                text: 'Check for updates',
                icon: Icon(Icons.update),
                onPressed: () => CheckForUpdatesDialog()),
            DrawerButtons(
                text: 'Change Password',
                icon: Icon(Icons.lock_reset),
                onPressed: () => ChangePasswordDialog()),
            DrawerButtons(
                text: 'Logout',
                icon: Icon(Icons.logout),
                onPressed: () => LogoutDialog()),
          ],
        ),
      ),
    );
  }
}

class DrawerButtons extends StatelessWidget {
  final String text;
  final Function() onPressed;
  final Icon icon;
  final Color color;
  const DrawerButtons(
      {super.key,
      required this.text,
      required this.icon,
      required this.onPressed,
      this.color = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: MinTextButton(
        onPressed: onPressed,
        child: Row(
          children: [
            icon,
            const SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
