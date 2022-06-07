// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationHandler {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();
  static Future _notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel desciption',
            importance: Importance.max),
        iOS: const IOSNotificationDetails());
  }

  static Future init({bool isSheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();

    final settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(
      settings,
      onSelectNotification: (payload) async {
        onNotification.add(payload);
        if (payload != null) {
          log('notification payload: $payload');
        }
      },
    );
  }

  static Future showOnceScheduledNotification({
    required int id,
    required String? title,
    required String? body,
    required String? payload,
    required DateTime requiredDate,
  }) async {
    final tz.TZDateTime now = tz.TZDateTime.from(requiredDate, tz.local);

    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day - 1, 10);

    _notifications.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      await _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> scheduleMonthlyTenAMNotification({
    required int id,
    required String? title,
    required String? body,
    required String? payload,
    required DateTime requiredDate,
  }) async {
    await _notifications.zonedSchedule(
        id,
        title,
        body,
        _nextInstanceOfTenAM(requiredDate),
        const NotificationDetails(
          android: AndroidNotificationDetails('monthly notification channel id',
              'monthly notification channel name'),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime);
  }

  static tz.TZDateTime _nextInstanceOfTenAM(DateTime requiredMonth) {
    final tz.TZDateTime now = tz.TZDateTime.from(requiredMonth, tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day - 1, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    log('$scheduledDate');
    return scheduledDate;
  }
}
