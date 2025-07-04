import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  static final ValueNotifier<bool> isDarkMode = ValueNotifier(false);

  static Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = prefs.getBool('isDarkMode') ?? false;
  }

  static Future<void> toggleTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    isDarkMode.value = isDark;
    await prefs.setBool('isDarkMode', isDark);
  }
}
