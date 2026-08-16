/// Representa os dados resumidos exibidos no Home Screen Widget do Looply.
///
/// Mantido separado do modelo [Topic]/[Revision] da app principal para que
/// o widget nunca dependa de mais informação do que precisa (apenas
/// contagens agregadas, nunca listas ou detalhes de cartões).
class LooplyWidgetData {
  final int todayCount;
  final int pendingCount;

  const LooplyWidgetData({
    required this.todayCount,
    required this.pendingCount,
  });

  bool get isAllDone => todayCount == 0 && pendingCount == 0;

  @override
  String toString() =>
      'LooplyWidgetData(today: $todayCount, pending: $pendingCount)';
}
