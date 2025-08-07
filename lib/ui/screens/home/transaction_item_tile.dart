import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:nummo/theme/app_colors.dart';
import 'package:nummo/data/models/transaction.dart';
import 'package:nummo/@types/transaction_type.dart';

class TransactionItemTile extends StatelessWidget {
  final Transaction transaction;

  const TransactionItemTile({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        transaction.title,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy').format(transaction.createdAt),
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
                ).format(transaction.value),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Icon(
                transaction.type == TransactionType.income
                    ? PhosphorIconsFill.caretUp
                    : PhosphorIconsFill.caretDown,
                size: 14,
                color: transaction.type == TransactionType.income
                    ? Colors.greenAccent
                    : AppColors.danger,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
