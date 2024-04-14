import 'package:flutter/material.dart';
import 'package:sudoku/Widgets/theme/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  ThemeData _themeData = lightTheme;
  static const String _themeKey = 'theme';

  ThemeProvider() {
    _loadTheme();
  }

  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    _saveTheme(themeData);
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightTheme) {
      themeData = darkTheme;
    } else {
      themeData = lightTheme;
    }
  }

  Future<void> _loadTheme() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? themeName = prefs.getString(_themeKey);
    if (themeName != null) {
      _themeData = themeName == 'dark' ? darkTheme : lightTheme;
      notifyListeners();
    }
  }

  Future<void> _saveTheme(ThemeData themeData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(_themeKey, themeData == darkTheme ? 'dark' : 'light');
  }
}
