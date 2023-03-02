import 'package:flutter/material.dart';
import 'package:hostel_companion/model/user_model.dart';

class FoodData extends ChangeNotifier {
  DateTime date = OnlyDate.tomorrow();
  bool isFood = true;

  void toggleIsFood() {
    isFood = !isFood;
    notifyListeners();
  }

  void setDate(DateTime newDate) {
    date = OnlyDate(newDate.year, newDate.month, newDate.day);
    notifyListeners();
  }

  GlobalStorage globalStorage = GlobalStorage();
  String submit() {
    if (isFood) {
      globalStorage.user!.noFoodDates.add(date);
      print("Added ${date.toString()}");
    } else {
      globalStorage.user!.noFoodDates.remove(date);
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

  factory OnlyDate.nextYear() {
    DateTime now = DateTime.now();
    return OnlyDate(now.year + 1, now.month, now.day);
  }
}
