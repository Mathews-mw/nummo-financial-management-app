import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import 'package:nummo/theme/app_colors.dart';
import 'package:nummo/@types/recurrence_type.dart';
import 'package:nummo/components/custom_button.dart';
import 'package:nummo/@types/transaction_category.dart';
import 'package:nummo/components/custom_text_field.dart';
import 'package:nummo/@mixins/form_validations_mixin.dart';
import 'package:nummo/providers/bill_reminder_provider.dart';
import 'package:nummo/utils/day_ranger_input_formatter.dart';
import 'package:nummo/components/custom_dropdown_button.dart';

class AddBills extends StatefulWidget {
  const AddBills({super.key});

  @override
  State<AddBills> createState() => _AddBillsState();
}

class _AddBillsState extends State<AddBills> with FormValidationsMixin {
  bool _isLoading = false;
  bool _isRepeat = true;
  DateTime? _selectedDate;
  TransactionCategory? _dropdownValue;

  late TextEditingController _dayController;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, Object> _formData = <String, Object>{};
  final FocusNode _dayFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _dayController = TextEditingController();

    // Adiciona um "listener" para saber quando o campo perde o foco
    _dayFocusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _dayFocusNode.removeListener(_onFocusChange);
    _dayFocusNode.dispose();
    _dayController.dispose();
    super.dispose();
  }

  // Função chamada quando o foco muda
  void _onFocusChange() {
    // Se o campo não está mais em foco e tem algum texto
    if (!_dayFocusNode.hasFocus && _dayController.text.isNotEmpty) {
      final text = _dayController.text;
      // Adiciona o "0" à esquerda se for um único dígito
      final formattedText = text.padLeft(2, '0');

      // Atualiza o texto no controller
      // Usamos 'addPostFrameCallback' para evitar erros de build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _dayController.text = formattedText;
      });
    }
  }

  Future<DateTime?> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      locale: const Locale('pt', 'BR'),
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 10),
    );

    return pickedDate;
  }

  Future<void> _handleCreateBillReminder() async {
    setState(() => _isLoading = true);

    final bool isValidForm = _formKey.currentState?.validate() ?? false;

    if (!isValidForm || _dropdownValue == null) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Por favor, preencha os campos!')));

      return;
    }

    _formKey.currentState?.save();

    try {
      final billReminderProvider = Provider.of<BillReminderProvider>(
        context,
        listen: false,
      );

      final int? dayOfMonthValue = _formData['dayOfMonth'] != null
          ? int.tryParse(_formData['dayOfMonth'] as String)
          : null;

      await billReminderProvider.createBillReminder(
        title: _formData['title'] as String,
        dueDate: _selectedDate,
        dayOfMonth: dayOfMonthValue,
        recurrenceType: _isRepeat
            ? RecurrenceType.monthly
            : RecurrenceType.once,
        category: _dropdownValue!,
      );

      _formData.clear();
      _formKey.currentState!.reset();
      _dropdownValue = null;
      _selectedDate = null;

      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Lembrete criado com sucesso!')));

        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Erro create bill reminder: $e');

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
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet<void>(
          useSafeArea: true,
          showDragHandle: true,
          isScrollControlled: true,
          backgroundColor: Colors.white,
          context: context,
          builder: (ctx) {
            return StatefulBuilder(
              builder: (context, setModalState) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: 32,
                    right: 32,
                    bottom: MediaQuery.of(context).viewInsets.bottom + 32,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'ADICIONAR LEMBRETE DE PAGAMENTO',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                _formData.clear();
                                _formKey.currentState!.reset();
                                _dropdownValue = null;
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
                                hintText: 'Título do lembrete',
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
                                items: TransactionCategory.values.map((item) {
                                  return DropdownMenuItem(
                                    value: item,
                                    child: Text(item.label),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setModalState(() => _dropdownValue = value);
                                },
                                onSaved: (value) {
                                  _formData['category'] = value ?? '';
                                },
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Switch(
                                    value: _isRepeat,
                                    activeColor: AppColors.primary,
                                    onChanged: (bool value) {
                                      setModalState(() {
                                        _isRepeat = value;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 5),
                                  const Text(
                                    'Lembrete recorrente?',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              _isRepeat
                                  ? CustomTextField(
                                      controller: _dayController,
                                      focusNode: _dayFocusNode,
                                      hintText: 'Informe o dia',
                                      prefixIcon: Icon(
                                        PhosphorIcons.calendar(),
                                      ),
                                      textInputAction: TextInputAction.next,
                                      keyboardType: TextInputType.number,
                                      validator: isNotEmpty,
                                      inputFormatters: [
                                        // 1. Permite apenas dígitos
                                        FilteringTextInputFormatter.digitsOnly,
                                        // 2. Limita o comprimento a 2 caracteres
                                        LengthLimitingTextInputFormatter(2),
                                        // 3. Nosso formatador customizado para o intervalo 1-31
                                        DayRangerInputFormatter(
                                          min: 1,
                                          max: 31,
                                        ),
                                      ],
                                      onSaved: (value) {
                                        _formData['dayOfMonth'] = value ?? '';
                                      },
                                    )
                                  : GestureDetector(
                                      onTap: () async {
                                        final selectedDate =
                                            await _selectDate();

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
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
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
                                                  ? DateFormat(
                                                      'dd/MM/y',
                                                      'pt-BR',
                                                    ).format(_selectedDate!)
                                                  : '00/00/0000',
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
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Expanded(
                                    child: CustomButton(
                                      label: 'Salvar',
                                      isLoading: _isLoading,
                                      disabled: _isLoading,
                                      onPressed: _handleCreateBillReminder,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(PhosphorIcons.info()),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: const Text(
                                      'Ao selecionar como conta recorrente, o lembrete será automaticamente renovado a cada mês. Caso contrário, o lembrete será feito uma única vez para a data especificada.',
                                      softWrap: true,
                                      textAlign: TextAlign.justify,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
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
    );
  }
}
