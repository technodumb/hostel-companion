import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hostel_companion/model/username_model.dart';

class UsernameData {
  FirebaseFirestore db = FirebaseFirestore.instance;
  Map<String, dynamic> statusList = {};

  Future<String> getUserStatus(String username) async {
    return await db.collection('usernames').doc('lists').get().then((value) {
      print(value.data());
      statusList = value.data()!;
      if (statusList != {}) {
        if (statusList['resetted']!.contains(username)) {
          print('resetted');
          if (statusList['admin']!.contains(username)) {
            return 'admin';
          }
          return 'resetted';
        } else if (statusList['withmail']!.contains(username)) {
          print('withmail');
          return 'with-mail';
        } else if (statusList['all']!.contains(username)) {
          print('all');
          return 'in-list';
        } else {
          // print('invalid');
          return 'not-in-list';
        }
      }
      return 'some-error';
    });
  }

  Future<String> getEmailFromUsername(String username) async {
    UsernameModel usernameModel;
    return await db.collection('usernames').doc(username).get().then((value) {
      usernameModel =
          UsernameModel.fromMap(value.data() as Map<String, dynamic>);
      return usernameModel.email;
    });
  }

  Future<void> addToResetted(String username) async {
    statusList['resetted']!.add(username);
    await db.collection('usernames').doc('lists').update(statusList);
    await db.collection('usernames').doc(username).update({
      'didReset': true,
    });
  }

  Future<void> addToWithMail(String username, String email, String uid) async {
    try {
      statusList['withmail']!.add(username);
      await db.collection('usernames').doc('lists').update(statusList);
      await db.collection('usernames').doc(username).set(
            UsernameModel(
                    didReset: false, email: email, username: username, uid: uid)
                .toMap(),
          );
      await db.collection('users').doc(username).update({
        'email': email,
      });
    } catch (e) {
      print(e);
    }
  }

  // Future<Tuple2<UsernameModel, String>> getEmailFromUsername(
  //     String username) async {
  //   print('checking ');
  //   try {
  //     return await db
  //         .collection('usernames')
  //         .doc(username)
  //         .get()
  //         .catchError((e) {
  //       print("catch error");
  //       throw UsernameModelException(
  //           'username-not-found', 'Username not found');
  //     }).then(
  //       (value) {
  //         print("then why");
  //         Map<String, dynamic> valueData = value.data() ?? {};
  //         return Tuple2(UsernameModel.fromMap((valueData)), '');
  //       },
  //     );
  //   } on UsernameModelException catch (e) {
  //     print(e.message);

  //     return Tuple2(
  //         UsernameModel(username: '', email: '', didReset: false), e.code);
  //   }
  //   // print("ok wtf!");
  //   // return UsernameModel(username: '', email: '', didReset: false);
  // }
}
