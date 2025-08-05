import 'package:nummo/@types/transaction_type.dart';
import 'package:nummo/@types/transaction_category.dart';

class Transaction {
  final int id;
  final String title;
  final double value;
  final TransactionType type;
  final TransactionCategory category;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const Transaction({
    required this.id,
    required this.title,
    required this.value,
    required this.type,
    required this.category,
    required this.createdAt,
    this.updatedAt,
  });

  set id(int id) {
    this.id = id;
  }

  set title(String title) {
    this.title = title;
  }

  set value(double value) {
    this.value = value;
  }

  set type(TransactionType type) {
    this.type = type;
  }

  set category(TransactionCategory category) {
    this.category = category;
  }

  set createdAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  set updatedAt(DateTime? updatedAt) {
    this.updatedAt = updatedAt;
  }

  factory Transaction.fromJson(Map<String, dynamic> json) {
    final user = Transaction(
      id: json['id'],
      title: json['title'],
      value: double.parse(json['value']),
      type: TransactionType.values.firstWhere(
        (e) => e.value == json['type'],
        orElse: () => TransactionType.income,
      ),
      category: TransactionCategory.values.firstWhere(
        (e) => e.value == json['category'],
        orElse: () => TransactionCategory.outros,
      ),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: json['replied_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );

    return user;
  }

  @override
  String toString() {
    return 'User(id: $id, title: $title, value: $value, type: $type,  category: $category, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
