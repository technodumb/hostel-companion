import 'package:flutter/material.dart';
import 'package:hostel_companion/components/min_text_button.dart';
import 'package:hostel_companion/controllers/firebase/admin_data.dart';
import 'package:hostel_companion/controllers/provider/admin_provider.dart';
import 'package:hostel_companion/global.dart';
import 'package:provider/provider.dart';

class ComplaintScreen extends StatelessWidget {
  const ComplaintScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AdminProvider adminProvider = Provider.of<AdminProvider>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black,
                Color(0xE6000853),
              ],
            ),
          ),
          child: Column(
            children: [
              AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: const Text(
                  'Complaints',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                leading: MinTextButton(
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context)),
                centerTitle: true,
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: ListView(
                  // shrinkWrap: true,
                  children: adminProvider.adminData.complaintIDs.map(
                    (int complaintID) {
                      print(complaintID);
                      ComplaintData complaint =
                          adminProvider.adminData.complaints[complaintID] ??
                              ComplaintData.empty();
                      List<String> userDataList = complaint.userdata.split('?');
                      String name = userDataList[0];
                      String hostel = userDataList[1];
                      String room = userDataList[2];
                      return Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xE6000853),
                        ),
                        margin: const EdgeInsets.all(10),
                        // padding: EdgeInsets.all(10),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: ListTile(
                            title: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  complaint.title,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                Text(
                                  name,
                                  style: const TextStyle(
                                      color: Colors.orange, fontSize: 14),
                                ),
                                if (name != 'Anonymous')
                                  Text(
                                    '${hostelName[hostel]} - $room',
                                    style: const TextStyle(
                                        color: Colors.orange, fontSize: 14),
                                  ),
                              ],
                            ),
                            subtitle: Text(
                              complaint.complaint,
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 14),
                            ),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                  // children: [
                  //   Container(
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10),
                  //       color: Color(0xE6000853),
                  //     ),
                  //     margin: EdgeInsets.all(10),
                  //     padding: EdgeInsets.all(10),
                  //     child: MinTextButton(
                  //       onPressed: () {
                  //         AdminData().getComplaint();
                  //       },
                  //       child: ListTile(
                  //         title: Column(
                  //           crossAxisAlignment: CrossAxisAlignment.start,
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: const [
                  //             Text(
                  //               '',
                  //               style: TextStyle(
                  //                   color: Colors.white, fontSize: 16),
                  //             ),
                  //             Text(
                  //               'Name',
                  //               style: TextStyle(
                  //                   color: Colors.orange, fontSize: 14),
                  //             ),
                  //             Text(
                  //               'L205 - Diamond Jubilee Hostel',
                  //               style: TextStyle(
                  //                   color: Colors.orange, fontSize: 14),
                  //             ),
                  //           ],
                  //         ),
                  //         subtitle: const Text(
                  //           'Boring people are boring... I am not boring. I am interesting.',
                  //           style: TextStyle(
                  //               color: Colors.white, fontSize: 14),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
