import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Africa/Lagos'));

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings: initSettings);

    await _createAndroidChannel();
  }

  // ── ALTERADO: agora cria os dois canais, não só o 'looply_daily' ──
  Future<void> _createAndroidChannel() async {
    const dailyChannel = AndroidNotificationChannel(
      'looply_daily',
      'Revisões diárias',
      description: 'Lembrete diário para fazeres as tuas revisões no Looply',
      importance: Importance.high,
    );

    const testChannel = AndroidNotificationChannel(
      'looply_daily_test',
      'Testes',
      description: 'Canal usado só para testar notificações',
      importance: Importance.max,
    );

    final plugin = _plugin.resolvePlatformSpecificImplementation
    <AndroidFlutterLocalNotificationsPlugin>();

    await plugin?.createNotificationChannel(dailyChannel);
    await plugin?.createNotificationChannel(testChannel);
  }
  // ────────────────────────────────────────────────────────────────

  Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation
    <AndroidFlutterLocalNotificationsPlugin
        >();

    final granted = await android?.requestNotificationsPermission();
    return granted ?? false;
  }

  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    await _plugin.cancel(id: 1);

    final canExact = await canScheduleExactAlarms();

    await _plugin.zonedSchedule(
      id: 1,
      title: 'Hora de rever! 🧠',
      body: 'Tens cards à tua espera no Looply.',
      scheduledDate: _nextInstanceOfTime(hour, minute),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'looply_daily',
          'Revisões diárias',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyReminder() async {
    await _plugin.cancel(id: 1);
  }

  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  Future<bool> canScheduleExactAlarms() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation
    <AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.canScheduleExactNotifications() ?? false;
  }

  Future<void> scheduleTestNotificationViaTimer() async {
    final canExact = await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.canScheduleExactNotifications();
    print('Pode agendar exacto: $canExact');

    print('⏱️ Timer iniciado, a disparar em 5 segundos...');

    Timer(const Duration(seconds: 5), () async {
      print('🔔 Timer disparou, a mostrar notificação...');
      await showInstantNotification();
    });
  }

  // ── ALTERADO: volta a usar 'looply_daily_test', agora que o canal existe ──
  Future<void> scheduleTestNotification() async {
    final notifStatus = await Permission.notification.status;
    print('📛 Permissão de notificação: $notifStatus');

    if (!notifStatus.isGranted) {
      final result = await Permission.notification.request();
      print('📛 Resultado do pedido: $result');
    }

    if (!await Permission.scheduleExactAlarm.isGranted) {
      await Permission.scheduleExactAlarm.request();
    }

    final canExact = await canScheduleExactAlarms();
    print('🔔 Pode agendar exacto: $canExact');

    final scheduled = tz.TZDateTime.now(tz.local).add(const Duration(seconds: 10));
    print('🔔 A agendar para: $scheduled');

    await _plugin.zonedSchedule(
      id: 97,
      title: 'Teste Looply 🧠',
      body: 'Se vês isto, as notificações estão a funcionar!',
      scheduledDate: scheduled,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'looply_daily_test',
          'Testes',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: canExact
          ? AndroidScheduleMode.exactAllowWhileIdle
          : AndroidScheduleMode.inexactAllowWhileIdle,
    );

    print('✅ Agendado');
  }
  // ─────────────────────────────────────────────────────────────────────────

  Future<void> showInstantNotification() async {
    await _plugin.show(
      id: 98,
      title: 'Teste imediato 🧠',
      body: 'Esta notificação é imediata!',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'looply_daily',
          'Revisões diárias',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
    print('⚡ Notificação imediata enviada');
  }
}