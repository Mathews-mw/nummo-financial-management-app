import 'package:flutter/material.dart';
import 'package:nummo/@types/transaction_type.dart';
import 'package:nummo/data/models/transaction.dart';
import 'package:nummo/@types/transaction_category.dart';

import 'package:nummo/data/repositories/transaction_repository.dart';

class TransactionProvider with ChangeNotifier {
  final TransactionRepository _repository;

  List<Transaction> _transactions = [];

  TransactionProvider(this._repository);

  List<Transaction> get transactions {
    return [..._transactions];
  }

  Future<void> createTransaction({
    required String title,
    required double value,
    required TransactionType type,
    required TransactionCategory category,
    DateTime? createdAt,
  }) async {
    final newTransaction = await _repository.createTransaction(
      title: title,
      value: value,
      type: type,
      category: category,
      createdAt: createdAt,
    );

    _transactions.add(newTransaction);
    notifyListeners();
  }

  Future<void> loadTransactions() async {
    final transactions = await _repository.findMany();

    _transactions = transactions;
    notifyListeners();
  }
}
