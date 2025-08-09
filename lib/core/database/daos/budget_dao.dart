import 'package:drift/drift.dart';

import '../app_database.dart';

part 'budget_dao.g.dart';

@DriftAccessor(tables: [BudgetsTable])
class BudgetDao extends DatabaseAccessor<AppDatabase> with _$BudgetDaoMixin {
  BudgetDao(super.db);

  Future<int> insertBudget(BudgetsTableCompanion budget) async {
    return await into(budgetsTable).insert(budget);
  }

  Future<bool> updateBudget(BudgetsTableCompanion budget) async {
    return await update(budgetsTable).replace(budget);
  }

  Future<int> deleteBudget(int id) async {
    return await (delete(budgetsTable)..where((row) => row.id.equals(id))).go();
  }

  Future<List<BudgetsTableData>> findMany() async {
    // final data = await select(budgetsTable).get();
    final data =
        await (select(budgetsTable)..orderBy([
              (t) =>
                  OrderingTerm(expression: t.period, mode: OrderingMode.desc),
            ]))
            .get();

    return data;
  }

  Future<BudgetsTableData?> getUnique(int id) async {
    final budget = await (select(
      budgetsTable,
    )..where((row) => row.id.equals(id))).getSingleOrNull();

    return budget;
  }

  Future<BudgetsTableData?> findUniqueByPeriod(DateTime period) async {
    final budget = await (select(
      budgetsTable,
    )..where((row) => row.period.equals(period))).getSingleOrNull();

    return budget;
  }
}
