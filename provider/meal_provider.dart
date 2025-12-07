import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal_plan_model.dart';
import '../services/meal_service.dart';
import '../core/utils/sugar_level_detector.dart';

class MealProvider extends ChangeNotifier {
  List<MealPlan> meals = [];

  bool notificationsEnabled = true;

  int? glucoseValue; // Best glucose value from OCR
  String? sugarCategory; // Normal / Mild / Moderate / High

  // -----------------------------------------------------------
  // LOAD meals automatically on startup from saved category
  // -----------------------------------------------------------
  Future<void> loadSavedMealCategory() async {
    final prefs = await SharedPreferences.getInstance();

    sugarCategory = prefs.getString('sugarLevelCategory');

    if (sugarCategory != null && sugarCategory!.isNotEmpty) {
      await loadMeals();
    }

    notifyListeners();
  }

  // -----------------------------------------------------------
  // LOAD meals when category is set
  // -----------------------------------------------------------
  Future<void> loadMeals() async {
    if (sugarCategory == null) {
      meals = [];
      notifyListeners();
      return;
    }

    try {
      meals = await MealService.loadMeals(sugarCategory!);
    } catch (e) {
      debugPrint("Error loading meals: $e");
      meals = [];
    }
    notifyListeners();
  }

  // -----------------------------------------------------------
  // SET glucose → determine category → save → reload meals
  // -----------------------------------------------------------
  Future<void> setGlucose(int value) async {
    glucoseValue = value;
    sugarCategory = SugarLevelDetector.getCategory(value);

    // Save category so app remembers on restart
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('sugarLevelCategory', sugarCategory!);

    await loadMeals();
  }
}
