import 'package:flutter/material.dart';
import 'package:hostel_companion/components/min_text_button.dart';
import 'package:hostel_companion/controllers/provider/toggle_controller.dart';
import 'package:provider/provider.dart';

class FoodChoiceWidget extends StatelessWidget {
  FoodChoiceWidget({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isFood = Provider.of<ToggleController>(context).isFood;
    return Center(
      child: Container(
        height: 60,
        width: width * 0.8,
        margin: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: Colors.black,
            width: 1,
          ),
        ),
        child: MinTextButton(
          onPressed: () {
            context.read<ToggleController>().toggleIsFood();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FoodChoiceW1(text: 'No Food', mode: !isFood, color: Colors.red),
              FoodChoiceW1(text: 'Food', mode: isFood, color: Colors.blue),
            ],
          ),
        ),
      ),
    );
  }
}

class FoodChoiceW1 extends StatelessWidget {
  final String text;
  final bool mode;
  final Color color;
  const FoodChoiceW1(
      {super.key, required this.text, required this.mode, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: mode ? 6 : 4,
      child: Container(
        alignment: Alignment.center,
        height: double.infinity,
        decoration: BoxDecoration(
          color: mode ? color : Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: mode ? Colors.white : Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
