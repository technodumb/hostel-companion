import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_companion/model/username_model.dart';

class UsernameData {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<UsernameModel> getEmailFromUsername(String username) async {
    await db.collection('usernames').doc(username).get().then(
      (value) {
        return UsernameModel.fromMap(value.data() as Map<String, dynamic>);
      },
    );
    return UsernameModel(username: '', email: '', didReset: false);
  }
}
