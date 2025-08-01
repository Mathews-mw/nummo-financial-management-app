import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nummo/app_routes.dart';
import 'package:nummo/theme/theme.dart';
import 'package:nummo/ui/screens/home_screen.dart';
import 'package:nummo/ui/screens/login_screen.dart';
import 'package:nummo/providers/user_provider.dart';
import 'package:nummo/ui/screens/signup_screen.dart';
import 'package:nummo/ui/screens/opening_screen.dart';
import 'package:nummo/core/database/app_database.dart';
import 'package:nummo/data/repositories/user_repository.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AppDatabase appDatabase = AppDatabase();
  late final UserRepository userRepository;

  MyApp({super.key}) {
    userRepository = UserRepository(userDao: appDatabase.userDao);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(userRepository)),
      ],
      child: MaterialApp(
        title: 'Nummo - Gestão de finanças',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        initialRoute: AppRoutes.opening,
        routes: {
          AppRoutes.opening: (ctx) => OpeningScreen(),
          AppRoutes.login: (ctx) => LoginScreen(),
          AppRoutes.signup: (ctx) => SignupScreen(),
          AppRoutes.home: (ctx) => HomeScreen(),
        },
      ),
    );
  }
}
