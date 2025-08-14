import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nummo/@types/transaction_type.dart';
import 'package:nummo/app_routes.dart';
import 'package:nummo/components/custom_outlined_button.dart';
import 'package:nummo/data/models/budget.dart';
import 'package:nummo/providers/budget_provider.dart';
import 'package:nummo/providers/theme_provider.dart';
import 'package:nummo/providers/transaction_provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:nummo/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

class BudgetCard extends StatefulWidget {
  final int year;
  final int month;
  final void Function(int?) onGetBudget;

  const BudgetCard({
    super.key,
    required this.year,
    required this.month,
    required this.onGetBudget,
  });

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  bool _isLoading = false;
  Budget? _budget;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadData(month: widget.month, year: widget.year);
    });
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();

    // Os dados dependem de dois Providers, então, é necessário ficar ouvindo suas mudanças
    loadData(month: widget.month, year: widget.year);
  }

  @override
  void didUpdateWidget(BudgetCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.month != oldWidget.month) {
      loadData(month: widget.month, year: widget.year);
    }
  }

  Future<int?> loadBudget({required int month, required int year}) async {
    final budgetProvider = Provider.of<BudgetProvider>(context, listen: false);

    final budget = await budgetProvider.getUniqueByPeriod(
      DateTime(year, month),
    );

    setState(() {
      _budget = budget;

      if (budget != null) {
        widget.onGetBudget(budget.id);
      } else {
        widget.onGetBudget(null);
      }
    });

    return budget?.id;
  }

  Future<void> loadTotalAmountTransactions(int budgetId) async {
    final transactionProvider = Provider.of<TransactionProvider>(
      context,
      listen: false,
    );

    await transactionProvider.loadSpentForBudget(
      budgetId,
      type: TransactionType.outcome,
    );
  }

  Future<void> loadData({required int month, required int year}) async {
    setState(() => _isLoading = true);

    try {
      final budgetIdResult = await loadBudget(month: month, year: year);

      if (budgetIdResult != null) {
        await loadTotalAmountTransactions(budgetIdResult);
      }
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Consumer<BudgetProvider>(
      builder: (context, budgetProvider, child) {
        return Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: themeProvider.themeMode == ThemeMode.dark
                ? AppColors.gray800
                : AppColors.gray900,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Skeletonizer(
                          enabled: _isLoading,
                          effect: ShimmerEffect(baseColor: Colors.white10),
                          child: RichText(
                            text: TextSpan(
                              style: TextStyle(
                                color: AppColors.foreground,
                                fontSize: 16,
                              ),
                              children: <TextSpan>[
                                const TextSpan(
                                  text: 'MAIO',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                TextSpan(
                                  text: ' / 2025',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: AppColors.gray400,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Icon(
                          PhosphorIconsFill.gearSix,
                          color: AppColors.foreground,
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Divider(thickness: 0.1, color: AppColors.gray600),
                    const SizedBox(height: 5),
                    Text(
                      'Orçamento disponível',
                      style: TextStyle(fontSize: 16, color: AppColors.gray400),
                    ),
                    const SizedBox(height: 5),
                    Skeletonizer(
                      ignoreContainers: true,
                      enabled: _isLoading,
                      effect: ShimmerEffect(baseColor: Colors.white10),
                      child: _budget != null
                          ? Selector<TransactionProvider, double>(
                              selector: (ctx, provider) => provider.totalSpent,
                              builder: (ctx, totalSpent, child) {
                                return Text(
                                  NumberFormat.simpleCurrency(
                                    locale: 'pt-BR',
                                    decimalDigits: 2,
                                  ).format(_budget!.total - totalSpent),
                                  style: TextStyle(
                                    fontSize: 34,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.foreground,
                                  ),
                                );
                              },
                            )
                          : Row(
                              children: [
                                Expanded(
                                  child: CustomOutlinedButton(
                                    label: 'Definir orçamento',
                                    onPressed: () {
                                      Navigator.of(
                                        context,
                                      ).pushNamedAndRemoveUntil(
                                        AppRoutes.monthlyBudget,
                                        (route) => false,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Usado',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.gray400,
                              ),
                            ),
                            Skeletonizer(
                              enabled: _isLoading,
                              effect: ShimmerEffect(baseColor: Colors.white10),
                              child: Selector<TransactionProvider, double>(
                                selector: (ctx, provider) =>
                                    provider.totalSpent,
                                builder: (ctx, totalSpent, child) {
                                  return Text(
                                    NumberFormat.simpleCurrency(
                                      locale: 'pt-BR',
                                      decimalDigits: 2,
                                    ).format(totalSpent),
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: AppColors.gray100,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Limite',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.gray400,
                              ),
                            ),
                            Skeletonizer(
                              enabled: _isLoading,
                              effect: ShimmerEffect(baseColor: Colors.white10),
                              child: _budget != null
                                  ? Text(
                                      NumberFormat.simpleCurrency(
                                        locale: 'pt-BR',
                                        decimalDigits: 2,
                                      ).format(_budget!.total),
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: AppColors.gray100,
                                      ),
                                    )
                                  : Icon(
                                      PhosphorIcons.infinity(),
                                      color: AppColors.gray200,
                                    ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Selector<TransactionProvider, double>(
                  selector: (ctx, provider) => provider.totalSpent,
                  builder: (ctx, totalSpent, child) {
                    return LinearProgressIndicator(
                      value: _budget == null
                          ? 0
                          : (totalSpent / _budget!.total),
                      color: AppColors.primary,
                      backgroundColor: AppColors.gray600,
                      minHeight: 8,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
