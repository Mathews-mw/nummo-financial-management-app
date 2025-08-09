import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

import 'package:nummo/theme/app_colors.dart';
import 'package:nummo/components/custom_button.dart';
import 'package:nummo/providers/budget_provider.dart';
import 'package:nummo/components/custom_text_field.dart';
import 'package:nummo/components/month_year_picker.dart';
import 'package:nummo/utils/currency_format_remover.dart';
import 'package:nummo/@mixins/form_validations_mixin.dart';

class CreateNewBudgetCard extends StatefulWidget {
  const CreateNewBudgetCard({super.key});

  @override
  State<CreateNewBudgetCard> createState() => _CreateNewBudgetCardState();
}

class _CreateNewBudgetCardState extends State<CreateNewBudgetCard>
    with FormValidationsMixin {
  bool _isLoading = false;
  ({int month, int year})? _selectedDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, Object> _formData = <String, Object>{};

  Future<void> _handleCreateBudget() async {
    setState(() => _isLoading = true);

    final bool isValidForm = _formKey.currentState?.validate() ?? false;

    if (!isValidForm || _selectedDate == null) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Por favor, preencha os campos!')));

      return;
    }

    _formKey.currentState?.save();

    try {
      final budgetProvider = Provider.of<BudgetProvider>(
        context,
        listen: false,
      );

      await budgetProvider.createBudget(
        total: CurrencyFormatRemover.parseBrl(_formData['total'] as String),
        period: DateTime(_selectedDate!.year, _selectedDate!.month),
      );

      _formData.clear();
      _formKey.currentState!.reset();
      _selectedDate = null;

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Orçamento criado com sucesso!')),
        );
      }
    } catch (e) {
      print('Erro create budget: $e');

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ops! Parece que aconteceu algum erro durante o processo...',
            ),
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Text(
              'NOVO ORÇAMENTO',
              style: TextStyle(color: AppColors.gray500, fontSize: 12),
            ),
          ),
          Divider(color: AppColors.gray400, thickness: 0.2, height: 0),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Row(
                    children: [
                      StatefulBuilder(
                        builder: (context, setModalState) {
                          return Expanded(
                            child: GestureDetector(
                              onTap: () async {
                                final selectedDate =
                                    await showCustomMonthYearPicker(context);

                                setModalState(
                                  () => _selectedDate = selectedDate,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 20,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.gray200,
                                  borderRadius: BorderRadius.circular(8),
                                  border: BoxBorder.all(
                                    color: AppColors.gray300,
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(PhosphorIcons.calendarDots()),
                                    const SizedBox(width: 10),
                                    Text(
                                      _selectedDate != null
                                          ? DateFormat('MM/y', 'pt-BR').format(
                                              DateTime(
                                                _selectedDate!.year,
                                                _selectedDate!.month,
                                              ),
                                            )
                                          : '00/0000',
                                      style: TextStyle(
                                        color: _selectedDate != null
                                            ? AppColors.gray700
                                            : AppColors.gray400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomTextField(
                          hintText: 'R\$ 0,00',
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            CurrencyTextInputFormatter.currency(
                              locale: 'pt-BR',
                              decimalDigits: 2,
                              symbol: 'R\$',
                            ),
                          ],
                          textInputAction: TextInputAction.next,
                          validator: isNotEmpty,
                          onSaved: (value) {
                            _formData['total'] = value ?? '';
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          label: 'Adicionar',
                          isLoading: _isLoading,
                          disabled: _isLoading,
                          onPressed: _handleCreateBudget,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
