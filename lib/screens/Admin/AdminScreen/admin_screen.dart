import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:hostel_companion/components/min_text_button.dart';
import 'package:hostel_companion/controllers/provider/admin_provider.dart';
import 'package:hostel_companion/controllers/provider/firebase_firestore_provider.dart';
import 'package:hostel_companion/controllers/provider/food_data.dart';
import 'package:intl/intl.dart';
import 'package:mat_month_picker_dialog/mat_month_picker_dialog.dart';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestoreProvider firebaseFirestoreProvider =
        Provider.of<FirebaseFirestoreProvider>(context);
    AdminProvider adminProvider = Provider.of<AdminProvider>(context);
    List allStudentsDynamic =
        firebaseFirestoreProvider.usernameData.statusList['all'];
    List<String> allStudents = [];
    for (var i in allStudentsDynamic) {
      allStudents.add(i.toString());
    }
    print(allStudents.length);
    // print(dailyNoFoodList);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
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
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("Almighty Admin, ",
                            style:
                                TextStyle(color: Colors.white, fontSize: 30)),
                        const SizedBox(
                          height: 15,
                        ),
                        Text("Sir ${firebaseFirestoreProvider.userModel.name}",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20)),
                        const SizedBox(height: 15),
                        MinTextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
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
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        children: [
                          const Text(
                            'Daily Food Stats',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
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
                                  await adminProvider.getDailyNoFoodList();
                                },
                                child: Container(
                                  height: 40,
                                  width: width * 0.65,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
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
                                        style: const TextStyle(fontSize: 20),
                                      ),
                                      const Icon(
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
                                    color: const Color(0xFF00372A),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text(
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
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AdminCountDownloadButton(
                                title: 'Total:',
                                studList: allStudents,
                                widthRatio: 0.18,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => ShowNameList(
                                          title: 'Total List',
                                          studentList: allStudents
                                              .map((e) =>
                                                  e +
                                                  ' -> ${adminProvider.dailyNoFoodList.contains(e) ? 'No Food' : 'Food'}')
                                              .toList()));
                                },
                                colors: [
                                  const Color(0xFF8DB046),
                                  const Color(0xFF63851F),
                                ],
                              ),
                              AdminCountDownloadButton(
                                title: 'Food:',
                                studList: allStudents
                                    .where((element) => !adminProvider
                                        .dailyNoFoodList
                                        .contains(element))
                                    .toList(),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => ShowNameList(
                                        title: 'Food List',
                                        studentList: allStudents
                                            .where((element) => !adminProvider
                                                .dailyNoFoodList
                                                .contains(element))
                                            .toList()),
                                  );
                                },
                                colors: [
                                  const Color(0xFF806491),
                                  const Color(0xFF713198),
                                ],
                              ),
                              AdminCountDownloadButton(
                                title: 'No Food:',
                                studList: adminProvider.dailyNoFoodList,
                                onPressed: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) => ShowNameList(
                                            title: 'No Food',
                                            studentList:
                                                adminProvider.dailyNoFoodList,
                                          ));
                                  print('buttton pressed');
                                },
                                colors: [
                                  const Color(0xFFFE3533),
                                  const Color(0xFF7E1717),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20, horizontal: 15),
                    child: Column(
                      children: [
                        const Text(
                          'Monthly Food Stats',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(
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
                                padding: const EdgeInsets.symmetric(
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
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const Icon(
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
                                  color: const Color(0xFF00372A),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Text(
                                  'Reset',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                            const Icon(
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 15),
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
  final List<String> studList;
  final Function() onPressed;
  final List<Color> colors;
  const AdminCountDownloadButton({
    super.key,
    this.widthRatio = 0.33,
    required this.title,
    required this.studList,
    required this.onPressed,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    List<String> noFoodList = context.read<AdminProvider>().dailyNoFoodList;
    DateTime currentDate = context.read<AdminProvider>().dailyDate;
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            Text(
              studList.length.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 25,
              ),
            ),
            MinTextButton(
                onPressed: () async {
                  String location = '/storage/emulated/0/Download/Hostel';
                  // Directory directory = Directory(location);

                  // final String path = '$directory/Download';
                  Directory(location).createSync(recursive: true);
                  final String fileName = '$currentDate $title.csv';
                  // csv generate from the list
                  final String csv = const ListToCsvConverter().convert([
                        [
                          'Sl No',
                          'ID',
                          'Food Stat',
                        ],
                      ] +
                      List.generate(
                          studList.length,
                          (index) => [
                                '${index + 1}',
                                studList[index],
                                (!noFoodList.contains(studList[index]))
                                    .toString(),
                              ]));
                  // write the csv file
                  final File file = File('$location/$fileName');
                  await file.writeAsString(csv);
                  // print('download clicked');
                  // open file
                  OpenFilex.open('$location/$fileName');
                },
                child: const Icon(
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

class ShowNameList extends StatelessWidget {
  final String title;
  final List<String> studentList;
  ShowNameList({super.key, required this.title, required this.studentList});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        // height: 200,
        // height: 500,
        // width: 100,
        // margin: EdgeInsets.symmetric(vertical: 100),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [
            Color(0xFF806491),
            Color(0xFF9258B6),
          ]),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(20),
              width: width * 0.8,
              height: width * 1,
              decoration: BoxDecoration(
                  color: const Color(0x7F000000),
                  borderRadius: BorderRadius.circular(20)),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      studentList.length,
                      (index) => Text(
                            '${index + 1}. ${studentList[index]}',
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          )),
                  // children: [
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  //   Text(
                  //     '1.',
                  //     style: TextStyle(color: Colors.white, fontSize: 18),
                  //   ),
                  // ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
