import 'package:flutter/material.dart';

import 'package:nummo/components/app_drawer.dart';
import 'package:nummo/components/custom_app_bar.dart';
import 'package:nummo/ui/screens/monthly_budget/budget_list.dart';
import 'package:nummo/ui/screens/monthly_budget/create_new_budget_card.dart';

class MonthlyBudgetScreen extends StatefulWidget {
  const MonthlyBudgetScreen({super.key});

  @override
  State<MonthlyBudgetScreen> createState() => _MonthlyBudgetScreenState();
}

class _MonthlyBudgetScreenState extends State<MonthlyBudgetScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _handleOpenDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: CustomAppBar(
        onOpenDrawer: _handleOpenDrawer,
        showAvatar: false,
        title: 'Orçamentos mensais',
        subtitle: 'Organize seus limites de gastos por mês',
        actions: [],
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: 30,
        ),
        child: Column(
          children: [
            CreateNewBudgetCard(),
            const SizedBox(height: 20),
            BudgetList(),
          ],
        ),
      ),
    );
  }
}
