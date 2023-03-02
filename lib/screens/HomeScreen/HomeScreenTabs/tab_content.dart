import 'package:flutter/material.dart';
import 'package:hostel_companion/components/min_text_button.dart';
import 'package:hostel_companion/controllers/firebase/user_data.dart';
import 'package:hostel_companion/controllers/provider/food_data.dart';
import 'package:hostel_companion/controllers/provider/range_controller.dart';
import 'package:hostel_companion/controllers/provider/toggle_controller.dart';
import 'package:hostel_companion/model/user_model.dart';
import 'package:hostel_companion/screens/HomeScreen/components/food_choice.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'range_tab_content.dart';
import 'tab_switcher.dart';

class TabContent extends StatelessWidget {
  final bool isDaily;
  const TabContent({super.key, this.isDaily = true});

  @override
  Widget build(BuildContext context) {
    bool isDaily = Provider.of<ToggleController>(context).isDaily;
    FoodData foodData = Provider.of<FoodData>(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      children: [
        TabSwitcher(
          isDaily: isDaily,
        ),
        Expanded(
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child:
                  isDaily ? const DailyTabContent() : const RangeTabContent()),
        ),
      ],
    );
  }
}

class DailyTabContent extends StatelessWidget {
  const DailyTabContent({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    DateTime curDate = context.watch<FoodData>().date;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Date: ',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  TextSpan(
                    text: DateFormat('dd MMM yyyy, EEEE').format(curDate),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            TextButton(
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                // remove splash
                splashFactory: NoSplash.splashFactory,
              ),
              onPressed: () {
                print("hellsodhfos");
                showDialog(
                    context: context,
                    builder: (context) => const CalendarDialogForDateSelect());
              },
              child: const Icon(
                Icons.edit,
                size: 25,
                color: Colors.black,
              ),
            ),
          ],
        ),
        RichText(
          // TextSpan('Current Selection:'),
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Current Selection: ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              TextSpan(
                text: ' Food',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ),
            ],
          ),
        ),
        FoodChoiceWidget(),
        Center(
          child: MinTextButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () async {
              await FirebaseDataGet().putUserData(UserModel(
                  name: 'name',
                  email: 'email',
                  id: 'id5',
                  noFoodDates: [OnlyDate.tomorrow()]));
            },
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: width * 0.53,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Color(0xFF4200FF),
                    Color(0x8FBD00FF),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// create calendar dialog
class CalendarDialogForDateSelect extends StatelessWidget {
  const CalendarDialogForDateSelect({super.key});

  @override
  Widget build(BuildContext context) {
    FoodData foodData = Provider.of<FoodData>(context);
    DateTime changeDate = foodData.date;
    OnlyDate tomorrow = OnlyDate.tomorrow();
    return SimpleDialog(
      children: [
        SizedBox(
          height: 400,
          width: 500,
          child: Expanded(
            child: TableCalendar(
              firstDay: tomorrow,
              focusedDay: tomorrow,
              lastDay:
                  OnlyDate(tomorrow.year, tomorrow.month + 4, tomorrow.day),
              shouldFillViewport: true,
              currentDay: changeDate,
              onDaySelected: (selectedDay, focusedDay) {
                foodData.setDate(selectedDay);
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ],
    );
  }
}
