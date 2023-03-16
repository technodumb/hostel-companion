import 'package:flutter/material.dart';
import 'package:hostel_companion/controllers/provider/firebase_firestore_provider.dart';
import 'package:hostel_companion/controllers/provider/food_data.dart';
import 'package:hostel_companion/controllers/provider/toggle_controller.dart';
import 'package:provider/provider.dart';

class TabSwitcher extends StatelessWidget {
  final bool isDaily;
  const TabSwitcher({super.key, required this.isDaily});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    ToggleController toggleController = context.read<ToggleController>();
    FoodData foodData = context.read<FoodData>();
    List<DateTime> noFoodDates =
        context.watch<FirebaseFirestoreProvider>().userModel.noFoodDates;
    DateTime nextDay = DateTime.now().hour < 21
        ? OnlyDate.tomorrow()
        : OnlyDate.dayAfterTomorrow();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2),
      // color: Colors.red,
      child: Row(
        children: [
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(isDaily ? 0xFFCC00FF : 0xFFFFFFFF),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              // minimumSize: Size.zero,
              fixedSize: Size(width * (isDaily ? 0.55 : 0.45), 50),
              shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(20)),
              ),
            ),
            onPressed: () {
              foodData.setDate(nextDay);
              if (noFoodDates.contains(nextDay)) {
                foodData.toggleIsFood(value: false);
                toggleController.toggleIsFood(value: false);
              } else {
                foodData.toggleIsFood(value: true);
                toggleController.toggleIsFood(value: true);
              }
              toggleController.setIsDaily = true;
            },
            child: Text(
              'Daily',
              style: TextStyle(
                color: isDaily ? Colors.white : Colors.black,
                fontWeight: FontWeight.w400,
                fontSize: 16,
                fontFamily: 'Inter',
              ),
            ),
          ),
          TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(isDaily ? 0xFFFFFFFF : 0xFFCC00FF),
              padding: EdgeInsets.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              fixedSize: Size(width * (isDaily ? 0.45 : 0.55), 50),
              // minimumSize: Size.zero,
              shape: RoundedRectangleBorder(
                borderRadius: isDaily
                    ? BorderRadius.zero
                    : const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                      ),
              ),
            ),
            onPressed: () {
              context.read<ToggleController>().setIsDaily = false;
            },
            child: Text(
              'Range',
              style: TextStyle(
                color: isDaily ? Colors.black : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
              ),
            ),
          )
        ],
      ),
    );
  }
}
