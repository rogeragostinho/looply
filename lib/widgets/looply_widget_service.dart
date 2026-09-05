import 'dart:developer' as developer;

import 'package:home_widget/home_widget.dart';
import 'package:looply/repository/topic_repository.dart';

import 'looply_widget_mapper.dart';

/// Camada responsável por toda a comunicação entre a app Flutter e o
/// Home Screen Widget Android (via `home_widget`).
///
/// Esta é a ÚNICA classe que deve tocar no `home_widget` package. O resto
/// da app não deve saber como o widget é implementado — apenas chama
/// [refreshLooplyWidget].
///
/// NOTA DE ARQUITETURA: o Dart já não calcula "Hoje"/"Pendentes". Só
/// envia a lista de datas (em millis, à meia-noite local) das revisões
/// ainda não concluídas com data <= hoje. A classificação Hoje vs
/// Pendente é feita nativamente em LooplyWidgetProvider.kt, para poder
/// ser recalculada no broadcast ACTION_DATE_CHANGED sem precisar de
/// acordar o Dart.
class LooplyWidgetService {
  /// Nome completo (pacote + classe) do LooplyWidgetProvider tal como
  /// declarado no `package ...` no topo de LooplyWidgetProvider.kt.
  ///
  /// IMPORTANTE: usar sempre o pacote "base" do projeto (o mesmo que
  /// aparece em `namespace` no android/app/build.gradle), NUNCA o
  /// applicationId com sufixos de build type (ex.: ".debug"). Em builds
  /// de debug, context.packageName inclui esse sufixo (ex.:
  /// com.velami.looply.debug), mas a classe Kotlin continua no pacote
  /// sem sufixo — se não passarmos este nome qualificado, o home_widget
  /// tenta carregar "<packageName>.LooplyWidgetProvider" e falha com
  /// "No Widget found with Name LooplyWidgetProvider" em debug.
  static const String _qualifiedAndroidWidgetName =
      'com.velami.looply.LooplyWidgetProvider';

  // Chave partilhada com o lado nativo (LooplyWidgetProvider.kt).
  static const String keyPendingDates = 'pending_dates';

  final TopicRepository _repository;

  LooplyWidgetService(this._repository);

  /// Lê os dados atuais da fonte principal, extrai as datas de revisão
  /// relevantes para o widget e envia-as, pedindo de seguida o redesenho.
  ///
  /// Nunca deve lançar exceções que interrompam o fluxo da app — falhas de
  /// atualização do widget são silenciosamente registadas em log, já que
  /// o widget é um extra e não deve nunca bloquear a app principal.
  Future<void> refresh() async {
    try {
      final topics = await _repository.getAll();
      final dates = LooplyWidgetMapper.pendingRevisionDateMillis(topics);
      await _saveAndUpdate(dates);
    } catch (e, st) {
      developer.log(
        'Falha ao atualizar o widget do Looply',
        error: e,
        stackTrace: st,
        name: 'LooplyWidgetService',
      );
    }
  }

  Future<void> _saveAndUpdate(List<int> pendingRevisionDatesMillis) async {
    await HomeWidget.saveWidgetData<String>(
      keyPendingDates,
      pendingRevisionDatesMillis.join(','), // string simples "millis,millis,millis"
    );
    await HomeWidget.updateWidget(
      qualifiedAndroidName: _qualifiedAndroidWidgetName,
    );
  }
}

/// Instância única do serviço, usada pela função de conveniência abaixo.
///
/// Se a app já usar um sistema de injeção de dependências (ex.: Provider),
/// pode substituir esta linha por `context.read<LooplyWidgetService>()`
/// e remover o singleton — a assinatura de [refreshLooplyWidget] mantém-se
/// igual.
final LooplyWidgetService _looplyWidgetService = LooplyWidgetService(
  TopicRepository(),
);

/// Função centralizada para atualizar o widget do Looply.
///
/// Deve ser chamada sempre que dados relevantes para o widget mudem:
/// - Ao abrir a app.
/// - Ao concluir uma revisão.
/// - Ao criar um novo tópico/revisão.
/// - Após uma sincronização de dados.
///
/// Ver INTEGRATION.md para os pontos exatos onde chamar esta função.
Future<void> refreshLooplyWidget() => _looplyWidgetService.refresh();