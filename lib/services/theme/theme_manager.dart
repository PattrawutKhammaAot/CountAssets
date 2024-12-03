import 'package:flutter/material.dart';
import 'storage_manager.dart';

class ThemeNotifier with ChangeNotifier {
  final darkTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF212121),
    hintColor: Colors.white,
    dividerColor: Colors.black12,
  );

  final lightTheme = ThemeData(
    primarySwatch: Colors.grey,
    primaryColor: Colors.white,
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFE5E5E5),
    hintColor: Colors.black,
    dividerColor: Colors.white54,
  );

  late ThemeData _themeData = lightTheme; // Initialize with a default value
  ThemeData getTheme() => _themeData;

  ThemeNotifier() {
    StorageManager.readData('themeMode').then((value) {
      var themeMode = value ?? 'light';
      if (themeMode == 'light') {
        _themeData = lightTheme;
      } else {
        _themeData = darkTheme;
      }
      notifyListeners();
    }).catchError((error) {
      // Handle error if readData fails
      print('Error reading theme mode: $error');
    });
  }

  void setDarkMode() async {
    _themeData = darkTheme;
    await StorageManager.saveData('themeMode', 'dark');
    notifyListeners();
  }

  void setLightMode() async {
    _themeData = lightTheme;
    await StorageManager.saveData('themeMode', 'light');
    notifyListeners();
  }
}
