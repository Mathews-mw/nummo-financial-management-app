import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:nummo/theme/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class BudgetItemTile extends StatelessWidget {
  const BudgetItemTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: RichText(
        text: TextSpan(
          style: TextStyle(color: AppColors.gray700, fontSize: 16),
          children: <TextSpan>[
            TextSpan(
              text: 'Junho',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: '  2025',
              style: TextStyle(fontSize: 14, color: AppColors.gray500),
            ),
          ],
        ),
      ),
      leading: Icon(PhosphorIcons.calendarBlank()),
      trailing: Text(
        NumberFormat.simpleCurrency(
          locale: 'pt-BR',
          decimalDigits: 2,
        ).format(4200),
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColors.gray700,
        ),
      ),
    );
  }
}
