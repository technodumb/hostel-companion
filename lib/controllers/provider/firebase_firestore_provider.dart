import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_companion/controllers/firebase/admin_data.dart';
import 'package:hostel_companion/controllers/firebase/auth.dart';
import 'package:hostel_companion/controllers/firebase/user_data.dart';
import 'package:hostel_companion/controllers/firebase/usernames_data.dart';
import 'package:hostel_companion/controllers/provider/food_data.dart';
import 'package:hostel_companion/controllers/provider/toggle_controller.dart';
import 'package:hostel_companion/model/user_model.dart';
import 'package:tuple/tuple.dart';

class FirebaseFirestoreProvider extends ChangeNotifier {
  UsernameData usernameData = UsernameData();
  UserData userData = UserData();
  AdminData adminData = AdminData();
  FlutterAuth firebaseAuth = FlutterAuth();
  UserModel _userModel = UserModel.empty();
  User? _currentUser = FirebaseAuth.instance.currentUser;
  String _errorcode = '';
  String _email = '';
  String _currentUsername = '';
  List<DateTime> _dateRange = [];
  bool _isAdmin = false;

  bool get isAdmin => _isAdmin;
  User? get currentUser => _currentUser;
  String get errorcode => _errorcode;
  String get currentUsername => _currentUsername;
  String get currentEmail => _email;
  UserModel get userModel => _userModel;
  List<DateTime> get dateRange => _dateRange;

  Future<void> checkUserAuth(String username, String password) async {
    // String email;
    String status = await usernameData.getUserStatus(username);
    _currentUsername = username;
    print(status);
    if (status == 'resetted' || status == 'with-mail' || status == 'admin') {
      _email = await usernameData.getEmailFromUsername(username);
      Tuple2<User?, String> userAndError =
          await firebaseAuth.signIn(_email, password);
      _currentUser = userAndError.item1;
      _errorcode = userAndError.item2;
      if (_errorcode == '' && _currentUser != null) {
        if (status == 'admin') {
          _isAdmin = true;
          await getCurrentUserData();
          print("usermodel-date: ${_userModel.name}");
        } else if (status == 'resetted') {
          // _userModel = await userData.getUserData(username);
          await getCurrentUserData();
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
    FlutterAuth.removeFromSecureStorage();
    notifyListeners();
  }

  Future<void> getCurrentUserData() async {
    _userModel = await userData.getUserData(_currentUsername);
    notifyListeners();
  }

  void setRange(
      {required OnlyDate start, required OnlyDate end, bool? remove}) {
    // get date range between start and end and store it in _userModel.noFoodDates
    _dateRange = List.generate(end.difference(start).inDays + 1,
        (index) => DateTime(start.year, start.month, start.day + index));
    remove ?? false
        ? _userModel.noFoodDates
            .removeWhere((element) => dateRange.contains(element))
        : _userModel.noFoodDates.addAll(dateRange);
    // _userModel.noFoodDates
    _userModel.noFoodDates = _userModel.noFoodDates.toSet().toList();
    print(_userModel.noFoodDates);
    notifyListeners();
  }

  void refreshFoodDates() {
    userModel.noFoodDates = userModel.noFoodDates
        .where((date) => date.isAfter(OnlyDate.now()))
        .toList();
  }

  void initialToggle(ToggleController toggleData, FoodData foodData) {
    foodData.date = DateTime.now().hour < 21
        ? OnlyDate.tomorrow()
        : OnlyDate.dayAfterTomorrow();
    if (userModel.noFoodDates.contains(foodData.date)) {
      toggleData.toggleIsFood(value: false);
      foodData.toggleIsFood(value: false);
    } else {
      toggleData.toggleIsFood(value: true);
      foodData.toggleIsFood(value: true);
    }
  }
}
