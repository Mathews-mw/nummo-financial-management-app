enum TransactionType {
  income,
  outcome;

  String get value {
    switch (this) {
      case TransactionType.income:
        return 'income';
      case TransactionType.outcome:
        return 'outcome';
    }
  }

  String get label {
    switch (this) {
      case TransactionType.income:
        return 'Entrada';
      case TransactionType.outcome:
        return 'Saída';
    }
  }
}
