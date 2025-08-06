import 'package:drift/drift.dart';

import 'package:nummo/data/models/transaction.dart';
import 'package:nummo/@types/transaction_type.dart';
import 'package:nummo/core/database/app_database.dart';
import 'package:nummo/@types/transaction_category.dart';
import 'package:nummo/core/database/daos/transaction_dao.dart';

class TransactionRepository {
  final TransactionDao transactionDao;

  TransactionRepository({required this.transactionDao});

  Future<Transaction> createTransaction({
    required String title,
    required double value,
    required TransactionType type,
    required TransactionCategory category,
    DateTime? createdAt,
  }) async {
    final result = await transactionDao.insertTransaction(
      TransactionsTableCompanion(
        title: Value(title),
        value: Value(value),
        type: Value(type),
        category: Value(category),
        createdAt: createdAt != null ? Value(createdAt) : Value(DateTime.now()),
      ),
    );

    final newTransaction = Transaction(
      id: result,
      title: title,
      value: value,
      type: type,
      category: category,
      createdAt: createdAt ?? DateTime.now(),
    );

    return newTransaction;
  }

  Future<bool> updateTransaction(Transaction transaction) async {
    final TransactionsTableCompanion data = TransactionsTableCompanion(
      id: Value(transaction.id),
      title: Value(transaction.title),
      value: Value(transaction.value),
      type: Value(transaction.type),
      category: Value(transaction.category),
      updatedAt: Value(DateTime.now()),
    );

    return await transactionDao.updateTransaction(data);
  }

  Future<int> deleteTransaction(int id) async {
    return await transactionDao.deleteTransaction(id);
  }

  Future<List<Transaction>> findMany() async {
    final List<Transaction> tmp = [];

    final transactionsData = await transactionDao.findMany();

    return transactionsData.map((data) {
      return Transaction(
        id: data.id,
        title: data.title,
        value: data.value,
        type: data.type,
        category: data.category,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
      );
    }).toList();
  }

  Future<Transaction> getTransaction(int id) async {
    final data = await transactionDao.getUnique(id);

    return Transaction(
      id: data.id,
      title: data.title,
      value: data.value,
      type: data.type,
      category: data.category,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt,
    );
  }
}
