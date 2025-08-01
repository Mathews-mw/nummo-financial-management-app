import 'package:flutter/widgets.dart';

import 'package:nummo/ui/screens/home_screen.dart';
import 'package:nummo/ui/screens/login_screen.dart';
import 'package:nummo/ui/screens/perfil_screen.dart';
import 'package:nummo/ui/screens/signup_screen.dart';
import 'package:nummo/ui/screens/opening_screen.dart';
import 'package:nummo/ui/screens/notifications_screen.dart';
import 'package:nummo/ui/screens/monthly_budget_screen.dart';
import 'package:nummo/ui/screens/bills_management_screen.dart';

class AppRoutes {
  static const opening = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const home = '/home';
  static const monthlyBudget = '/monthly-budget';
  static const billsManagement = '/bills-management';
  static const notifications = '/notifications';
  static const perfil = '/perfil';

  static Map<String, Widget Function(BuildContext)> routes = {
    AppRoutes.opening: (ctx) => const OpeningScreen(),
    AppRoutes.login: (ctx) => const LoginScreen(),
    AppRoutes.signup: (ctx) => const SignupScreen(),
    AppRoutes.home: (ctx) => const HomeScreen(),
    AppRoutes.monthlyBudget: (ctx) => const MonthlyBudgetScreen(),
    AppRoutes.billsManagement: (ctx) => const BillsManagement(),
    AppRoutes.notifications: (ctx) => const NotificationsScreen(),
    AppRoutes.perfil: (ctx) => const PerfilScreen(),
  };
}
