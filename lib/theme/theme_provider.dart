import 'package:flutter/material.dart';
import 'package:habit_tracker_app/theme/darkmode.dart';
import 'package:habit_tracker_app/theme/lightmode.dart';

class ThemeProvider with ChangeNotifier {
  // light mode
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;

  // is current theme dark mode(bool)
  bool get isDarkMode => _themeData == darkMode;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  // toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = darkMode;
    } else {
      themeData = lightMode;
    }
  }
}
