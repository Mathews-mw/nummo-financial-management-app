import 'package:drift/drift.dart';

import 'package:nummo/data/models/budget.dart';
import 'package:nummo/core/database/app_database.dart';
import 'package:nummo/core/database/daos/budget_dao.dart';

class BudgetRepository {
  final BudgetDao budgetDao;

  BudgetRepository({required this.budgetDao});

  Future<Budget> createBudget({
    required double total,
    required DateTime period,
    DateTime? createdAt,
  }) async {
    final result = await budgetDao.insertBudget(
      BudgetsTableCompanion(
        total: Value(total),
        period: Value(DateTime(period.year, period.month)),
        createdAt: createdAt != null ? Value(createdAt) : Value(DateTime.now()),
      ),
    );

    final newBudget = Budget(
      id: result,
      total: total,
      period: period,
      createdAt: createdAt ?? DateTime.now(),
    );

    return newBudget;
  }

  Future<bool> updateBudget(Budget budget) async {
    final BudgetsTableCompanion data = BudgetsTableCompanion(
      id: Value(budget.id),
      total: Value(budget.total),
      period: Value(budget.period),
    );

    return await budgetDao.updateBudget(data);
  }

  Future<int> deleteBudget(int id) async {
    return await budgetDao.deleteBudget(id);
  }

  Future<List<Budget>> findMany() async {
    final List<Budget> tmp = [];

    final budgetsData = await budgetDao.findMany();

    return budgetsData.map((data) {
      return Budget(
        id: data.id,
        total: data.total,
        period: data.period,
        createdAt: data.createdAt,
      );
    }).toList();
  }

  Future<Budget?> getBudget(int id) async {
    final data = await budgetDao.getUnique(id);

    if (data == null) {
      return null;
    }

    return Budget(
      id: data.id,
      total: data.total,
      period: data.period,
      createdAt: data.createdAt,
    );
  }

  Future<Budget?> findUniqueByPeriod(DateTime period) async {
    final data = await budgetDao.findUniqueByPeriod(period);

    if (data == null) {
      return null;
    }

    return Budget(
      id: data.id,
      total: data.total,
      period: data.period,
      createdAt: data.createdAt,
    );
  }
}
