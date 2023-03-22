import 'package:flutter/material.dart';
import 'package:hostel_companion/components/min_text_button.dart';
import 'package:hostel_companion/controllers/provider/admin_provider.dart';
import 'package:hostel_companion/controllers/provider/firebase_firestore_provider.dart';
import 'package:hostel_companion/controllers/provider/food_data.dart';
import 'package:intl/intl.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestoreProvider firebaseFirestoreProvider =
        Provider.of<FirebaseFirestoreProvider>(context);
    AdminProvider adminProvider = Provider.of<AdminProvider>(context);
    List allStudents = firebaseFirestoreProvider.usernameData.statusList['all'];

    print(allStudents.length);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.black,
                Color(0xE6000853),
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Container(
                    // height: 200,
                    width: double.infinity,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Almighty Admin, ",
                            style:
                                TextStyle(color: Colors.white, fontSize: 30)),
                        SizedBox(
                          height: 15,
                        ),
                        Text("Sir ${firebaseFirestoreProvider.userModel.name}",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20)),
                        SizedBox(height: 15),
                        MinTextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              'Go Back to User Mode',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    // height: 200,
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            'Daily Food Stats',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async {
                                  adminProvider.dailyDate =
                                      await showDatePicker(
                                            context: context,
                                            initialDate:
                                                adminProvider.dailyDate,
                                            firstDate: DateTime(2023),
                                            lastDate: DateTime(2025),
                                          ) ??
                                          OnlyDate.now();
                                },
                                child: Container(
                                  height: 40,
                                  width: width * 0.65,
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        DateFormat('dd MMM yyyy, EEE')
                                            .format(adminProvider.dailyDate),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Icon(
                                        Icons.edit,
                                        color: Colors.black,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              MinTextButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                onPressed: () {
                                  adminProvider.resetDailyDate();
                                },
                                child: Container(
                                  height: 30,
                                  width: width * 0.2,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF00372A),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    'Today',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AdminCountDownloadButton(
                                title: 'Total:',
                                count: '${allStudents.length}',
                                widthRatio: 0.18,
                                onPressed: () {},
                                colors: [
                                  Color(0xFF8DB046),
                                  Color(0xFF63851F),
                                ],
                              ),
                              AdminCountDownloadButton(
                                title: 'Food:',
                                count: '400',
                                onPressed: () {},
                                colors: [
                                  Color(0xFF806491),
                                  Color(0xFF713198),
                                ],
                              ),
                              AdminCountDownloadButton(
                                title: 'No Food:',
                                count: '40',
                                onPressed: () {
                                  print('buttton pressed');
                                },
                                colors: [
                                  Color(0xFFFE3533),
                                  Color(0xFF7E1717),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                    child: Column(
                      children: [
                        Text(
                          'Monthly Food Stats',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            MinTextButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onPressed: () async {
                                var selected = await showMonthPicker(
                                    context: context,
                                    initialDate: adminProvider.monthlyDate,
                                    firstDate: DateTime(2023, 1),
                                    lastDate: DateTime.now());
                                if (selected != null) {
                                  adminProvider.monthlyDate = selected;
                                }
                              },
                              child: Container(
                                height: 40,
                                width: width * 0.6,
                                padding: EdgeInsets.symmetric(
                                  horizontal: 20,
                                ),
                                // alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      DateFormat('MMMM yyyy')
                                          .format(adminProvider.monthlyDate),
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    Icon(
                                      Icons.edit,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            MinTextButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              onPressed: () {
                                adminProvider.resetMonthlyDate();
                              },
                              child: Container(
                                height: 30,
                                width: width * 0.2,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: Color(0xFF00372A),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Reset',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.download,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: MinTextButton(
                      onPressed: () async {
                        await adminProvider.adminData.getComplaint();
                        Navigator.pushNamed(context, '/admin/complaints');
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        // margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            SizedBox(),
                            Text(
                              'View Complaints',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AdminCountDownloadButton extends StatelessWidget {
  final double widthRatio;
  final String title;
  final String count;
  final Function() onPressed;
  final List<Color> colors;
  AdminCountDownloadButton({
    super.key,
    this.widthRatio = 0.33,
    required this.title,
    required this.count,
    required this.onPressed,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return MinTextButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      onPressed: onPressed,
      child: Container(
        height: width * 0.33,
        width: width * widthRatio,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: colors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        // child:
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              count,
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            MinTextButton(
                onPressed: () {
                  print('download clicked');
                },
                child: Icon(
                  Icons.download,
                  color: Colors.white,
                  size: 30,
                ))
          ],
        ),
      ),
    );
  }

  void adminDownload() {}
}
