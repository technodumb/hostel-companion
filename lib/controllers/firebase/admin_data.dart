import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_companion/controllers/provider/food_data.dart';
import 'package:hostel_companion/model/user_model.dart';

class ComplaintData {
  String title;
  String complaint;
  String userdata;
  DateTime date;
  ComplaintData({
    required this.title,
    required this.complaint,
    required this.userdata,
    required this.date,
  });

  factory ComplaintData.fromMap(Map<String, dynamic> map) {
    return ComplaintData(
        title: map['title'],
        complaint: map['complaint'],
        userdata: map['userdata'],
        date: map['date'].toDate());
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'complaint': complaint,
      'userdata': userdata,
      'date': date,
    };
  }

  // List<Map<String, ComplaintData>> toList() {}
  ComplaintData.empty()
      : title = '',
        complaint = '',
        userdata = '',
        date = DateTime.now();
}

class AdminData {
  final db = FirebaseFirestore.instance;
  List<int> complaintIDs = [];
  Map<int, ComplaintData> complaints = {};
  List<String> dailyNoFoodList = [];

  Future<void> addDateToAdmin(UserModel user, List<DateTime> dates) async {
    for (DateTime date in dates) {
      String dateString =
          "${date.year % 100}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
      await db.collection('admin').doc(dateString).set(
          {user.id: user.noFoodDates.contains(OnlyDate.fromDate(date))},
          SetOptions(merge: true));
    }
  }

  Future<List<String>> getDateInfo(DateTime date) async {
    String dateString =
        "${date.year % 100}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";

    try {
      return await db.collection('admin').doc(dateString).get().then((data) {
        print(data.data());
        List<String> noFoodList = [];
        if (data.data() != null) {
          for (String key in data.data()!.keys) {
            if (data.data()![key] == true) noFoodList.add(key);
            print(noFoodList);
          }
        }
        return noFoodList;
      });
    } catch (e) {
      print("getDateInfoError: $e");
      return [];
    }
  }

  Future<void> postComplaint(
      {required String title,
      required String complaint,
      required String userdata}) async {
    Random random = Random();
    await db.collection('admin').doc('complaints').set({
      (DateTime.now().millisecondsSinceEpoch * 100 + random.nextInt(100))
          .toString(): {
        'title': title,
        'complaint': complaint,
        'userdata': userdata,
        'date': DateTime.now(),
      }
    }, SetOptions(merge: true));
  }

  Future<void> getComplaint() async {
    await db.collection('admin').doc('complaints').get().then((value) {
      Map<String, dynamic> complaintList = value.data() as Map<String, dynamic>;
      // List<ComplaintData> complaints = [];
      print(value.data());
      for (String complaint in complaintList.keys) {
        complaints.addAll({
          int.parse(complaint): ComplaintData.fromMap(complaintList[complaint])
        });
        complaintIDs.add(int.parse(complaint));
      }
    });
    complaintIDs = complaintIDs.toSet().toList();
    complaintIDs.sort((a, b) => b.compareTo(a));
    print(complaintIDs);
  }
}
