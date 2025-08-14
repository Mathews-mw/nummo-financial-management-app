import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:nummo/theme/app_colors.dart';
import 'package:nummo/providers/theme_provider.dart';
import 'package:nummo/providers/budget_provider.dart';
import 'package:nummo/ui/screens/monthly_budget/budget_item_tile.dart';

class BudgetList extends StatefulWidget {
  const BudgetList({super.key});

  @override
  State<BudgetList> createState() => _BudgetListState();
}

class _BudgetListState extends State<BudgetList> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadBudgets();
    });
  }

  Future<void> loadBudgets() async {
    setState(() => _isLoading = true);

    try {
      final budgetProvider = Provider.of<BudgetProvider>(
        context,
        listen: false,
      );

      await budgetProvider.loadBudgets();
    } catch (e) {
      print('Error loading budgets: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Consumer<BudgetProvider>(
      builder: (ctx, budgetProvider, child) {
        final budgetList = budgetProvider.budgets;

        if (_isLoading) {
          return Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                const SizedBox(height: 10),
                Text('Carregando orçamentos...'),
              ],
            ),
          );
        }

        return Expanded(
          child: Card(
            margin: EdgeInsets.all(0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    right: 20,
                    left: 20,
                    top: 10,
                    bottom: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'ORÇAMENTOS CADASTRADOS',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.gray700
                              : AppColors.gray200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          budgetList.length.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 0.2, color: AppColors.gray400, height: 1),
                if (budgetList.isEmpty)
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Icon(
                          PhosphorIcons.note(),
                          size: 38,
                          color: AppColors.gray500,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Você ainda não registrou nenhum orçamento.',
                            softWrap: true,
                            style: TextStyle(color: AppColors.gray500),
                          ),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (_, _) => Divider(
                      thickness: 0.2,
                      color: AppColors.gray400,
                      height: 0,
                    ),
                    itemCount: budgetList.length,
                    itemBuilder: (ctx, index) {
                      return Slidable(
                        endActionPane: ActionPane(
                          motion: ScrollMotion(),
                          children: [
                            SlidableAction(
                              onPressed: (context) {},
                              icon: PhosphorIcons.pencilSimpleLine(),
                              backgroundColor: const Color.fromRGBO(
                                61,
                                61,
                                175,
                                0.2,
                              ),
                              foregroundColor: AppColors.secondary,
                            ),
                            SlidableAction(
                              icon: PhosphorIcons.trash(),
                              backgroundColor: Color.fromRGBO(239, 68, 68, 0.2),
                              foregroundColor: AppColors.danger,
                              onPressed: (context) {
                                showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    backgroundColor: Colors.white,
                                    title: const Text('Remover transação'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          'Você tem certeza que deseja remover a transação?',
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(ctx, false),
                                        child: const Text(
                                          'Fechar',
                                          style: TextStyle(
                                            color: AppColors.gray700,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          // await deleteTransaction(
                                          //   budgetList[index].id,
                                          // );

                                          Navigator.pop(ctx, true);
                                        },
                                        child: const Text(
                                          'Remover',
                                          style: TextStyle(
                                            color: AppColors.danger,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        child: BudgetItemTile(budget: budgetList[index]),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
