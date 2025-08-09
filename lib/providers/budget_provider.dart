import 'package:flutter/material.dart';

import 'package:nummo/data/models/budget.dart';
import 'package:nummo/data/repositories/budget_repository.dart';

class BudgetProvider extends ChangeNotifier {
  final BudgetRepository _repository;

  List<Budget> _budgets = [];

  BudgetProvider(this._repository);

  List<Budget> get budgets {
    return [..._budgets];
  }

  Future<void> createBudget({
    required double total,
    required DateTime period,
    DateTime? createdAt,
  }) async {
    final newBudget = await _repository.createBudget(
      total: total,
      period: period,
      createdAt: createdAt,
    );

    _budgets.add(newBudget);
    notifyListeners();
  }

  Future<void> loadBudgets() async {
    final budgets = await _repository.findMany();

    _budgets = budgets;
    notifyListeners();
  }

  Future<Budget?> getUniqueByPeriod(DateTime period) async {
    final budget = await _repository.findUniqueByPeriod(
      DateTime(period.year, period.month),
    );

    return budget;
  }
}
