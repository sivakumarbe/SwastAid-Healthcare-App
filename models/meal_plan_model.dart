class MealPlan {
  final String day;
  final String earlyDrink;
  final String breakfast;
  final String midSnack;
  final String lunch;
  final String afternoonSnack;
  final String afternoonDrink;
  final String dinner;

  MealPlan({
    required this.day,
    required this.earlyDrink,
    required this.breakfast,
    required this.midSnack,
    required this.lunch,
    required this.afternoonSnack,
    required this.afternoonDrink,
    required this.dinner,
  });

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      day: json["Day"].toString(),
      earlyDrink: json["Early Morning Drink"],
      breakfast: json["Breakfast"],
      midSnack: json["Mid-Morning Snack"],
      lunch: json["Lunch"],
      afternoonSnack: json["Afternoon Snack"],
      afternoonDrink: json["Afternoon Drink"],
      dinner: json["Dinner"],
    );
  }
}
