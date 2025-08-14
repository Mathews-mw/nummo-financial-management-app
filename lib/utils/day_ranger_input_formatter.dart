import 'package:flutter/services.dart';

// Este formatador garante que o valor numérico do texto esteja sempre
// dentro de um intervalo (min-max).
class DayRangerInputFormatter extends TextInputFormatter {
  final int min;
  final int max;

  DayRangerInputFormatter({required this.min, required this.max});

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // Se o novo valor está vazio, permite (o usuário está apagando)
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Tenta converter o novo texto para um número
    final int? newInt = int.tryParse(newValue.text);

    // Se a conversão falhar ou o número estiver fora do intervalo,
    // rejeita a mudança mantendo o valor antigo.
    if (newInt == null || newInt < min || newInt > max) {
      return oldValue;
    }

    // Se for válido, permite a mudança.
    return newValue;
  }
}
