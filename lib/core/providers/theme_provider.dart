import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    _loadTheme();
    return ThemeMode.light;
  }

  late SharedPreferences _prefs;

  void _loadTheme() async {
    _prefs = await SharedPreferences.getInstance();
    final String? savedData = _prefs.getString("theme_mode");
    if (savedData != null) {
      state = ThemeMode.values.firstWhere((e) => e.name == savedData);
    }
  }

  void toggleTheme() async {
    state = state == ThemeMode.light
      ? ThemeMode.dark
      : ThemeMode.light;
    await _prefs.setString("theme_mode", state.name);
  }

}

final themeModeProvider = NotifierProvider<ThemeNotifier, ThemeMode>(ThemeNotifier.new);
