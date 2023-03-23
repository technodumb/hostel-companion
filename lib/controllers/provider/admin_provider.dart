import 'package:flutter/material.dart';
import 'package:hostel_companion/controllers/firebase/admin_data.dart';
import 'package:hostel_companion/controllers/provider/food_data.dart';

class AdminProvider extends ChangeNotifier {
  AdminData adminData = AdminData();

  DateTime _dailyDate =
      DateTime.now().hour < 21 ? OnlyDate.now() : OnlyDate.tomorrow();
  DateTime _monthlyDate =
      DateTime.now().hour < 21 ? OnlyDate.now() : OnlyDate.tomorrow();

  List<String> dailyNoFoodList = [];

  DateTime get dailyDate => _dailyDate;
  DateTime get monthlyDate => _monthlyDate;

  set dailyDate(DateTime date) {
    _dailyDate = date;
    notifyListeners();
  }

  set monthlyDate(DateTime date) {
    _monthlyDate = date;
    notifyListeners();
  }

  Future<void> getDailyNoFoodList() async {
    dailyNoFoodList = await adminData.getDateInfo(_dailyDate);
    notifyListeners();
  }

  void resetDailyDate() {
    _dailyDate =
        DateTime.now().hour < 21 ? OnlyDate.now() : OnlyDate.tomorrow();
    getDailyNoFoodList();
    notifyListeners();
  }

  void resetMonthlyDate() {
    _monthlyDate =
        DateTime.now().hour < 21 ? OnlyDate.now() : OnlyDate.tomorrow();
    notifyListeners();
  }
}
