class Util {

  static DateTime todayDate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return today;
  }

  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

}