import 'package:flutter/material.dart';
import 'package:looply/service/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationSlot {
  bool enabled;
  TimeOfDay time;

  NotificationSlot({required this.enabled, required this.time});
}

class NotificationViewModel extends ChangeNotifier {
  // defaults: 09h, 14h, 20h
  final List<NotificationSlot> _slots = [
    NotificationSlot(enabled: true, time: const TimeOfDay(hour: 9, minute: 0)),
    NotificationSlot(enabled: true, time: const TimeOfDay(hour: 14, minute: 0)),
    NotificationSlot(enabled: true, time: const TimeOfDay(hour: 20, minute: 0)),
  ];

  bool _loaded = false;

  List<NotificationSlot> get slots => _slots;
  bool get loaded => _loaded;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();

    for (int i = 0; i < _slots.length; i++) {
      _slots[i].enabled =
          prefs.getBool('slot_${i}_enabled') ?? _slots[i].enabled;
      _slots[i].time = TimeOfDay(
        hour: prefs.getInt('slot_${i}_hour') ?? _slots[i].time.hour,
        minute: prefs.getInt('slot_${i}_minute') ?? _slots[i].time.minute,
      );
    }

    _loaded = true;
    notifyListeners();

    // reagenda tudo o que já estiver ativo, sempre que a app carrega as prefs
    for (int i = 0; i < _slots.length; i++) {
      if (_slots[i].enabled) {
        await NotificationService().scheduleSlotReminder(
          slot: i,
          hour: _slots[i].time.hour,
          minute: _slots[i].time.minute,
        );
      }
    }
  }

  Future<void> setSlotEnabled(int slot, bool value) async {
    _slots[slot].enabled = value;
    notifyListeners();

    if (value) {
      final service = NotificationService();
      await service.requestPermission();

      if (!await service.canScheduleExactAlarms()) {
        await Permission.scheduleExactAlarm.request();
      }
    }

    await _saveSlot(slot);
  }

  Future<void> setSlotTime(int slot, TimeOfDay time) async {
    _slots[slot].time = time;
    notifyListeners();
    await _saveSlot(slot);
  }

  Future<void> _saveSlot(int slot) async {
    final prefs = await SharedPreferences.getInstance();
    final s = _slots[slot];

    await prefs.setBool('slot_${slot}_enabled', s.enabled);
    await prefs.setInt('slot_${slot}_hour', s.time.hour);
    await prefs.setInt('slot_${slot}_minute', s.time.minute);

    if (s.enabled) {
      await NotificationService().scheduleSlotReminder(
        slot: slot,
        hour: s.time.hour,
        minute: s.time.minute,
      );
    } else {
      await NotificationService().cancelSlotReminder(slot);
    }
  }
}