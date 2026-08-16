import 'package:looply/core/enums/revision_status.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/utils/util.dart';

import 'looply_widget_models.dart';

/// Converte os dados da fonte principal (lista de [Topic] com as suas
/// [Revision]) nas duas métricas que o widget mostra: revisões de hoje e
/// revisões pendentes.
///
/// A lógica replica exatamente a usada em `TopicService`/`Util.todayDate()`,
/// para que o widget nunca fique dessincronizado dos números vistos dentro
/// da app.
class LooplyWidgetMapper {
  const LooplyWidgetMapper._();

  static LooplyWidgetData fromTopics(List<Topic> topics) {
    final today = Util.todayDate();

    int todayCount = 0;
    int pendingCount = 0;

    for (final topic in topics) {
      final revisions = topic.revisions;
      if (revisions == null) continue;

      for (final revision in revisions) {
        // Normaliza a data da revisão para meia-noite, tal como o resto
        // da app faz (ver TopicService.updateStatus).
        final revisionDate = DateTime(
          revision.date.year,
          revision.date.month,
          revision.date.day,
        );

        final isDone = revision.status == RevisionStatus.done;

        // Hoje: data == hoje e ainda não concluída.
        // (Uma revisão já feita hoje não deve contar como "por fazer hoje".)
        if (revisionDate.isAtSameMomentAs(today) && !isDone) {
          todayCount++;
          continue;
        }

        // Pendente: data < hoje e ainda não concluída.
        if (revisionDate.isBefore(today) && !isDone) {
          pendingCount++;
        }
      }
    }

    return LooplyWidgetData(
      todayCount: todayCount,
      pendingCount: pendingCount,
    );
  }
}
