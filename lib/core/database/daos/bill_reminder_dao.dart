import 'package:drift/drift.dart';

import '../app_database.dart';

part 'bill_reminder_dao.g.dart';

@DriftAccessor(tables: [BillRemindersTable])
class BillReminderDao extends DatabaseAccessor<AppDatabase>
    with _$BillReminderDaoMixin {
  BillReminderDao(super.db);

  Future<int> insertBillReminder(
    BillRemindersTableCompanion billReminder,
  ) async {
    return await into(billRemindersTable).insert(billReminder);
  }

  Future<bool> updateBillReminder(
    BillRemindersTableCompanion billReminder,
  ) async {
    return await update(billRemindersTable).replace(billReminder);
  }

  Future<int> deleteBillReminder(int id) async {
    return await (delete(
      billRemindersTable,
    )..where((row) => row.id.equals(id))).go();
  }

  Future<List<BillRemindersTableData>> findMany() async {
    final data =
        await (select(billRemindersTable)..orderBy([
              (row) => OrderingTerm(
                expression: row.createdAt,
                mode: OrderingMode.desc,
              ),
            ]))
            .get();

    return data;
  }

  Future<BillRemindersTableData?> getUnique(int id) async {
    final billReminder = await (select(
      billRemindersTable,
    )..where((row) => row.id.equals(id))).getSingleOrNull();

    return billReminder;
  }
}
