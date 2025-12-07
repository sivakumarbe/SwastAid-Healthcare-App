import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/meal_plan_model.dart';

class MealService {
  static Future<List<MealPlan>> loadMeals(String category) async {
    final jsonString =
        await rootBundle.loadString('assets/data/food_data_categorized.json');

    final Map<String, dynamic> data = json.decode(jsonString);

    final List<dynamic> mealsJson = data[category];

    return mealsJson.map((e) => MealPlan.fromJson(e)).toList();
  }
}
