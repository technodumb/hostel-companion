import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_companion/model/user_model.dart';

class UserData {
  final db = FirebaseFirestore.instance;

  Future<UserModel> getUserData(String username) async {
    try {
      return await db.collection('users').doc(username).get().then(
          (value) => UserModel.fromMap(value.data() as Map<String, dynamic>));
    } catch (e) {
      print("GetUserData: $e");
    }
    // return null;
    return UserModel.empty();
  }

  Future<void> putUserData(UserModel user) async {
    try {
      db.collection('users').doc(user.id).update(
        {
          'name': user.name,
          'email': user.email,
          'id': user.id,
          'noFoodDates': user.noFoodDates,
        },
      );
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

  // Future<void> putMailToID(String id, String mail) async {
  //   try {
  //     await db.collection('usernames').doc(id).set({
  //       'email': mail,
  //     });
  //     await db.collection('users').doc(id).update(
  //       {
  //         'email': mail,
  //       },
  //     );
  //   } catch (e) {
  //     print(e);
  //   }
  // }
}
