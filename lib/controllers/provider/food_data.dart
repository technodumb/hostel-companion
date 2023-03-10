import 'package:flutter/material.dart';

class FoodData extends ChangeNotifier {
  DateTime date = (DateTime.now().hour < 21)
      ? OnlyDate.tomorrow()
      : OnlyDate.dayAfterTomorrow();
  bool _isFood = true;

  bool get isFood => _isFood;
  void toggleIsFood() {
    _isFood = !_isFood;
    notifyListeners();
  }

  void setDate(DateTime newDate) {
    date = OnlyDate(newDate.year, newDate.month, newDate.day);
    notifyListeners();
  }

  String submit() {
    if (_isFood) {
      print("Added ${date.toString()}");
    } else {
      print("Removed ${date.toString()}");
    }
    return 'Submitted';
  }
}

class OnlyDate extends DateTime {
  OnlyDate(int year, int month, int day) : super(year, month, day);

  factory OnlyDate.noneDate() {
    return OnlyDate(1, 1, 2002);
  }

  factory OnlyDate.tomorrow() {
    DateTime now = DateTime.now();
    return OnlyDate(now.year, now.month, now.day + 1);
  }

  factory OnlyDate.dayAfterTomorrow() {
    DateTime now = DateTime.now();
    return OnlyDate(now.year, now.month, now.day + 2);
  }

  factory OnlyDate.nextYear() {
    DateTime now = DateTime.now();
    return OnlyDate(now.year + 1, now.month, now.day);
  }

  factory OnlyDate.fromDate(DateTime datetime) {
    return OnlyDate(datetime.year, datetime.month, datetime.day);
  }
}
