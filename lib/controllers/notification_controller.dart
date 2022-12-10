import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationController {
  
  static final NotificationController instance = NotificationController._init();

  final FlutterLocalNotificationsPlugin _notificationController = FlutterLocalNotificationsPlugin();
  final BehaviorSubject<String?> onNotificationClick = BehaviorSubject();

  NotificationController._init();

  Future<void> initializeNotifier() async {
    tz.initializeTimeZones();
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings = InitializationSettings(
      android: androidInitializationSettings
    );

    await _notificationController.initialize(
      settings,
    );
  }

  Future<NotificationDetails> _notificationDetails() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'QUEST', 
      'RPG',
      channelDescription: 'Channel for RPG app\'s quest notification system',
      importance: Importance.max,
      priority: Priority.max,
      playSound: true
    );

    return const NotificationDetails(android: androidNotificationDetails);
  }

  Future<void> showScheduledNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    String? payload
  }) async {
    final NotificationDetails details = await _notificationDetails();
    await _notificationController.zonedSchedule(
      id, 
      title, 
      body, 
      tz.TZDateTime.from(dateTime, tz.local), 
      details, 
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, 
      androidAllowWhileIdle: true,
      payload: payload
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notificationController.cancel(id);
  }

}