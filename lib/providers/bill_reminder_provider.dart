import 'package:flutter/foundation.dart';

import 'package:nummo/@types/recurrence_type.dart';
import 'package:nummo/data/models/bill_reminder.dart';
import 'package:nummo/@types/transaction_category.dart';
import 'package:nummo/services/local_notifications_service.dart';
import 'package:nummo/data/repositories/bill_reminder_repository.dart';

class BillReminderProvider with ChangeNotifier {
  final BillReminderRepository _repository;
  final LocalNotificationsService _notificationService;

  List<BillReminder> _billsReminders = [];

  BillReminderProvider(this._repository, this._notificationService);

  List<BillReminder> get billsReminders {
    return [..._billsReminders];
  }

  Future<void> createBillReminder({
    required String title,
    DateTime? dueDate,
    int? dayOfMonth,
    required RecurrenceType recurrenceType,
    required TransactionCategory category,
    String? notes,
    DateTime? createdAt,
  }) async {
    final newReminder = await _repository.createBillReminder(
      title: title,
      dueDate: dueDate,
      dayOfMonth: dayOfMonth,
      recurrenceType: recurrenceType,
      category: category,
      notes: notes,
      notificationId: DateTime.now().millisecondsSinceEpoch,
      createdAt: createdAt,
    );

    _billsReminders.add(newReminder);

    _notificationService.scheduleNotification(
      id: newReminder.id,
      title: newReminder.title,
      body: 'Lembrete de pagamento: ${newReminder.title}',
      dateTime: newReminder.recurrenceType == RecurrenceType.once
          ? DateTime(
              newReminder.dueDate!.year,
              newReminder.dueDate!.month,
              newReminder.dueDate!.day,
              9,
              0,
            )
          : DateTime(
              newReminder.createdAt.year,
              newReminder.createdAt.month,
              newReminder.dayOfMonth ?? 1,
              9,
              0,
            ),
      recurrenceType: newReminder.recurrenceType == RecurrenceType.once
          ? NotificationRecurrenceType.once
          : NotificationRecurrenceType.monthly,
    );

    notifyListeners();
  }

  Future<void> deleteBillReminder(int reminderId) async {
    await _notificationService.cancelNotification(reminderId);

    await _repository.deleteBillReminder(reminderId);

    _billsReminders.removeWhere((reminder) => reminder.id == reminderId);

    notifyListeners();
  }

  Future<void> loadBillsReminders() async {
    final billsReminders = await _repository.findMany();

    _billsReminders = billsReminders;

    notifyListeners();
  }
}
