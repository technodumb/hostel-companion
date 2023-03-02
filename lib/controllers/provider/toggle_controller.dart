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
  void toggleIsFood() {
    _isFood = !isFood;
    notifyListeners();
  }

  bool _isUnchanged = true;
  get isUnchanged => _isUnchanged;
  void toggleIsUnchanged() {
    _isUnchanged = !isUnchanged;
    notifyListeners();
  }
}
