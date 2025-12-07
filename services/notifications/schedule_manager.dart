// ignore: unused_import
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'notification_service.dart';

class ScheduleManager {
  // PRE-MEAL (30 mins before)
  static Future<void> scheduleAll() async {
    // Pre meal
    await NotificationService.scheduleDailyNotification(
      id: 1,
      scheduledDate: _nextInstanceOf(8, 30),
      title: "Pre-meal medicine Reminder",
      body: "Time to take your pre-meal medicine",
    );

    await NotificationService.scheduleDailyNotification(
      id: 2,
      scheduledDate: _nextInstanceOf(13, 00),
      title: "Pre-meal medicine Reminder",
      body: "Time to take your pre-meal medicine",
    );

    await NotificationService.scheduleDailyNotification(
      id: 3,
      scheduledDate: _nextInstanceOf(19, 00),
      title: "Pre-meal medicine Reminder",
      body: "Time to take your pre-meal medicine",
    );

    // Post meal
    await NotificationService.scheduleDailyNotification(
      id: 4,
      scheduledDate: _nextInstanceOf(9, 00),
      title: "Medicine Reminder",
      body: "Time to take your medicine",
    );

    await NotificationService.scheduleDailyNotification(
      id: 5,
      scheduledDate: _nextInstanceOf(13, 30),
      title: "Medicine Reminder",
      body: "Time to take your medicine",
    );

    await NotificationService.scheduleDailyNotification(
      id: 6,
      scheduledDate: _nextInstanceOf(19, 30),
      title: "Medicine Reminder",
      body: "Time to take your medicine",
    );
  }

  static tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  static Future<void> cancelAll() async {
    for (int i = 1; i <= 6; i++) {
      await NotificationService.cancel(i);
    }
  }
}
