// firebase authentication

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:tuple/tuple.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FlutterAuth {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // sign in with email and password
  // return the user if successful
  // return error code if not successful instead of just printing
  Future<Tuple2<User?, String>> signIn(String email, String password) async {
    User? user;
    String errorCode = '';
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-email') errorCode = e.code;
    }
    return Tuple2(user, errorCode);
  }

  // void checkUserStatus() {
  //   _auth
  // }

  Future<Tuple2<User?, String>> signUp(String email, String password) async {
    User? user;
    String errorCode = '';
    try {
      print(email);
      print(password);
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      errorCode = e.code;
      print(errorCode);
    }
    return Tuple2(user, errorCode);
  }

  Future<String> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print(e.code);
      return e.code;
    }
    return '';
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<bool> isSignedIn() async {
    final currentUser = _auth.currentUser;
    return currentUser != null;
  }

  Future<String?> getUser() async {
    return _auth.currentUser?.email;
  }

  static Future<void> addToSecureStorage(
      String username, String password) async {
    const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true));
    await storage.write(key: 'username', value: username);
    await storage.write(key: 'password', value: password);
    await storage.write(key: 'isSignedIn', value: 'true');
  }

  static void removeFromSecureStorage() {
    const storage = FlutterSecureStorage(
        aOptions: AndroidOptions(encryptedSharedPreferences: true));
    storage.delete(key: 'username');
    storage.delete(key: 'password');
    storage.write(key: 'isSignedIn', value: 'false');
  }
}
