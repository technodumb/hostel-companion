import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_companion/controllers/firebase/auth.dart';
import 'package:hostel_companion/controllers/firebase/user_data.dart';
import 'package:hostel_companion/controllers/firebase/usernames_data.dart';
import 'package:hostel_companion/model/user_model.dart';
import 'package:tuple/tuple.dart';

class FirebaseFirestoreProvider extends ChangeNotifier {
  UsernameData usernameData = UsernameData();
  UserData userData = UserData();
  FlutterAuth firebaseAuth = FlutterAuth();
  UserModel _userModel = UserModel.empty();
  User? _currentUser = FirebaseAuth.instance.currentUser;
  String _errorcode = '';
  String _email = '';
  String _currentUsername = '';

  User? get currentUser => _currentUser;
  String get errorcode => _errorcode;
  String get currentUsername => _currentUsername;
  String get currentEmail => _email;
  UserModel get userModel => _userModel;

  Future<void> checkUserAuth(String username, String password) async {
    // String email;
    String status = await usernameData.getUserStatus(username);
    _currentUsername = username;
    print(status);
    if (status == 'resetted' || status == 'with-mail') {
      _email = await usernameData.getEmailFromUsername(username);
      Tuple2<User?, String> userAndError =
          await firebaseAuth.signIn(_email, password);
      _currentUser = userAndError.item1;
      _errorcode = userAndError.item2;
      if (_errorcode == '' && _currentUser != null) {
        if (status == 'resetted') {
          _userModel = await userData.getUserData(username);
          print("usermodel-date: ${_userModel.name}");
        } else if (status == 'with-mail') {
          if (username != password) {
            await usernameData.addToResetted(username);
            _userModel = await userData.getUserData(username);
            _errorcode = '';
          } else {
            _errorcode = 'not-resetted';
            _currentUser = null;
          }
        }
      }
    } else if (status == 'in-list') {
      _currentUser = null;
      if (username != password) {
        _errorcode = 'wrong-password';
      } else {
        _errorcode = 'first-login';
        print(_errorcode);
      }
    } else if (status == 'not-in-list') {
      _currentUser = null;
      _errorcode = 'not-in-list';
    } else if (status == 'some-error') {
      _currentUser = null;
      _errorcode = 'some-error';
    }

    notifyListeners();
  }

  Future<void> firstTimeSignUp(String email, String username) async {
    Tuple2<User?, String> val = await firebaseAuth.signUp(email, username);
    _currentUser = val.item1;
    _errorcode = val.item2;
    if (_currentUser != null && _errorcode == '') {
      await usernameData.addToWithMail(username, email, _currentUser!.uid);
      _errorcode = await firebaseAuth.resetPassword(email);
      // firebaseDataGet.putMailToID(username, email);
    }
    notifyListeners();
  }

  // void resetPasswordSend(String email) {}

  void signOut() {
    firebaseAuth.signOut();
    _currentUser = null;
    _errorcode = '';
    _email = '';
    _currentUsername = '';
    _userModel = UserModel.empty();
    notifyListeners();
  }

  Future<UserModel> getCurrentUserData() async {
    return await userData.getUserData(_currentUsername);
  }
}
