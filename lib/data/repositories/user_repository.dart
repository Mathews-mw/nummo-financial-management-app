import 'package:drift/drift.dart';

import 'package:nummo/data/models/user.dart';
import 'package:nummo/core/database/app_database.dart';
import 'package:nummo/core/database/daos/user_dao.dart';
import 'package:nummo/utils/password_encryption.dart';

class UserRepository {
  final UserDao userDao;

  UserRepository({required this.userDao});

  Future<void> createUser({
    required String name,
    required String email,
    required String password,
    String? avatarUrl,
  }) async {
    await userDao.insertUser(
      UsersTableCompanion(
        name: Value(name),
        email: Value(email),
        password: Value(PasswordEncryption.hashPassword(password)),
        avatarUrl: Value(avatarUrl),
      ),
    );
  }

  Future<bool> updateUser(User user) async {
    final UsersTableCompanion data = UsersTableCompanion(
      id: Value(user.id),
      name: Value(user.name),
      email: Value(user.email),
      password: Value(user.password),
      avatarUrl: Value(user.avatarUrl),
    );

    return await userDao.updateUser(data);
  }

  Future<int> deleteUser(int id) async {
    return await userDao.deleteUser(id);
  }

  Future<List<User>> getUsers() async {
    final List<User> tmp = [];

    final usersData = await userDao.getUsers();

    return usersData.map((data) {
      return User(
        id: data.id,
        name: data.name,
        email: data.email,
        password: data.password,
        avatarUrl: data.avatarUrl,
      );
    }).toList();
  }

  Future<User> getUser(int id) async {
    final data = await userDao.getUniqueUser(id);

    return User(
      id: data.id,
      name: data.name,
      email: data.email,
      password: data.password,
      avatarUrl: data.avatarUrl,
    );
  }

  Future<User?> getUserByEmail(String email) async {
    final data = await userDao.getUserByEmail(email);

    if (data != null) {
      return User(
        id: data.id,
        name: data.name,
        email: data.email,
        password: data.password,
        avatarUrl: data.avatarUrl,
      );
    }
  }
}
