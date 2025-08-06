import 'dart:convert';
import 'package:flutter/material.dart';

import 'package:nummo/data/models/user.dart';
import 'package:nummo/utils/password_encryption.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nummo/data/repositories/user_repository.dart';
import 'package:nummo/@exceptions/invalid_credentials_exception.dart';

class UserProvider with ChangeNotifier {
  final UserRepository repository;

  static const String _userKey = "user_data";

  User? _user;

  UserProvider(this.repository);

  User? get user {
    return _user;
  }

  bool get isAuthenticated {
    return _user != null;
  }

  Future<void> _saveUserToLocalStorage(User user) async {
    final prefs = await SharedPreferences.getInstance();

    final userJson = jsonEncode({
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'password': user.password,
      'avatarUrl': user.avatarUrl,
    });

    await prefs.setString(_userKey, userJson);
  }

  Future<void> _loadUserFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();

    final userJson = prefs.getString(_userKey);

    if (userJson != null) {
      final userData = jsonDecode(userJson);

      final user = User.fromJson(userData);

      _user = user;
    }
  }

  Future<void> initializerUser() async {
    await _loadUserFromLocalStorage();
    notifyListeners();
  }

  Future<void> createUser({
    required String name,
    required String email,
    required String password,
    String? avatarUrl,
  }) async {
    await repository.createUser(
      name: name,
      email: email,
      password: password,
      avatarUrl: avatarUrl,
    );
  }

  Future<User?> getUserByEmail(String email) async {
    final user = await repository.getUserByEmail(email);

    return user;
  }

  Future<void> login({required String email, required String password}) async {
    final userFromDb = await getUserByEmail(email);

    if (userFromDb == null) {
      throw InvalidCredentialsException(
        code: 'Invalid Credentials',
        message: 'Ops! Credenciais inválidas...',
      );
    }

    final isValidPassword = PasswordEncryption.verifyPassword(
      password,
      userFromDb.password,
    );

    if (!isValidPassword) {
      throw InvalidCredentialsException(
        code: 'Invalid Credentials',
        message: 'Ops! Credenciais inválidas...',
      );
    }

    await _saveUserToLocalStorage(userFromDb);

    _user = userFromDb;
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userKey);

    _user = null;
    notifyListeners();
  }
}
