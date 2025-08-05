import 'package:flutter/material.dart';
import 'package:nummo/ui/screens/home/add_transaction.dart';
import 'package:nummo/ui/screens/home/month_selector.dart';

import 'package:nummo/components/app_drawer.dart';
import 'package:nummo/components/custom_app_bar.dart';
import 'package:nummo/ui/screens/home/budget_card.dart';
import 'package:nummo/ui/screens/home/transactions_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
      body: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 20,
          bottom: 30,
        ),
        child: Column(
          children: [
            MonthSelector(),
            const SizedBox(height: 20),
            BudgetCard(),
            const SizedBox(height: 20),
            TransactionsList(),
          ],
        ),
      ),
      floatingActionButton: AddTransaction(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
