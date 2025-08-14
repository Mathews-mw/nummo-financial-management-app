import 'package:nummo/@types/recurrence_type.dart';
import 'package:nummo/@types/transaction_category.dart';

class BillReminder {
  final int id;
  final String title;
  final DateTime? dueDate;
  final int? dayOfMonth;
  final RecurrenceType recurrenceType;
  final TransactionCategory category;
  final String? notes;
  final bool isActive;
  final int? notificationId;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const BillReminder({
    required this.id,
    required this.title,
    this.dueDate,
    this.dayOfMonth,
    required this.recurrenceType,
    required this.category,
    this.notes,
    required this.isActive,
    this.notificationId,
    required this.createdAt,
    this.updatedAt,
  });

  set id(int id) {
    this.id = id;
  }

  set title(String title) {
    this.title = title;
  }

  set dueDate(DateTime? dueDate) {
    this.dueDate = dueDate;
  }

  set dayOfMonth(int? dayOfMonth) {
    this.dayOfMonth = dayOfMonth;
  }

  set recurrenceType(RecurrenceType recurrenceType) {
    this.recurrenceType = recurrenceType;
  }

  set category(TransactionCategory category) {
    this.category = category;
  }

  set notes(String? notes) {
    this.notes = notes;
  }

  set notificationId(int? notificationId) {
    this.notificationId = notificationId;
  }

  set isActive(bool isActive) {
    this.isActive = isActive;
  }

  set createdAt(DateTime createdAt) {
    this.createdAt = createdAt;
  }

  set updatedAt(DateTime? updatedAt) {
    this.updatedAt = updatedAt;
  }

  @override
  String toString() {
    return 'User(id: $id, title: $title, dueDate: $dueDate, dayOfMonth: $dayOfMonth, recurrenceType: $recurrenceType, category: $category, notes: $notes, notificationId: $notificationId, isActive: $isActive, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
