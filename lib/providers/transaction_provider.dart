import 'package:flutter/material.dart';

import 'package:nummo/@types/transaction_type.dart';
import 'package:nummo/data/models/transaction.dart';
import 'package:nummo/@types/transaction_category.dart';
import 'package:nummo/data/repositories/transaction_repository.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository _repository;

  List<Transaction> _transactions = [];
  double _totalSpent = 0.0;

  TransactionProvider(this._repository);

  List<Transaction> get transactions {
    return [..._transactions];
  }

  double get totalSpent => _totalSpent;

  Future<void> createTransaction({
    required int budgetId,
    required String title,
    required double value,
    required TransactionType type,
    required TransactionCategory category,
    DateTime? createdAt,
  }) async {
    final newTransaction = await _repository.createTransaction(
      budgetId: budgetId,
      title: title,
      value: value,
      type: type,
      category: category,
      createdAt: createdAt,
    );

    _transactions.add(newTransaction);
    await loadSpentForBudget(budgetId, type: TransactionType.outcome);

    notifyListeners();
  }

  Future<void> deleteTransaction(int transactionId) async {
    await _repository.deleteTransaction(transactionId);

    _transactions.removeWhere((transaction) => transaction.id == transactionId);

    notifyListeners();
  }

  Future<void> loadTransactions({required int month, required int year}) async {
    final transactions = await _repository.getTransactionsByMonthAndYear(
      month: month,
      year: year,
    );

    _transactions = transactions;
    notifyListeners();
  }

  Future<void> loadSpentForBudget(int budgetId, {TransactionType? type}) async {
    _totalSpent = await _repository.getTotalSpentForBudget(
      budgetId,
      type: type,
    );

    notifyListeners();
  }
}
