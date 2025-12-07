import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../provider/meal_provider.dart';
import '../../provider/report_provider.dart';
import 'meal_day_view_screen.dart';

class MealSuggestionScreen extends StatefulWidget {
  const MealSuggestionScreen({super.key});

  @override
  State<MealSuggestionScreen> createState() => _MealSuggestionScreenState();
}

class _MealSuggestionScreenState extends State<MealSuggestionScreen> {
  @override
  void initState() {
    super.initState();

    // if we already have a glucose value but meals not loaded, load them
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final rp = Provider.of<ReportProvider>(context, listen: false);
      final mp = Provider.of<MealProvider>(context, listen: false);

      if (rp.glucoseValue != null && mp.meals.isEmpty) {
        mp.setGlucose(rp.glucoseValue!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mealProv = Provider.of<MealProvider>(context);
    final reportProv = Provider.of<ReportProvider>(context);

    final hasGlucose = reportProv.glucoseValue != null;

    return Scaffold(
      appBar: AppBar(title: const Text("Meal Suggestions")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: hasGlucose && mealProv.meals.isNotEmpty
            ? _buildMealList(mealProv)
            : _buildEmptyState(context),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.restaurant_menu, size: 90, color: Colors.grey),
          const SizedBox(height: 16),
          const Text(
            "Upload your blood report to get your\n30-day diabetic meal plan.",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/uploadReport');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal.shade700,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              "Upload Report",
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMealList(MealProvider mealProv) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            "Meal is the best medicine",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: mealProv.meals.length,
            itemBuilder: (context, index) {
              final meal = mealProv.meals[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 5),
                child: ListTile(
                  title: Text("Day ${meal.day}"),
                  subtitle: Text(meal.breakfast),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MealDayViewScreen(meal: meal),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
