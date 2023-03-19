import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_companion/controllers/provider/food_data.dart';
import 'package:hostel_companion/model/user_model.dart';

class AdminData {
  final db = FirebaseFirestore.instance;

  Future<void> addDateToAdmin(UserModel user, List<DateTime> dates) async {
    for (DateTime date in dates) {
      String dateString =
          "${date.year % 100}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}";
      await db.collection('admin').doc(dateString).set(
          {user.id: user.noFoodDates.contains(OnlyDate.fromDate(date))},
          SetOptions(merge: true));
    }
  }

  void postComplaint(
      {required String title,
      required String complaint,
      required String username}) {
    Random random = Random();
    db.collection('admin').doc('complaints').set({
      (DateTime.now().millisecondsSinceEpoch * 100 + random.nextInt(100))
          .toString(): {
        'title': title,
        'complaint': complaint,
        'username': username,
        'date': DateTime.now(),
      }
    }, SetOptions(merge: true));
  }
}
