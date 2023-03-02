import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_companion/model/user_model.dart';

class FirebaseDataGet {
  final db = FirebaseFirestore.instance;

  Future<void> getUserData() async {
    try {
      await db.collection('users').doc('id').get().then((value) {
        print(value.data());
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> putUserData(UserModel user) async {
    try {
      db.collection('users').doc(user.id).set({
        'name': user.name,
        'email': user.email,
        'id': user.id,
        'noFoodDates': user.noFoodDates,
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Map<String, dynamic>?> getMailFromID(String id) async {
    try {
      await db.collection('user_mails').doc(id).get().then((value) {
        return value.data();
      });
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> putMailToID(String id, String mail) async {
    try {
      db.collection('user_mails').doc(id).set({
        'mail': mail,
        'reset': 'false',
      });
    } catch (e) {
      print(e);
    }
  }
}
