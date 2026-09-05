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

  // ALTERADO: agora agenda por slot (0, 1, 2), cada um com id próprio
  Future<void> scheduleSlotReminder({
    required int slot,
    required int hour,
    required int minute,
  }) async {
    final id = 10 + slot; // ids 10, 11, 12 — não colidem com o resto (1, 97, 98)

    await _plugin.cancel(id: id);

    final canExact = await canScheduleExactAlarms();

    await _plugin.zonedSchedule(
      id: id,
      title: 'Hora de rever! 🧠',
      body: 'Tens revisões à tua espera no Looply.',
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

  Future<void> cancelSlotReminder(int slot) async {
    await _plugin.cancel(id: 10 + slot);
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

  // ADICIONADO: notificação usada pelos 3 slots configuráveis, id dinâmico por slot
  Future<void> showSlotNotification({required int pendentes}) async {
    await _plugin.show(
      id: 200, // um id fixo chega, pois só uma pode estar visível de cada vez por slot
      title: 'Hora de rever! 🧠',
      body: pendentes == 1
          ? 'Tens 1 revisão à tua espera no Looply.'
          : 'Tens $pendentes revisões à tua espera no Looply.',
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'looply_daily',
          'Revisões diárias',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}