import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:nummo/theme/app_colors.dart';
import 'package:nummo/providers/transaction_provider.dart';
import 'package:nummo/ui/screens/home/transaction_item_tile.dart';

class TransactionsList extends StatefulWidget {
  final int year;
  final int month;

  const TransactionsList({super.key, required this.month, required this.year});

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadTransactions(month: widget.month, year: widget.year);
    });
  }

  @override
  void didUpdateWidget(TransactionsList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.month != oldWidget.month) {
      loadTransactions(month: widget.month, year: widget.year);
    }
  }

  Future<void> loadTransactions({required int month, required int year}) async {
    setState(() => _isLoading = true);

    try {
      final transactionProvider = Provider.of<TransactionProvider>(
        context,
        listen: false,
      );

      await transactionProvider.loadTransactions(month: month, year: year);
    } catch (e) {
      print('Error loading transactions: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> deleteTransaction(int transactionId) async {
    setState(() => _isLoading = true);

    try {
      final transactionProvider = Provider.of<TransactionProvider>(
        context,
        listen: false,
      );

      await transactionProvider.deleteTransaction(transactionId);
    } catch (e) {
      print('Error delete transactions: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TransactionProvider>(
      builder: (ctx, transactionProvider, child) {
        final transactions = transactionProvider.transactions;

        if (_isLoading) {
          return Center(
            child: Column(
              children: [
                CircularProgressIndicator(),
                const SizedBox(height: 10),
                Text('Carregando transações...'),
              ],
            ),
          );
        }

        return Expanded(
          child: Card(
            color: Colors.white,
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
                        'LANÇAMENTOS',
                        style: TextStyle(
                          color: AppColors.gray500,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.gray200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          transactions.length.toString(),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(thickness: 0.2, color: AppColors.gray400, height: 0),
                if (transactions.isEmpty)
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
                            'Você ainda não registrou despesas ou receitas neste mês.',
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
                    itemCount: transactions.length,
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
                                          await deleteTransaction(
                                            transactions[index].id,
                                          );

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
                        child: TransactionItemTile(
                          transaction: transactions[index],
                        ),
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
