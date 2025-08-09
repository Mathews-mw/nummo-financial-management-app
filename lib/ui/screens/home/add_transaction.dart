import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:nummo/theme/app_colors.dart';
import 'package:nummo/@types/transaction_type.dart';
import 'package:nummo/components/custom_button.dart';
import 'package:nummo/@types/transaction_category.dart';
import 'package:nummo/utils/currency_format_remover.dart';
import 'package:nummo/components/custom_text_field.dart';
import 'package:nummo/providers/transaction_provider.dart';
import 'package:nummo/@mixins/form_validations_mixin.dart';
import 'package:nummo/components/custom_dropdown_button.dart';
import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';

class AddTransaction extends StatefulWidget {
  final int? budgetId;
  final int year;
  final int month;

  const AddTransaction({
    super.key,
    this.budgetId,
    required this.year,
    required this.month,
  });

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction>
    with FormValidationsMixin {
  bool _isLoading = false;
  TransactionType? _moneyFlow;
  TransactionCategory? _dropdownValue;
  DateTime? _selectedDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, Object> _formData = <String, Object>{};

  Future<DateTime?> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: DateTime.now().month == widget.month ? DateTime.now() : null,
      firstDate: DateTime(widget.year, widget.month),
      lastDate: DateTime(widget.year, widget.month + 1, 0),
    );

    return pickedDate;
  }

  Future<void> _handleRegisterTransaction() async {
    setState(() => _isLoading = true);

    final bool isValidForm = _formKey.currentState?.validate() ?? false;

    if (!isValidForm ||
        _moneyFlow == null ||
        _selectedDate == null ||
        _dropdownValue == null) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, verifique os campos do formulário.'),
        ),
      );

      return;
    }

    _formKey.currentState?.save();

    try {
      final transactionProvider = Provider.of<TransactionProvider>(
        context,
        listen: false,
      );

      if (widget.budgetId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Não existe um orçamento para esse mês para inserir lançamentos. Por favor, crie um orçamento.',
            ),
          ),
        );

        return;
      }

      await transactionProvider.createTransaction(
        budgetId: widget.budgetId!,
        title: _formData['title'] as String,
        value: CurrencyFormatRemover.parseBrl(_formData['value'] as String),
        type: _moneyFlow!,
        category: _dropdownValue!,
        createdAt: _selectedDate,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Transação cadastrada com sucesso!')),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Erro while try to create a new transaction: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ops! Parece que aconteceu algum erro durante o processo...',
            ),
          ),
        );

        Navigator.of(context).pop();
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final disabledButton = widget.budgetId == null;

    return FloatingActionButton(
      backgroundColor: disabledButton ? AppColors.gray400 : AppColors.gray700,
      disabledElevation: disabledButton ? 0 : 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(99)),
      splashColor: Colors.black.withAlpha(255),

      onPressed: disabledButton
          ? null
          : () {
              showModalBottomSheet<void>(
                showDragHandle: true,
                backgroundColor: Colors.white,
                isScrollControlled: true,
                useSafeArea: true,
                context: context,
                builder: (BuildContext context) {
                  return StatefulBuilder(
                    builder: (context, setModalState) {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 32,
                            right: 32,
                            bottom: 32,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'NOVO LANÇAMENTO',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      _formData.clear();
                                      _dropdownValue = null;
                                      _moneyFlow = null;
                                      _selectedDate = null;
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    CustomTextField(
                                      hintText: 'Título da transação',
                                      textInputAction: TextInputAction.next,
                                      validator: isNotEmpty,
                                      onSaved: (value) {
                                        _formData['title'] = value ?? '';
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    CustomDropdownButton(
                                      hintText: 'Categoria',
                                      prefixIcon: Icon(PhosphorIcons.tag()),
                                      validator: isNotEmpty,
                                      value: _dropdownValue,
                                      items: TransactionCategory.values.map((
                                        item,
                                      ) {
                                        return DropdownMenuItem(
                                          value: item,
                                          child: Text(item.label),
                                        );
                                      }).toList(),
                                      onChanged: (value) {
                                        setModalState(
                                          () => _dropdownValue = value,
                                        );
                                      },
                                      onSaved: (value) {
                                        _formData['category'] = value ?? '';
                                      },
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
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
                                            textInputAction:
                                                TextInputAction.next,
                                            validator: isNotEmpty,
                                            onSaved: (value) {
                                              _formData['value'] = value ?? '';
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () async {
                                              final selectedDate =
                                                  await _selectDate();

                                              setModalState(
                                                () => _selectedDate =
                                                    selectedDate,
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: AppColors.gray200,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: BoxBorder.all(
                                                  color: AppColors.gray300,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    PhosphorIcons.calendarDots(),
                                                  ),
                                                  const SizedBox(width: 10),
                                                  Text(
                                                    _selectedDate != null
                                                        ? DateFormat(
                                                            'dd/MM/y',
                                                            'pt-BR',
                                                          ).format(
                                                            _selectedDate!,
                                                          )
                                                        : '00/00/0000',
                                                    style: TextStyle(
                                                      color:
                                                          _selectedDate != null
                                                          ? AppColors.gray700
                                                          : AppColors.gray400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              setModalState(
                                                () => _moneyFlow =
                                                    TransactionType.income,
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    _moneyFlow ==
                                                        TransactionType.income
                                                    ? Colors.green.shade50
                                                    : AppColors.gray200,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: BoxBorder.all(
                                                  color:
                                                      _moneyFlow ==
                                                          TransactionType.income
                                                      ? Colors.green
                                                      : AppColors.gray300,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Entrada',
                                                    style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Icon(
                                                    PhosphorIconsFill.caretUp,
                                                    color: Colors.green,
                                                    size: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              setModalState(
                                                () => _moneyFlow =
                                                    TransactionType.outcome,
                                              );
                                            },
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 10,
                                                    horizontal: 20,
                                                  ),
                                              decoration: BoxDecoration(
                                                color:
                                                    _moneyFlow ==
                                                        TransactionType.outcome
                                                    ? Colors.red.shade50
                                                    : AppColors.gray200,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                border: BoxBorder.all(
                                                  color:
                                                      _moneyFlow ==
                                                          TransactionType
                                                              .outcome
                                                      ? Colors.redAccent
                                                      : AppColors.gray300,
                                                  width: 1,
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    'Saída',
                                                    style: TextStyle(
                                                      color: Colors.redAccent,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  Icon(
                                                    PhosphorIconsFill.caretDown,
                                                    color: Colors.redAccent,
                                                    size: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Divider(),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      label: 'Salvar',
                                      isLoading: _isLoading,
                                      disabled:
                                          _moneyFlow == null ||
                                          _selectedDate == null ||
                                          _dropdownValue == null ||
                                          _isLoading,
                                      onPressed: _handleRegisterTransaction,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
      child: Icon(
        Icons.add,
        color: disabledButton ? AppColors.gray500 : AppColors.foreground,
      ),
    );
  }
}
