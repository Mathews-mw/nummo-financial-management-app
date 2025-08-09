enum RecurrenceType {
  once,
  daily,
  weekly,
  monthly,
  yearly;

  String get value {
    switch (this) {
      case RecurrenceType.once:
        return 'once';
      case RecurrenceType.daily:
        return 'daily';
      case RecurrenceType.weekly:
        return 'weekly';
      case RecurrenceType.monthly:
        return 'monthly';
      case RecurrenceType.yearly:
        return 'yearly';
    }
  }

  String get label {
    switch (this) {
      case RecurrenceType.once:
        return 'Único';
      case RecurrenceType.daily:
        return 'Diário';
      case RecurrenceType.weekly:
        return 'Semanal';
      case RecurrenceType.monthly:
        return 'Mensal';
      case RecurrenceType.yearly:
        return 'Anual';
    }
  }
}
