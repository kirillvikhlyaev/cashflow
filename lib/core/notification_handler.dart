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

  static Future showScheduledNotification({
    required int id,
    required String? title,
    required String? body,
    required String? payload,
    required DateTime scheduledDate,
  }) async =>
      _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(scheduledDate, tz.local),
        await _notificationDetails(),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
}
