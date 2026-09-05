import 'package:workmanager/workmanager.dart';
import 'package:looply/db/db_initializer.dart';
import 'package:looply/repository/topic_repository.dart';
import 'package:looply/service/topic_service.dart';
import 'package:looply/service/notification_service.dart';

const String kWorkmanagerTaskPrefix = 'looply_slot_';

class NotificationScheduler {
  static Future<void> initialize() async {
    await Workmanager().initialize(callbackDispatcher);
  }

  // Agenda (ou reagenda) um slot específico (0, 1 ou 2) para a próxima
  // ocorrência da hora indicada, usando OneOffWorkRequest + initialDelay.
  static Future<void> scheduleSlot({
    required int slot,
    required int hour,
    required int minute,
  }) async {
    final taskName = '$kWorkmanagerTaskPrefix$slot';

    await Workmanager().cancelByUniqueName(taskName);

    final delay = _delayUntilNext(hour, minute);

    await Workmanager().registerOneOffTask(
      taskName,
      taskName,
      initialDelay: delay,
      inputData: {
        'slot': slot,
        'hour': hour,
        'minute': minute,
      },
      constraints: Constraints(
        networkType: NetworkType.notRequired,
      ),
    );
  }

  static Future<void> cancelSlot(int slot) async {
    await Workmanager().cancelByUniqueName('$kWorkmanagerTaskPrefix$slot');
  }

  static Duration _delayUntilNext(int hour, int minute) {
    final now = DateTime.now();
    var next = DateTime(now.year, now.month, now.day, hour, minute);

    if (!next.isAfter(now)) {
      next = next.add(const Duration(days: 1));
    }

    return next.difference(now);
  }
}

// Precisa de estar no top-level (fora de qualquer classe) — exigência do workmanager.
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    try {
      DbInitializer.init();

      final slot = inputData?['slot'] as int? ?? 0;
      final hour = inputData?['hour'] as int? ?? 20;
      final minute = inputData?['minute'] as int? ?? 0;

      // TODO: confirmar se TopicRepository precisa de argumentos no construtor
      final service = TopicService(TopicRepository());

      final pendentes = await service.countDueOrPendingRevisions();

      if (pendentes > 0) {
        await NotificationService().showSlotNotification(pendentes: pendentes);
      }

      // reagenda o mesmo slot para amanhã à mesma hora
      await NotificationScheduler.scheduleSlot(
        slot: slot,
        hour: hour,
        minute: minute,
      );

      return Future.value(true);
    } catch (e) {
      // não relança — uma falha aqui não deve deixar a tarefa em estado inconsistente
      return Future.value(false);
    }
  });
}