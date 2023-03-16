import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostel_companion/components/min_text_button.dart';
import 'package:hostel_companion/controllers/firebase/user_data.dart';
import 'package:hostel_companion/controllers/provider/firebase_firestore_provider.dart';
import 'package:hostel_companion/controllers/provider/food_data.dart';
import 'package:hostel_companion/controllers/provider/range_controller.dart';
import 'package:hostel_companion/screens/LoginScreen/first_time_login.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class RangeTabContent extends StatelessWidget {
  const RangeTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime tomorrow = OnlyDate.tomorrow();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    final RangeController rangeController =
        Provider.of<RangeController>(context);
    final FirebaseFirestoreProvider firestoreData =
        Provider.of<FirebaseFirestoreProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  TextButton(
                    onPressed: () {
                      rangeController.toggleDrawer();
                    },
                    style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        minimumSize: Size.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        splashFactory: NoSplash.splashFactory),
                    child: CalendarDrawer(
                      open: rangeController.drawerExpand,
                      rangeController: rangeController,
                    ),
                  ),
                  Visibility(
                    visible: rangeController.drawerExpand,
                    maintainSize: false,
                    child: Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                      height: width * 0.6,
                      width: double.infinity,
                      child: const CustomRangeCalendar(),
                    ),
                  ),
                  SizedBox(
                    height: 40,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (rangeController.start == OnlyDate.noneDate() ||
                            rangeController.end == OnlyDate.noneDate())
                          const Icon(Icons.info_outline),
                        const SizedBox(
                          width: 10,
                        ),
                        Text(
                          rangeController.start == OnlyDate.noneDate()
                              ? 'Select Start Date'
                              : rangeController.end == OnlyDate.noneDate()
                                  ? 'Select End Date'
                                  : 'Selected ${rangeController.noOfDays} days ',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Visibility(
              visible: rangeController.start != OnlyDate.noneDate() &&
                  rangeController.end != OnlyDate.noneDate(),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  MinTextButton(
                    onPressed: () {
                      firestoreData.setRange(
                        start: rangeController.start,
                        end: rangeController.end,
                        remove: true,
                      );
                      firestoreData.userData
                          .putUserData(firestoreData.userModel);
                      firestoreData.adminData.addDateToAdmin(
                          firestoreData.userModel, firestoreData.dateRange);
                      rangeController.reset();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: 50,
                      width: width * 0.4,
                      // padding: const EdgeInsets.symmetric(horizontal: 20),

                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF0000FF),
                            Color(0x7FBD00FF),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text('Food',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          )),
                    ),
                  ),
                  MinTextButton(
                    onPressed: () {
                      firestoreData.setRange(
                        start: rangeController.start,
                        end: rangeController.end,
                      );
                      firestoreData.userData
                          .putUserData(firestoreData.userModel);

                      firestoreData.adminData.addDateToAdmin(
                          firestoreData.userModel, firestoreData.dateRange);
                      rangeController.reset();
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      height: 50,
                      width: width * 0.4,
                      // padding: const EdgeInsets.symmetric(horizontal: 20),

                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFFFF0000),
                            Color(0x7FD93D3D),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text('No Food',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          )),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Visibility(
              maintainSize: false,
              visible: rangeController.start != OnlyDate.noneDate(),
              child: MinTextButton(
                onPressed: () {
                  rangeController.toggleDrawer(value: true);
                  rangeController.reset();
                },
                child: Container(
                  height: 40,
                  width: width * 0.45,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    // gradient: const LinearGradient(colors: [
                    //   // Color(0xFFFF0000),
                    //   // Color(0x7FFF0000),
                    // ]),
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }
}

class CalendarDrawer extends StatelessWidget {
  final bool open;
  final RangeController rangeController;
  const CalendarDrawer(
      {super.key, required this.open, required this.rangeController});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border: open ? const Border(bottom: BorderSide()) : null),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Set Date Range:',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
                Icon(
                  open ? Icons.expand_less : Icons.expand_more,
                  color: Colors.black,
                  size: 30,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Start Date: ${cleanDate(rangeController.start)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'End Date: ${cleanDate(rangeController.end)}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            // if (open)
            //   Container(
            //     decoration: BoxDecoration(
            //       color: Color(0xFFA6EFFF),
            //     ),
            //     height: height * 0.4,
            //     child: SizedBox(
            //       height: 400,
            //       width: 500,
            //       child: Expanded(
            //         child: TableCalendar(
            //           firstDay: tomorrow,
            //           focusedDay: tomorrow,
            //           lastDay: OnlyDate(
            //               tomorrow.year, tomorrow.month + 4, tomorrow.day),
            //           shouldFillViewport: true,
            //           currentDay: OnlyDate.noneDate(),
            //           onDaySelected: (selectedDay, focusedDay) {},
            //         ),
            //       ),
            //     ),
            //   ),
          ],
        ),
      ),
    );
  }

  String cleanDate(DateTime date) {
    if (date == OnlyDate.noneDate()) {
      return 'Not set';
    } else {
      return DateFormat('dd MMMM').format(date);
    }
  }
}

