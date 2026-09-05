import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';

import 'looply_widget_service.dart';

/// Responsável por garantir que o widget do Looply é atualizado pelo menos
/// uma vez quando o dia muda, mesmo que o utilizador não abra a app.
///
/// Sem isto, o widget só atualiza quando a app é aberta ou quando algo
/// relevante muda dentro dela (ver looply_widget_service.dart) — o que
/// significa que, se a app ficar fechada de um dia para o outro, os
/// números de "Hoje" e "Pendentes" ficam desatualizados até a app voltar
/// a abrir.
///
/// Estratégia: uma tarefa periódica do WorkManager, com o primeiro disparo
/// agendado para a meia-noite seguinte e depois a repetir a cada 24h.
class LooplyWidgetScheduler {
  static const String _midnightTaskName = 'looply_midnight_widget_refresh';

  const LooplyWidgetScheduler._();

  /// Chamar uma vez, o mais cedo possível em main() — antes ou depois do
  /// runApp(), tanto faz.
  static void initialize() {
    debugPrint('[Looply] WorkManager initialize()');
    Workmanager().initialize(callbackDispatcher);
  }

  /// Agenda (ou confirma) a tarefa diária de refresh à meia-noite.
  ///
  /// Seguro para chamar em todos os arranques da app: como não passamos
  /// `existingWorkPolicy`, o valor por omissão é KEEP — ou seja, se já
  /// existir uma tarefa agendada com este nome, ela mantém-se tal como
  /// está (não recomeça a contagem a partir de agora), o que mantém o
  /// disparo sempre próximo da meia-noite mesmo em reinícios da app.
  static Future<void> scheduleMidnightRefresh() async {
    debugPrint('[Looply] A agendar tarefa');

    await Workmanager().registerOneOffTask(
      'teste_looply',
      _midnightTaskName,
      //initialDelay: _durationUntilNextMidnight(),
      //initialDelay: const Duration(minutes: 1),
      initialDelay: const Duration(seconds: 5),
    );

    debugPrint('[Looply] Tarefa registada');
  }

  static Duration _durationUntilNextMidnight() {
    final now = DateTime.now();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    return nextMidnight.difference(now);
  }
}

/// Entry point do isolate de background do WorkManager.
///
/// Tem de ser uma função de topo (fora de classes) e mantida com este
/// nome/assinatura — o Android/WorkManager procura-a pelo handle gerado
/// pelo Flutter, e isso só funciona para funções de topo ou estáticas.
@pragma('vm:entry-point')
void callbackDispatcher() {
  debugPrint('[Looply] callbackDispatcher carregado');
  // Necessário para os plugins (sqflite, home_widget) funcionarem dentro
  // deste isolate separado, que não tem o mesmo binding da UI principal.
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().executeTask((task, inputData) async {
    debugPrint('[Looply] tarefa em background iniciada: $task');
    switch (task) {
      case 'looply_midnight_widget_refresh':
      // refreshLooplyWidget() já trata os seus próprios erros e nunca
      // lança exceção (ver looply_widget_service.dart), por isso não
      // precisamos de try/catch aqui.
        await refreshLooplyWidget();
        debugPrint('[Looply] widget atualizado com sucesso em background');
        break;
    }
    return Future.value(true);
  });
}