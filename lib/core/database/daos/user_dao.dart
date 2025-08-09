import 'package:drift/drift.dart';

import '../app_database.dart';

part 'user_dao.g.dart';

@DriftAccessor(tables: [UsersTable])
class UserDao extends DatabaseAccessor<AppDatabase> with _$UserDaoMixin {
  UserDao(super.db);

  Future<int> insertUser(UsersTableCompanion user) async {
    return await into(usersTable).insert(user);
  }

  Future<bool> updateUser(UsersTableCompanion user) async {
    return await update(usersTable).replace(user);
  }

  Future<int> deleteUser(int id) async {
    // o `go()` é equivalente a um commit no banco de dados;
    return await (delete(usersTable)..where((row) => row.id.equals(id))).go();
  }

  Future<List<UsersTableData>> getUsers() async {
    final data = await select(usersTable).get();

    return data;
  }

  Future<UsersTableData> getUniqueUser(int id) async {
    final user = await (select(
      usersTable,
    )..where((row) => row.id.equals(id))).getSingle();

    return user;
  }

  Future<UsersTableData?> getUserByEmail(String email) async {
    final user = await (select(
      usersTable,
    )..where((row) => row.email.equals(email))).getSingleOrNull();

    return user;
  }
}
