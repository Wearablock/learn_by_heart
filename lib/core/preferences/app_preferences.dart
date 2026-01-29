import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppPreferences {
  static const _keyThemeMode = 'theme_mode';
  static const _keyLocale = 'locale';
  static const _keyPassThreshold = 'pass_threshold';

  static AppPreferences? _instance;
  static SharedPreferences? _prefs;

  AppPreferences._();

  static Future<AppPreferences> getInstance() async {
    _instance ??= AppPreferences._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Theme Mode
  ThemeMode get themeMode {
    final value = _prefs?.getString(_keyThemeMode);
    switch (value) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    String value;
    switch (mode) {
      case ThemeMode.light:
        value = 'light';
      case ThemeMode.dark:
        value = 'dark';
      case ThemeMode.system:
        value = 'system';
    }
    await _prefs?.setString(_keyThemeMode, value);
  }

  // Locale
  Locale? get locale {
    final value = _prefs?.getString(_keyLocale);
    if (value == null || value.isEmpty) return null;
    return Locale(value);
  }

  Future<void> setLocale(Locale? locale) async {
    if (locale == null) {
      await _prefs?.remove(_keyLocale);
    } else {
      await _prefs?.setString(_keyLocale, locale.languageCode);
    }
  }

  // Pass Threshold (similarity percentage for correct answer)
  double get passThreshold {
    return _prefs?.getDouble(_keyPassThreshold) ?? 0.8;
  }

  Future<void> setPassThreshold(double value) async {
    await _prefs?.setDouble(_keyPassThreshold, value);
  }
}
