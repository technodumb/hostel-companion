import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_companion/controllers/firebase/auth.dart';
import 'package:hostel_companion/controllers/firebase/user_data.dart';
import 'package:hostel_companion/controllers/firebase/usernames_data.dart';
import 'package:hostel_companion/model/username_model.dart';
import 'package:tuple/tuple.dart';

class FirebaseFirestoreProvider extends ChangeNotifier {
  UsernameData usernameData = UsernameData();
  FirebaseDataGet firebaseDataGet = FirebaseDataGet();
  FlutterAuth firebaseAuth = FlutterAuth();
  User? _currentUser = FirebaseAuth.instance.currentUser;
  String _errorcode = '';

  User? get currentUser => _currentUser;
  String get errorcode => _errorcode;

  Future<void> checkUserAuth(String username, String password) async {
    UsernameModel usernameInfo =
        await usernameData.getEmailFromUsername(username);
    // print(email);
    // print(password);
    // firebaseDataGet.checkUserAuth(email, password);
    if (usernameInfo.email != '') {
      if (usernameInfo.didReset == true) {
        Tuple2<User?, String> val =
            await firebaseAuth.signIn(usernameInfo.email, password);
        _currentUser = val.item1;
        _errorcode = val.item2;
      } else {
        _errorcode = 'notReset';
      }
    } else {
      _errorcode = 'notRegistered';
    }
    notifyListeners();
  }
}
