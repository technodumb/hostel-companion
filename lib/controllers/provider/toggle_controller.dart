import 'package:flutter/material.dart';

import 'food_data.dart';

class ToggleController extends ChangeNotifier {
  bool _isDaily = true;
  bool get isDaily => _isDaily;
  set setIsDaily(bool value) {
    _isDaily = value;
    notifyListeners();
  }

  bool _isFood = true;
  bool get isFood => _isFood;
  void toggleIsFood({bool? value}) {
    _isFood = value ?? !isFood;
    notifyListeners();
  }

  bool _isAnonymous = false;
  bool get isAnonymous => _isAnonymous;
  void toggleIsAnonymous({bool? value}) {
    _isAnonymous = value ?? !isAnonymous;
    notifyListeners();
  }

  DateTime _lastComplaintDate = OnlyDate.noneDate();
  DateTime get lastComplaintDate => _lastComplaintDate;
  void setLastComplaintDate() {
    _lastComplaintDate = DateTime.now();
    notifyListeners();
  }
}
