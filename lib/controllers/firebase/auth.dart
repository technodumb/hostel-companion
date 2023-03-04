// firebase authentication

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
      errorCode = e.code;
    }
    return Tuple2(user, errorCode);
  }

  Future<Tuple2<User?, String>> signUp(String email, String password) async {
    User? user;
    String errorCode = '';
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      errorCode = e.code;
    }
    return Tuple2(user, errorCode);
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
}
