import 'package:flutter/material.dart';

import 'package:nummo/components/app_drawer.dart';
import 'package:nummo/components/custom_app_bar.dart';

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
      appBar: CustomAppBar(onOpenDrawer: _handleOpenDrawer),
      drawer: const AppDrawer(),
      body: Center(child: const Text('Monthly budget screen')),
    );
  }
}
