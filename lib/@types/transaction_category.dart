enum TransactionCategory {
  alimentacao,
  cuidadosPessoais,
  despesasFixas,
  educacao,
  internet,
  investimentos,
  lazer,
  mercado,
  moradia,
  obrigacoesFinanceiras,
  renda,
  restaurante,
  saude,
  trabalho,
  transferencias,
  transporte,
  vestuario,
  outros;

  String get value {
    switch (this) {
      case mercado:
        return 'mercado';
      case restaurante:
        return 'restaurante';
      case transporte:
        return 'transporte';
      case saude:
        return 'saude';
      case educacao:
        return 'educacao';
      case lazer:
        return 'lazer';
      case vestuario:
        return 'vestuario';
      case moradia:
        return 'moradia';
      case despesasFixas:
        return 'despesasFixas';
      case internet:
        return 'internet';
      case cuidadosPessoais:
        return 'cuidadosPessoais';
      case obrigacoesFinanceiras:
        return 'obrigacoesFinanceiras';
      case trabalho:
        return 'trabalho';
      case renda:
        return 'renda';
      case investimentos:
        return 'investimentos';
      case transferencias:
        return 'transferencias';
      case alimentacao:
        return 'alimentacao';
      case outros:
        return 'outros';
    }
  }

  String get label {
    switch (this) {
      case mercado:
        return 'Mercado';
      case restaurante:
        return 'Restaurante';
      case transporte:
        return 'Transporte';
      case saude:
        return 'Saúde';
      case educacao:
        return 'Educação';
      case lazer:
        return 'Lazer e Entretenimento';
      case vestuario:
        return 'Vestuário';
      case moradia:
        return 'Moradia';
      case despesasFixas:
        return 'Despesas Fixas';
      case internet:
        return 'Internet';
      case cuidadosPessoais:
        return 'Cuidados Pessoais';
      case obrigacoesFinanceiras:
        return 'Obrigações Financeiras';
      case trabalho:
        return 'Trabalho';
      case renda:
        return 'Renda extra';
      case investimentos:
        return 'Investimentos';
      case transferencias:
        return 'Transferências';
      case alimentacao:
        return 'Alimentação';
      case outros:
        return 'Outros';
    }
  }
}
