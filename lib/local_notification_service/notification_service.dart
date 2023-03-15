import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  LocalNotificationService();

  final _localNotificationsService = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  Future<void> initialize() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@drawable/ic_flutternotification');
    final DarwinInitializationSettings iosInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: _onDidReceivedNotification,
    );
    final InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );
    await _localNotificationsService.initialize(
      settings,
      onDidReceiveNotificationResponse: _onDidReceivedNotification(),
    );
  }

  dynamic _onDidReceivedNotification([
    int? id,
    String? title,
    String? body,
    String? payload,
  ]) {
    debugPrint('ID $id');
    if (payload != null && payload.isNotEmpty) {
          onNotificationClick.add(payload);
        }
  }

   NotificationDetails _notificationDetails() {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      'channel_Id',
      'channel_Name',
      channelDescription: 'description',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
    );
    DarwinNotificationDetails iosNotificationDetails=  const DarwinNotificationDetails();
    return  NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    final details = _notificationDetails();
    await _localNotificationsService.show(
      id,
      title,
      body,
      details,
    );
  }

  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required int seconds,
  }) async {
    final details = _notificationDetails();
    await _localNotificationsService.zonedSchedule(
      id,
      title,
      body,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      tz.TZDateTime.from(
        DateTime.now().add(
          Duration(seconds: seconds),
        ),
        tz.local,
      ),
      details,
      androidAllowWhileIdle: true,
    );
  }

  Future<void> showNotificationWithPayload({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    final details = _notificationDetails();
    await _localNotificationsService.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  void onSelectNotification(String? payload) {
    if (payload != null && payload.isNotEmpty) {
      onNotificationClick.add(payload);
    }
  }
}
