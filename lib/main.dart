import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:nummo/app_routes.dart';
import 'package:nummo/theme/theme.dart';
import 'package:nummo/ui/screens/login_screen.dart';
import 'package:nummo/providers/user_provider.dart';
import 'package:nummo/providers/theme_provider.dart';
import 'package:nummo/ui/screens/signup_screen.dart';
import 'package:nummo/ui/screens/perfil_screen.dart';
import 'package:nummo/ui/screens/opening_screen.dart';
import 'package:nummo/providers/budget_provider.dart';
import 'package:nummo/core/database/app_database.dart';
import 'package:nummo/ui/screens/home/home_screen.dart';
import 'package:nummo/providers/transaction_provider.dart';
import 'package:nummo/ui/screens/notifications_screen.dart';
import 'package:nummo/providers/bill_reminder_provider.dart';
import 'package:nummo/data/repositories/user_repository.dart';
import 'package:nummo/data/repositories/budget_repository.dart';
import 'package:nummo/services/local_notifications_service.dart';
import 'package:nummo/data/repositories/transaction_repository.dart';
import 'package:nummo/data/repositories/bill_reminder_repository.dart';
import 'package:nummo/ui/screens/monthly_budget/monthly_budget_screen.dart';
import 'package:nummo/ui/screens/bills_management/bills_management_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);
  await LocalNotificationsService.instance.initNotifications();

  LocalNotificationsService.instance.getPermissions();

  runApp(
    ChangeNotifierProvider(create: (_) => ThemeProvider(), child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  final AppDatabase appDatabase = AppDatabase();

  late final UserRepository userRepository;
  late final BudgetRepository budgetRepository;
  late final TransactionRepository transactionRepository;
  late final BillReminderRepository billReminderRepository;

  late final LocalNotificationsService notificationsService =
      LocalNotificationsService();

  MyApp({super.key}) {
    userRepository = UserRepository(userDao: appDatabase.userDao);
    budgetRepository = BudgetRepository(budgetDao: appDatabase.budgetDao);
    transactionRepository = TransactionRepository(
      transactionDao: appDatabase.transactionDao,
    );
    billReminderRepository = BillReminderRepository(
      billReminderDao: appDatabase.billReminderDao,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider(userRepository)),
        ChangeNotifierProvider(create: (_) => BudgetProvider(budgetRepository)),
        ChangeNotifierProvider(
          create: (_) => TransactionProvider(transactionRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => BillReminderProvider(
            billReminderRepository,
            notificationsService,
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Nummo - Gestão de finanças',
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: Provider.of<ThemeProvider>(context).themeMode,
        initialRoute: AppRoutes.opening,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: [Locale('en', 'US'), Locale('pt', 'BR')],
        routes: {
          AppRoutes.opening: (ctx) => OpeningScreen(),
          AppRoutes.login: (ctx) => LoginScreen(),
          AppRoutes.signup: (ctx) => SignupScreen(),
          AppRoutes.home: (ctx) => HomeScreen(),
          AppRoutes.monthlyBudget: (ctx) => MonthlyBudgetScreen(),
          AppRoutes.billsManagement: (ctx) => BillsManagement(),
          AppRoutes.notifications: (ctx) => NotificationsScreen(),
          AppRoutes.perfil: (ctx) => PerfilScreen(),
        },
      ),
    );
  }
}
