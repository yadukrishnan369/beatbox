import 'package:flutter/material.dart';

class AppColors {
  // Dynamic theme based colors
  static late Color primary;
  static late Color backgroundPrimary;
  static late Color liteGrey;
  static late Color textPrimary;
  static late Color textSecondary;
  static late Color textDisabled;
  static late Color white;
  static late Color offWhite;
  static late Color cream;
  static late Color blue;
  static late Color cardColor;
  static late Color contColor;

  // colors, fixed always
  static const Color success = Color(0xFF4BB543);
  static const Color error = Color(0xFFD90429);
  static const Color warning = Color(0xFFFFC107);
  static const Color cartSubmit = Color(0x00EAE5E5);
  static const Color bottomNavColor = Color(0xff2F4B4E);

  // Update theme based on dark mode switch
  static void updateTheme(bool isDark) {
    primary = Colors.blueGrey;
    backgroundPrimary = isDark ? Colors.black : const Color(0xFFECEFF1);
    liteGrey = isDark ? Colors.grey[800]! : const Color(0xFFFAFAFA);
    textPrimary = isDark ? Colors.white : const Color(0xFF152223);
    textSecondary = isDark ? Colors.grey[300]! : const Color(0xFF606060);
    textDisabled = isDark ? Colors.grey[500]! : const Color(0xFF9E9E9E);
    white = isDark ? Colors.black : Colors.white;
    offWhite = isDark ? Colors.grey[900]! : const Color(0xFFF5F5F5);
    cream = isDark ? Colors.grey[800]! : const Color(0xFFFFFDE7);
    blue = const Color.fromARGB(255, 97, 159, 210);
    cardColor =
        isDark ? Colors.grey[850]! : const Color.fromARGB(233, 234, 233, 232);
    contColor =
        isDark ? Colors.grey[800]! : const Color.fromARGB(255, 192, 203, 204);
  }
}
