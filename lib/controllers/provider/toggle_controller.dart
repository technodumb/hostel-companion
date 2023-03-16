import 'package:flutter/material.dart';

class ToggleController extends ChangeNotifier {
  bool _isDaily = true;
  get isDaily => _isDaily;
  set setIsDaily(bool value) {
    _isDaily = value;
    notifyListeners();
  }

  bool _isFood = true;
  get isFood => _isFood;
  void toggleIsFood({bool? value}) {
    _isFood = value ?? !isFood;
    notifyListeners();
  }
}
