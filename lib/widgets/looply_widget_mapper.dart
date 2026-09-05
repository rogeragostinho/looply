import 'package:looply/core/enums/revision_status.dart';
import 'package:looply/model/topic.dart';
import 'package:looply/utils/util.dart';

/// Extrai, da fonte principal (lista de [Topic] com as suas [Revision]),
/// as datas das revisões relevantes para o widget: revisões ainda não
/// concluídas cuja data é hoje ou anterior (atrasadas).
///
/// A classificação "Hoje" vs "Pendente" já NÃO é feita aqui — passou a
/// ser calculada nativamente em LooplyWidgetProvider.kt, comparando estas
/// datas com o dia atual do dispositivo. Isto permite que o widget se
/// recalcule sozinho à meia-noite (via broadcast ACTION_DATE_CHANGED),
/// sem precisar de acordar o Dart.
///
/// A normalização de data replica exatamente a usada em
/// `TopicService`/`Util.todayDate()`, para que o widget nunca fique
/// dessincronizado dos números vistos dentro da app.
class LooplyWidgetMapper {
  const LooplyWidgetMapper._();

  static List<int> pendingRevisionDateMillis(List<Topic> topics) {
    final dates = <int>[];

    for (final topic in topics) {
      final revisions = topic.revisions;
      if (revisions == null) continue;

      for (final revision in revisions) {
        final isDone = revision.status == RevisionStatus.done;
        if (isDone) continue;

        final revisionDate = DateTime(
          revision.date.year,
          revision.date.month,
          revision.date.day,
        );

        // Envia TODAS as datas não concluídas — passadas, hoje e futuras.
        // É o Kotlin que decide o que conta como "hoje"/"pendente" no
        // momento em que desenha o widget.
        dates.add(revisionDate.millisecondsSinceEpoch);
      }
    }

    return dates;
  }
}