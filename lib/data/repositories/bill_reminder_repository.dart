import 'package:drift/drift.dart';
import 'package:nummo/@types/recurrence_type.dart';

import 'package:nummo/data/models/bill_reminder.dart';
import 'package:nummo/core/database/app_database.dart';
import 'package:nummo/@types/transaction_category.dart';
import 'package:nummo/core/database/daos/bill_reminder_dao.dart';

class BillReminderRepository {
  final BillReminderDao billReminderDao;

  BillReminderRepository({required this.billReminderDao});

  Future<BillReminder> createBillReminder({
    required String title,
    DateTime? dueDate,
    int? dayOfMonth,
    required RecurrenceType recurrenceType,
    required TransactionCategory category,
    String? notes,
    int? notificationId,
    DateTime? createdAt,
  }) async {
    final result = await billReminderDao.insertBillReminder(
      BillRemindersTableCompanion(
        title: Value(title),
        dueDate: Value(dueDate),
        dayOfMonth: Value(dayOfMonth),
        recurrenceType: Value(recurrenceType),
        category: Value(category),
        notes: Value(notes),
        notificationId: Value(notificationId),
        isActive: Value(true),
        createdAt: createdAt != null ? Value(createdAt) : Value(DateTime.now()),
      ),
    );

    final newBillReminder = BillReminder(
      id: result,
      title: title,
      dueDate: dueDate,
      dayOfMonth: dayOfMonth,
      recurrenceType: recurrenceType,
      category: category,
      notes: notes,
      notificationId: notificationId,
      isActive: true,
      createdAt: createdAt ?? DateTime.now(),
    );

    return newBillReminder;
  }

  Future<bool> updateBillReminder(BillReminder billReminder) async {
    final BillRemindersTableCompanion data = BillRemindersTableCompanion(
      id: Value(billReminder.id),
      title: Value(billReminder.title),
      dueDate: Value(billReminder.dueDate),
      dayOfMonth: Value(billReminder.dayOfMonth),
      recurrenceType: Value(billReminder.recurrenceType),
      category: Value(billReminder.category),
      notes: Value(billReminder.notes),
      notificationId: Value(billReminder.notificationId),
      isActive: Value(billReminder.isActive),
      createdAt: Value(billReminder.createdAt),
      updatedAt: Value(DateTime.now()),
    );

    return await billReminderDao.updateBillReminder(data);
  }

  Future<int> deleteBillReminder(int id) async {
    return await billReminderDao.deleteBillReminder(id);
  }

  Future<List<BillReminder>> findMany() async {
    final billRemindersData = await billReminderDao.findMany();

    return billRemindersData.map((data) {
      return BillReminder(
        id: data.id,
        title: data.title,
        dueDate: data.dueDate,
        dayOfMonth: data.dayOfMonth,
        recurrenceType: data.recurrenceType,
        category: data.category,
        notes: data.notes,
        notificationId: data.notificationId,
        isActive: true,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
      );
    }).toList();
  }
}
