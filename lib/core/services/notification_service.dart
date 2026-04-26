import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  static final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);
    await _notifications.initialize(settings: initSettings);
  }

  Future<bool> showBalanceNotification(double balance, double income, double expense) async {
    const androidDetails = AndroidNotificationDetails(
      'balance_channel',
      'Balance Notification',
      channelDescription: 'Shows your current balance',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
      icon: '@mipmap/launcher_icon',
    );
    const details = NotificationDetails(android: androidDetails);

    await _notifications.show(
      id: 0,
      title: 'PocketWise',
      body: 'Bakiye: ₺$balance\n📈 Gelir: ₺$income  📉 Gider: ₺$expense',
      notificationDetails: details,
    );
    return true;
  }

  Future<bool> cancelNotification() async {
    await _notifications.cancel(id: 0);
    return true;
  }

}
