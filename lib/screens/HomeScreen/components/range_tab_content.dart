import 'package:flutter/material.dart';
import 'package:hostel_companion/components/min_text_button.dart';
import 'package:hostel_companion/controllers/provider/food_data.dart';
import 'package:hostel_companion/controllers/provider/range_controller.dart';
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
                      decoration: BoxDecoration(),
                      height: width * 0.8,
                      width: double.infinity,
                      child: CustomRangeCalendar(),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Visibility(
              visible: rangeController.start != OnlyDate.noneDate() &&
                  rangeController.end != OnlyDate.noneDate(),
              child: MinTextButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Container(
                  height: 40,
                  // padding: const EdgeInsets.symmetric(horizontal: 20),
                  // alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF4200FF),
                        Color(0x7FBD00FF),
                      ],
                    ),
                  ),
                  child: Text('Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            MinTextButton(
              onPressed: () {
                rangeController.reset();
              },
              child: Container(
                child: Text('Cancel'),
              ),
            ),
            SizedBox(
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
    DateTime tomorrow = OnlyDate.tomorrow();
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
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
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  'End Date: ${cleanDate(rangeController.end)}',
                  style: TextStyle(
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
            //           focusedDay: tomorrow,-
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
    RangeController rangeController = Provider.of<RangeController>(context);
    return TableCalendar(
      availableGestures: AvailableGestures.horizontalSwipe,
      firstDay: OnlyDate(tomorrow.year, tomorrow.month, 1),
      focusedDay: rangeController.start == OnlyDate.noneDate()
          ? tomorrow
          : rangeController.start,
      lastDay: OnlyDate(tomorrow.year, tomorrow.month + 4, tomorrow.day),
      shouldFillViewport: true,
      currentDay: OnlyDate.noneDate(),
      rangeStartDay: rangeController.start,
      rangeEndDay: rangeController.end,
      onDaySelected: (selectedDay, focusedDay) {
        if (rangeController.start == OnlyDate.noneDate()) {
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
          }
        }
      },
      headerStyle: HeaderStyle(
        headerPadding: EdgeInsets.symmetric(vertical: 3),
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }
}
