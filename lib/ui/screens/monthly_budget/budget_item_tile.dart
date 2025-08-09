import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nummo/data/models/budget.dart';
import 'package:nummo/theme/app_colors.dart';
import 'package:nummo/utils/capitalizer.dart';
import 'package:nummo/utils/is_after_current_month.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BudgetItemTile extends StatelessWidget {
  final Budget budget;

  const BudgetItemTile({super.key, required this.budget});

  @override
  Widget build(BuildContext context) {
    final bool isPast = !IsAfterCurrentMonth.compare(budget.period);

    return ListTile(
      title: RichText(
        text: TextSpan(
          style: TextStyle(color: AppColors.gray700, fontSize: 16),
          children: <TextSpan>[
            TextSpan(
              text: Capitalizer.capitalize(
                DateFormat('MMMM', 'pt-BR').format(budget.period),
              ),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: isPast == true ? AppColors.gray400 : AppColors.gray700,
              ),
            ),
            TextSpan(
              text: '  ${DateFormat('y').format(budget.period)}',
              style: TextStyle(
                fontSize: 14,
                color: isPast == true ? AppColors.gray400 : AppColors.gray500,
              ),
            ),
          ],
        ),
      ),
      leading: Icon(
        PhosphorIcons.calendarBlank(),
        color: isPast == true ? AppColors.gray400 : AppColors.gray700,
      ),
      trailing: Text(
        NumberFormat.simpleCurrency(
          locale: 'pt-BR',
          decimalDigits: 2,
        ).format(budget.total),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isPast == true ? AppColors.gray400 : AppColors.gray700,
        ),
      ),
    );
  }
}
