
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Settings {
  static const String SETTINGS_CONFIRM_DELETE = "confirm_delete";
  static SharedPreferences _settings;
  static Future<void> initSettings() async {
    _settings = await SharedPreferences.getInstance();
  }

  static set confirmDelete(bool value) => _settings?.setBool(SETTINGS_CONFIRM_DELETE, value);
  static bool get confirmDelete => _settings?.getBool(SETTINGS_CONFIRM_DELETE) ?? true;

//  static Future<SharedPreferences> get settings async {
//    if (_settings == null)
//      _settings = await SharedPreferences.getInstance();
//    return _settings;
//  }
//
//  static Future<void> setConfirmDelete(bool value) async {
//    final settings = await Settings.settings;
//    settings.setBool(SETTINGS_CONFIRM_DELETE, value);
//  }
//  static Future<bool> getConfirmDelete() async {
//    final settings = await Settings.settings;
//    return settings.getBool(SETTINGS_CONFIRM_DELETE) ?? true;
//  }
}
