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
      db.collection('users').doc(user.id).set(
        {
          'noFoodDates': user.noFoodDates,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> uploadUserData(List<UserModel> users) async {
    for (UserModel user in users) {
      try {
        db.collection('users').doc(user.id).set(
          {
            'hostel': user.hostel,
            'roomNo': user.roomNo,
            'name': user.name,
            'email': user.email,
            'id': user.id,
            'noFoodDates': user.noFoodDates,
          },
          SetOptions(merge: true),
        );
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> uploadUsernameData(List<String> usernames) async {
    try {
      db.collection('usernames').doc('lists').set(
        {
          'all': usernames,
        },
        SetOptions(merge: true),
      );
    } catch (e) {
      print(e);
    }
  }
}
