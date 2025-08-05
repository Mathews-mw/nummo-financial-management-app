import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:nummo/theme/app_colors.dart';

class BudgetCard extends StatelessWidget {
  const BudgetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          decoration: BoxDecoration(
            color: const Color(0xFF0F0F0F),
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
                        RichText(
                          text: TextSpan(
                            style: TextStyle(
                              color: AppColors.foreground,
                              fontSize: 16,
                            ),
                            children: <TextSpan>[
                              const TextSpan(
                                text: 'MAIO ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              TextSpan(
                                text: '/ 2025',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.gray400,
                                ),
                              ),
                            ],
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
                    Text(
                      'R\$ 1.256.98',
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.bold,
                        color: AppColors.foreground,
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
                            Text(
                              NumberFormat.simpleCurrency(
                                locale: 'pt-BR',
                                decimalDigits: 2,
                              ).format(2943.02),
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.gray200,
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
                            Text(
                              NumberFormat.simpleCurrency(
                                locale: 'pt-BR',
                                decimalDigits: 2,
                              ).format(4200),
                              style: TextStyle(
                                fontSize: 16,
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
                child: LinearProgressIndicator(
                  value: (2943.02 / 4200),
                  color: AppColors.primary,
                  backgroundColor: AppColors.gray600,
                  minHeight: 8,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: double.infinity,
          height: 220,
          decoration: BoxDecoration(
            color: const Color.fromRGBO(45, 45, 45, 0.5),
            backgroundBlendMode: BlendMode.lighten,
          ),
        ),
      ],
    );
  }
}
