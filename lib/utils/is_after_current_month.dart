class IsAfterCurrentMonth {
  static bool compare(DateTime targetDate) {
    final now = DateTime.now();

    if (targetDate.month == now.month && targetDate.year == now.year) {
      return true;
    }

    if (targetDate.year > now.year) return true;

    if (targetDate.year == now.year && targetDate.month > now.month) {
      return true;
    }

    return false;
  }
}
