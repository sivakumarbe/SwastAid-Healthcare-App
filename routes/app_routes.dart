import 'package:flutter/material.dart';
import '../screens/home/home_screen.dart';
import '../screens/reminders/pill_reminder_screen.dart';
import '../screens/meals/meal_suggestion_screen.dart';
// import '../screens/sos/emergency_sos_screen.dart';
import '../screens/activity/activity_screen.dart';
import '../screens/reports/upload_report_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String reminder = '/reminder';
  static const String meals = '/meals';
  // static const String sos = '/sos';
  static const String activity = '/activity';
  static const String uploadReport = '/upload-report';

  static final Map<String, WidgetBuilder> routes = {
    home: (context) => const HomeScreen(),
    reminder: (context) => const PillReminderScreen(),
    meals: (context) => const MealSuggestionScreen(),
    // sos: (context) => const EmergencySosScreen(), // Removed
    activity: (context) => const ActivityScreen(),
    uploadReport: (context) => const UploadReportScreen(),
  };
}
