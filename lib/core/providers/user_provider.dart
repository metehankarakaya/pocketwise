import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserNotifier extends Notifier<String> {
  @override
  String build() {
    _loadName();
    return "";
  }

  late SharedPreferences _prefs;

  void _loadName() async {
    _prefs = await SharedPreferences.getInstance();
    final String? savedData = _prefs.getString("user_name");
    if (savedData != null) {
      state = savedData;
    }
  }

  void setName(String name) async {
    _prefs = await SharedPreferences.getInstance();
    state = name;
    _prefs.setString("user_name", name);
  }

}

final userProvider = NotifierProvider<UserNotifier, String>(UserNotifier.new);
