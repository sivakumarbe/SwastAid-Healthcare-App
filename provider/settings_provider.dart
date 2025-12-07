import 'package:flutter/material.dart';
import '../services/notifications/schedule_manager.dart';

class SettingsProvider extends ChangeNotifier {
  bool pillReminderEnabled = true;

  Future<void> toggleReminder(bool value) async {
    pillReminderEnabled = value;

    if (value) {
      await ScheduleManager.scheduleAll();
    } else {
      await ScheduleManager.cancelAll();
    }

    notifyListeners();
  }
}
