import 'package:hostel_companion/screens/LoadScreen/load_screen.dart';
import 'screens/AdminScreen/admin_screen.dart';
import 'screens/HomeScreen/home_screen.dart';
import 'screens/LoginScreen/first_time_login.dart';
import 'screens/LoginScreen/login_screen.dart';

var routes = {
  '/load': (context) => LoadScreen(),
  '/home': (context) => HomeScreen(),
  '/login': (context) => LoginScreen(),
  '/firstlogin': (context) => FirstTimeLoginScreen(),
  '/admin': (context) => AdminScreen(),
};
