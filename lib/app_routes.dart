import 'package:flutter/widgets.dart';

import 'package:nummo/ui/screens/home_screen.dart';
import 'package:nummo/ui/screens/login_screen.dart';
import 'package:nummo/ui/screens/signup_screen.dart';
import 'package:nummo/ui/screens/opening_screen.dart';

class AppRoutes {
  static const opening = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';

  static Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.opening: (ctx) => const OpeningScreen(),
    AppRoutes.login: (ctx) => const LoginScreen(),
    AppRoutes.signup: (ctx) => const SignupScreen(),
    AppRoutes.home: (ctx) => const HomeScreen(),
  };
}
