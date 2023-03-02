import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _loginFormKey = GlobalKey<FormState>();

  TextEditingController get idController => _idController;
  TextEditingController get passwordController => _passwordController;
  GlobalKey<FormState> get loginFormKey => _loginFormKey;
}
