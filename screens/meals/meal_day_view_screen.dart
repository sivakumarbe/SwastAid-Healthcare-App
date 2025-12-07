import 'package:flutter/material.dart';
import '../../models/meal_plan_model.dart';

class MealDayViewScreen extends StatelessWidget {
  final MealPlan meal;

  const MealDayViewScreen({super.key, required this.meal});

  Widget item(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Day ${meal.day}")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            item("Early Morning Drink", meal.earlyDrink),
            item("Breakfast", meal.breakfast),
            item("Mid-Morning Snack", meal.midSnack),
            item("Lunch", meal.lunch),
            item("Afternoon Snack", meal.afternoonSnack),
            item("Afternoon Drink", meal.afternoonDrink),
            item("Dinner", meal.dinner),
          ],
        ),
      ),
    );
  }
}
