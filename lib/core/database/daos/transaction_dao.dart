import 'package:drift/drift.dart';
import 'package:nummo/@types/transaction_type.dart';

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
    final data =
        await (select(transactionsTable)..orderBy([
              (t) => OrderingTerm(
                expression: t.createdAt,
                mode: OrderingMode.desc,
              ),
            ]))
            .get();

    return data;
  }

  Future<List<TransactionsTableData>> getTransactionsByMonthAndYear({
    required int month,
    required int year,
  }) async {
    // First month day
    final startDate = DateTime(year, month, 1);

    // Last month day (get day 0 from next month)
    final endDate = DateTime(year, month + 1, 0, 23, 59, 59);

    final query = select(transactionsTable)
      ..where(
        (row) =>
            row.createdAt.isBiggerOrEqualValue(startDate) &
            row.createdAt.isSmallerOrEqualValue(endDate),
      )
      ..orderBy([
        (row) =>
            OrderingTerm(expression: row.createdAt, mode: OrderingMode.desc),
      ]);

    return query.get();
  }

  Future<TransactionsTableData> getUnique(int id) async {
    final transaction = await (select(
      transactionsTable,
    )..where((row) => row.id.equals(id))).getSingle();

    return transaction;
  }

  Future<double> getTotalSpentForBudget(
    int budgetId, {
    TransactionType? type,
  }) async {
    final query = (selectOnly(transactionsTable)
      ..addColumns([transactionsTable.value.sum()])
      ..where(transactionsTable.budgetId.equals(budgetId)));

    if (type != null) {
      query.where(transactionsTable.type.equals(type.value));
    }

    final result = await query.getSingle();

    final amount = result.read(transactionsTable.value.sum());

    return amount ?? 0.0;
  }
}
