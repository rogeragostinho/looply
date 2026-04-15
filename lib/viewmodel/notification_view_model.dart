import 'package:flutter/material.dart';
import 'package:looply/service/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationViewModel extends ChangeNotifier {
  bool _enabled = false;
  TimeOfDay _time = const TimeOfDay(hour: 20, minute: 0);
  bool _loaded = false;

  bool get enabled => _enabled;
  TimeOfDay get time => _time;
  bool get loaded => _loaded;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _enabled = prefs.getBool('notifications_enabled') ?? false;
    _time = TimeOfDay(
      hour: prefs.getInt('notification_hour') ?? 20,
      minute: prefs.getInt('notification_minute') ?? 0,
    );
    _loaded = true;
    notifyListeners();
  }

  Future<void> setEnabled(bool value) async {
    _enabled = value;
    notifyListeners();
    await _save();
  }

  Future<void> setTime(TimeOfDay time) async {
    _time = time;
    notifyListeners();
    await _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notifications_enabled', _enabled);
    await prefs.setInt('notification_hour', _time.hour);
    await prefs.setInt('notification_minute', _time.minute);

    if (_enabled) {
      await NotificationService().scheduleDailyReminder(
        hour: _time.hour,
        minute: _time.minute,
      );
    } else {
      await NotificationService().cancelDailyReminder();
    }
  }
}