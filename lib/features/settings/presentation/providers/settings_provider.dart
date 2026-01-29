import 'package:flutter/material.dart';
import '../../../../core/preferences/app_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  AppPreferences? _prefs;
  bool _isLoading = true;

  ThemeMode _themeMode = ThemeMode.system;
  Locale? _locale;
  double _passThreshold = 0.8;

  SettingsProvider() {
    _loadSettings();
  }

  // Getters
  bool get isLoading => _isLoading;
  ThemeMode get themeMode => _themeMode;
  Locale? get locale => _locale;
  double get passThreshold => _passThreshold;

  Future<void> _loadSettings() async {
    _prefs = await AppPreferences.getInstance();
    _themeMode = _prefs!.themeMode;
    _locale = _prefs!.locale;
    _passThreshold = _prefs!.passThreshold;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    if (_themeMode != mode) {
      _themeMode = mode;
      await _prefs?.setThemeMode(mode);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale? locale) async {
    if (_locale != locale) {
      _locale = locale;
      await _prefs?.setLocale(locale);
      notifyListeners();
    }
  }

  Future<void> setPassThreshold(double value) async {
    if (_passThreshold != value) {
      _passThreshold = value;
      await _prefs?.setPassThreshold(value);
      notifyListeners();
    }
  }
}
