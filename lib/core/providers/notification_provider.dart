import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/notification_service.dart';

class NotificationNotifier extends Notifier<bool> {
  @override
  bool build() {
    _loadNotificationState();
    return true;
  }

  late SharedPreferences _prefs;

  void _loadNotificationState() async {
    _prefs = await SharedPreferences.getInstance();
    final String? savedData = _prefs.getString("notification_enabled");
    if (savedData != null) {
      state = savedData == "true";
    }
  }

  void toggleNotification(double balance, double income, double expense) async {
    state = !state;
    await _prefs.setString("notification_enabled", state.toString());
    if (!state) {
      await NotificationService().cancelNotification();
    } else {
      await NotificationService().showBalanceNotification(balance, income, expense);
    }
  }

}

final notificationProvider = NotifierProvider<NotificationNotifier, bool>(NotificationNotifier.new);