class CustomRangeCalendar extends StatelessWidget {
  const CustomRangeCalendar({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime tomorrow = OnlyDate.tomorrow();
    DateTime dayAfterTomorrow = OnlyDate.dayAfterTomorrow();
    RangeController rangeController = Provider.of<RangeController>(context);

    List<DateTime> noFoodDates =
        context.watch<FirebaseFirestoreProvider>().userModel.noFoodDates;
    return TableCalendar(
      availableGestures: AvailableGestures.horizontalSwipe,
      firstDay: DateTime.now().hour < 21 ? tomorrow : dayAfterTomorrow,
      focusedDay: rangeController.start == OnlyDate.noneDate()
          ? DateTime.now().hour < 21
              ? tomorrow
              : dayAfterTomorrow
          : rangeController.start,
      lastDay: OnlyDate(tomorrow.year, tomorrow.month + 4, tomorrow.day),
      shouldFillViewport: true,
      currentDay: OnlyDate.noneDate(),
      rangeStartDay: rangeController.start,
      rangeEndDay: rangeController.end,
      onDaySelected: (selectedDay, focusedDay) {
        if (rangeController.start == OnlyDate.noneDate()) {
          // rangeController.setStart(selectedDay);
          rangeController.setStart(selectedDay);
        } else if (rangeController.end == OnlyDate.noneDate()) {
          if (selectedDay.isBefore(rangeController.start)) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Select end date after start date'),
              ),
            );
          } else {
            rangeController.setEnd(selectedDay);
            rangeController.toggleDrawer();
          }
        }
      },
      headerStyle: const HeaderStyle(
        headerPadding: EdgeInsets.symmetric(vertical: 3),
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      calendarStyle: CalendarStyle(
        rangeHighlightColor: Color(0x7FFF7A00),
      ),
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, _) {
          // for (DateTime d in firestoreData.userModel.noFoodDates) {
          if (noFoodDates.contains(OnlyDate.fromDate(date))) {
            return Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Color(0x7FFF0000),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  date.day.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }
          // }
          return null;
        },
        rangeStartBuilder: (context, day, focusedDay) {
          return Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Color(0xFFFF7A00),
              borderRadius: BorderRadius.circular(20),
              border: noFoodDates.contains(OnlyDate.fromDate(day))
                  ? Border.all(color: Colors.black, width: 2)
                  : null,
            ),
            child: Text(
              day.day.toString(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          );
        },
        rangeEndBuilder: (context, day, focusedDay) => Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: Color(0xFFFF7A00),
            borderRadius: BorderRadius.circular(20),
            border: noFoodDates.contains(OnlyDate.fromDate(day))
                ? Border.all(color: Colors.black, width: 2)
                : null,
          ),
          child: Text(
            day.day.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        withinRangeBuilder: (context, day, focusedDay) {
          if (noFoodDates.contains(OnlyDate.fromDate(day))) {
            return Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                // color: Color(0x7F0066FF),
                border: Border.all(
                  // color: Color(0x7F0066FF),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  day.day.toString(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            );
          }
          return null;
        },
      ),
    );
  }
}
