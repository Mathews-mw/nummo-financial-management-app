import 'dart:io';
import 'dart:async';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'package:nummo/@types/recurrence_type.dart';
import 'package:nummo/@types/transaction_type.dart';
import 'package:nummo/core/database/daos/user_dao.dart';
import 'package:nummo/@types/transaction_category.dart';
import 'package:nummo/core/database/daos/budget_dao.dart';
import 'package:nummo/core/database/daos/transaction_dao.dart';
import 'package:nummo/core/database/daos/bill_reminder_dao.dart';

part 'app_database.g.dart'; // Arquivo gerado automaticamente pelo build_runner

class UsersTable extends Table {
  IntColumn get id => integer().named("id").autoIncrement()();
  TextColumn get name => text().named("name").withLength(min: 1, max: 50)();
  TextColumn get email => text().named('email').customConstraint('UNIQUE')();
  TextColumn get password =>
      text().named('password').withLength(min: 6, max: 100)();
  TextColumn get avatarUrl => text().named('avatar_url').nullable()();
}

class BudgetsTable extends Table {
  IntColumn get id => integer().named("id").autoIncrement()();
  RealColumn get total => real().named("total")();
  DateTimeColumn get period =>
      dateTime().named("period").customConstraint('UNIQUE')();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).named('created_at')();
}

class TransactionsTable extends Table {
  IntColumn get id => integer().named("id").autoIncrement()();
  IntColumn get budgetId => integer()
      .named("budget_id")
      .references(
        BudgetsTable,
        #id,
        onUpdate: KeyAction.cascade,
        onDelete: KeyAction.cascade,
      )();
  TextColumn get title => text().named("title").withLength(min: 1, max: 50)();
  RealColumn get value => real().named("value")();
  TextColumn get type => textEnum<TransactionType>().named("type")();
  TextColumn get category => textEnum<TransactionCategory>()
      .named("category")
      .clientDefault(() => TransactionCategory.outros.value)();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();
}

class BillRemindersTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  DateTimeColumn get dueDate => dateTime().nullable().named('due_date')();
  IntColumn get dayOfMonth => integer().nullable().named('day_of_month')();
  TextColumn get recurrenceType =>
      textEnum<RecurrenceType>().named('recurrence_type')();
  TextColumn get category => textEnum<TransactionCategory>()();
  TextColumn get notes => text().nullable()();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true)).named('is_active')();
  IntColumn get notificationId => integer().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime).named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at').nullable()();
}

@DriftDatabase(
  tables: [UsersTable, BudgetsTable, TransactionsTable, BillRemindersTable],
  daos: [UserDao, BudgetDao, TransactionDao, BillReminderDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 17;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
    onUpgrade: (m, from, to) async {
      // SOMENTE EM DEV: dropa e recria todas as tabelas a cada atualização do schema
      final tables = allTables.map((t) => t.actualTableName).toList();

      for (final table in tables) {
        await customStatement('DROP TABLE IF EXISTS $table');
      }

      await m.createAll();
    },
  );
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    // Also work around limitations on old Android versions
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    return NativeDatabase.createInBackground(
      file,
    ).interceptWith(LogInterceptor());
  });
}

class LogInterceptor extends QueryInterceptor {
  Future<T> _run<T>(
    String description,
    FutureOr<T> Function() operation,
  ) async {
    final stopwatch = Stopwatch()..start();
    print('Running $description');

    try {
      final result = await operation();
      print(' => succeeded after ${stopwatch.elapsedMilliseconds}ms');
      return result;
    } on Object catch (e) {
      print(' => failed after ${stopwatch.elapsedMilliseconds}ms ($e)');
      rethrow;
    }
  }

  @override
  TransactionExecutor beginTransaction(QueryExecutor parent) {
    print('begin');
    return super.beginTransaction(parent);
  }

  @override
  Future<void> commitTransaction(TransactionExecutor inner) {
    return _run('commit', () => inner.send());
  }

  @override
  Future<void> rollbackTransaction(TransactionExecutor inner) {
    return _run('rollback', () => inner.rollback());
  }

  @override
  Future<void> runBatched(
    QueryExecutor executor,
    BatchedStatements statements,
  ) {
    return _run(
      'batch with $statements',
      () => executor.runBatched(statements),
    );
  }

  @override
  Future<int> runInsert(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    return _run(
      '$statement with $args',
      () => executor.runInsert(statement, args),
    );
  }

  @override
  Future<int> runUpdate(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    return _run(
      '$statement with $args',
      () => executor.runUpdate(statement, args),
    );
  }

  @override
  Future<int> runDelete(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    return _run(
      '$statement with $args',
      () => executor.runDelete(statement, args),
    );
  }

  @override
  Future<void> runCustom(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    return _run(
      '$statement with $args',
      () => executor.runCustom(statement, args),
    );
  }

  @override
  Future<List<Map<String, Object?>>> runSelect(
    QueryExecutor executor,
    String statement,
    List<Object?> args,
  ) {
    return _run(
      '$statement with $args',
      () => executor.runSelect(statement, args),
    );
  }
}
