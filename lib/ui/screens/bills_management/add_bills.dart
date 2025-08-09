import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nummo/@mixins/form_validations_mixin.dart';
import 'package:nummo/components/custom_text_field.dart';
import 'package:nummo/theme/app_colors.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class AddBills extends StatefulWidget {
  const AddBills({super.key});

  @override
  State<AddBills> createState() => _AddBillsState();
}

class _AddBillsState extends State<AddBills> with FormValidationsMixin {
  bool repeat = true;
  DateTime? _selectedDate;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, Object> _formData = <String, Object>{};

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

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () {
        showModalBottomSheet<void>(
          showDragHandle: true,
          backgroundColor: Colors.white,
          isScrollControlled: true,
          useSafeArea: true,
          context: context,
          builder: (ctx) {
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
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'ADICIONAR LEMBRETE DE PAGAMENTO',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                // _formData.clear();
                                // _dropdownValue = null;
                                // _moneyFlow = null;
                                // _selectedDate = null;
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
                              Row(
                                children: [
                                  Switch(
                                    value: repeat,
                                    activeColor: AppColors.primary,
                                    onChanged: (bool value) {
                                      setModalState(() {
                                        repeat = value;
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
                              GestureDetector(
                                onTap: () async {
                                  final selectedDate = await _selectDate();

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
