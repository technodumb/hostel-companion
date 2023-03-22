import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:hostel_companion/components/drawer.dart';
import 'package:hostel_companion/components/min_text_button.dart';
import 'package:hostel_companion/controllers/provider/firebase_firestore_provider.dart';
import 'package:hostel_companion/model/user_model.dart';
import 'package:provider/provider.dart';

import 'HomeScreenTabs/tab_content.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    FirebaseFirestoreProvider firebaseFirestoreProvider =
        Provider.of<FirebaseFirestoreProvider>(context);
    UserModel userModel = firebaseFirestoreProvider.userModel;
    // Barcode barcode = Barcode.code128();
    // barcode.toSvg(userModel.id, width: 750, height: 150);

    return Scaffold(
      key: _scaffoldKey,
      drawer: const CustomDrawer(),
      body: SafeArea(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 300,
                  width: double.infinity,
                  // add a gradient to the container
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF0066FF),
                        Color(0xFF00D6FF),
                      ],
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Welcome back,',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontFamily: 'Inter',
                          ),
                        ),
                        Text(
                          // 'Wolfgang Amadeus Mozart',
                          userModel.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontFamily: 'Inter'),
                        ),
                        Text(
                          userModel.id,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontFamily: 'Inter'),
                        ),
                        Container(
                          height: width * 0.2,
                          width: width * 0.9,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: BarcodeWidget(
                            barcode: Barcode.code128(),
                            data: userModel.id,
                            drawText: false,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: MinTextButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: 24,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                  ),
                ),
              ],
            ),
            const Expanded(child: TabContent(isDaily: true)),
          ],
        ),
      ),
    );
  }
}
