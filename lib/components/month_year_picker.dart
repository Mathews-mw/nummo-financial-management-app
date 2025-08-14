import 'package:flutter/material.dart';
import 'package:nummo/providers/theme_provider.dart';
import 'package:provider/provider.dart';

Future<({int month, int year})?> showCustomMonthYearPicker(
  BuildContext context,
) async {
  int? selectedYear = DateTime.now().year;
  int? selectedMonth = DateTime.now().month;

  // Lógica para gerar a lista de anos
  final int currentYear = DateTime.now().year;
  final int rangeYear = 10;
  final List<int> years = List.generate(
    rangeYear,
    (index) => currentYear - (rangeYear / 2).ceil() + index,
  );

  final List<String> months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];

  final DateTime? result = await showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      // Usamos StatefulBuilder para gerenciar o estado dentro do diálogo
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text(
              'Selecione Mês e Ano',
              style: TextStyle(fontSize: 18),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<int>(
                  hint: const Text('Mês'),
                  value: selectedMonth,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedMonth = newValue;
                    });
                  },
                  items: List.generate(12, (index) {
                    return DropdownMenuItem<int>(
                      value: index + 1, // Mês de 1 a 12
                      child: Text(months[index]),
                    );
                  }),
                ),
                const SizedBox(height: 10),
                DropdownButton<int>(
                  hint: const Text('Ano'),
                  value: selectedYear,
                  onChanged: (int? newValue) {
                    setState(() {
                      selectedYear = newValue;
                    });
                  },
                  items: years.map<DropdownMenuItem<int>>((int year) {
                    return DropdownMenuItem<int>(
                      value: year,
                      child: Text(year.toString()),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  if (selectedYear != null && selectedMonth != null) {
                    // Retorna a data quando o usuário confirma
                    Navigator.of(
                      context,
                    ).pop(DateTime(selectedYear!, selectedMonth!));
                  }
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    },
  );

  if (result != null) {
    return (month: result.month, year: result.year);
  }
}
