import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:permission_handler/permission_handler.dart';

class NotificationService {
  // Instância singleton — só existe um NotificationService na app toda
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  // Chama este método uma vez no main(), antes do runApp()
  Future<void> init() async {
    // Necessário para agendar por timezone (ex: hora local de Angola)
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

    // Cria o canal Android (obrigatório no Android 8+)
    await _createAndroidChannel();
  }

  Future<void> _createAndroidChannel() async {
    const channel = AndroidNotificationChannel(
      'looply_daily', // ID único do canal
      'Revisões diárias', // Nome visível nas definições do telemóvel
      description: 'Lembrete diário para fazeres as tuas revisões no Looply',
      importance: Importance.high,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  // Pede permissão ao utilizador (Android 13+ e iOS)
  Future<bool> requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    final granted = await android?.requestNotificationsPermission();
    return granted ?? false;
  }

  // Agenda uma notificação diária a uma hora fixa
  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    // Cancela qualquer agendamento anterior com o mesmo ID
    await _plugin.cancel(id: 1);

    await _plugin.zonedSchedule(
      id: 1, // ID da notificação (1 = lembrete diário)
      title: 'Hora de rever! 🧠', // Título
      body: 'Tens cards à tua espera no Looply.', // Corpo
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
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime, // Repete todos os dias
    );
  }

  // Cancela o lembrete diário
  Future<void> cancelDailyReminder() async {
    await _plugin.cancel(id: 1);
  }

  // Calcula o próximo momento em que a hora pedida vai ocorrer
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

    // Se a hora de hoje já passou, agenda para amanhã
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  Future<bool> canScheduleExactAlarms() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    return await android?.canScheduleExactNotifications() ?? false;
  }

  // Teste
  Future<void> scheduleTestNotification() async {
    // Pede permissão de alarme exacto se necessário
    if (!await Permission.scheduleExactAlarm.isGranted) {
      await Permission.scheduleExactAlarm.request();
    }

    final now = tz.TZDateTime.now(tz.local);
    final scheduled = now.add(const Duration(seconds: 5));

    print('🔔 A agendar para: $scheduled');

    await _plugin.zonedSchedule(
      id: 97,
      title: 'Teste Looply 🧠',
      body: 'Se vês isto, as notificações estão a funcionar!',
      scheduledDate: scheduled,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'looply_daily',
          'Revisões diárias',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );

    print('✅ Agendado');
  }

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
