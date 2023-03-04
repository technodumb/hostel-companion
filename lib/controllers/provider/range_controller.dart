import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:hostel_companion/controllers/provider/food_data.dart';

class RangeController extends ChangeNotifier {
  OnlyDate _start = OnlyDate.noneDate();
  OnlyDate _end = OnlyDate.noneDate();
  int noOfDays = 0;
  bool _drawerExpanded = true;

  OnlyDate get start => _start;
  OnlyDate get end => _end;
  bool get drawerExpand => _drawerExpanded;

  void setStart(DateTime newDate) {
    _start = OnlyDate.fromDate(newDate);
    notifyListeners();
  }

  void setEnd(DateTime newDate) {
    _end = OnlyDate.fromDate(newDate);
    noOfDays = _end.difference(_start).inDays + 1;
    notifyListeners();
  }

  void reset() {
    _start = OnlyDate.noneDate();
    _end = OnlyDate.noneDate();
    noOfDays = 0;
    notifyListeners();
  }

  void toggleDrawer({bool? value}) {
    _drawerExpanded = value ?? !_drawerExpanded;
    notifyListeners();
  }
}
