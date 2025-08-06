import 'package:drift/drift.dart';

import '../app_database.dart';

part 'transaction_dao.g.dart';

@DriftAccessor(tables: [TransactionsTable])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  Future<int> insertTransaction(TransactionsTableCompanion transaction) async {
    return await into(transactionsTable).insert(transaction);
  }

  Future<bool> updateTransaction(TransactionsTableCompanion transaction) async {
    return await update(transactionsTable).replace(transaction);
  }

  Future<int> deleteTransaction(int id) async {
    return await (delete(
      transactionsTable,
    )..where((row) => row.id.equals(id))).go();
  }

  Future<List<TransactionsTableData>> findMany() async {
    final data = await select(transactionsTable).get();

    return data;
  }

  Future<TransactionsTableData> getUnique(int id) async {
    final transaction = await (select(
      transactionsTable,
    )..where((row) => row.id.equals(id))).getSingle();

    return transaction;
  }
}
