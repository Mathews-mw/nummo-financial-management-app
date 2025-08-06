import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nummo/@types/transaction_type.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:nummo/theme/app_colors.dart';
import 'package:nummo/providers/transaction_provider.dart';

class TransactionsList extends StatefulWidget {
  const TransactionsList({super.key});

  @override
  State<TransactionsList> createState() => _TransactionsListState();
}

class _TransactionsListState extends State<TransactionsList> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadTransactions();
    });
  }

  Future<void> loadTransactions() async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(Duration(seconds: 3));

      final transactionProvider = Provider.of<TransactionProvider>(
        context,
        listen: false,
      );

      await transactionProvider.loadTransactions();
    } catch (e) {
      print('Error loading transactions: $e');
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
                Divider(thickness: 0.2, color: AppColors.gray400),
                Expanded(
                  child: ListView.separated(
                    separatorBuilder: (_, _) =>
                        Divider(thickness: 0.2, color: AppColors.gray400),
                    itemCount: transactions.length,
                    itemBuilder: (ctx, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                      color: AppColors.gray200,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      PhosphorIcons.basket(),
                                      size: 20,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          transactions[index].title,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('dd/MM/yyyy').format(
                                            transactions[index].createdAt,
                                          ),
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.gray500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  NumberFormat.simpleCurrency(
                                    locale: 'pt-BR',
                                    decimalDigits: 2,
                                  ).format(transactions[index].value),
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Icon(
                                  transactions[index].type ==
                                          TransactionType.income
                                      ? PhosphorIconsFill.caretUp
                                      : PhosphorIconsFill.caretDown,
                                  size: 14,
                                  color:
                                      transactions[index].type ==
                                          TransactionType.income
                                      ? Colors.greenAccent
                                      : AppColors.danger,
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: Icon(PhosphorIcons.trash(), size: 20),
                                ),
                              ],
                            ),
                          ],
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
