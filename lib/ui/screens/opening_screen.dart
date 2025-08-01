import 'package:flutter/material.dart';
import 'package:nummo/providers/user_provider.dart';

import 'package:nummo/app_routes.dart';
import 'package:provider/provider.dart';
import 'package:nummo/theme/app_colors.dart';

class OpeningScreen extends StatefulWidget {
  const OpeningScreen({super.key});

  @override
  State<OpeningScreen> createState() => _OpeningScreenState();
}

class _OpeningScreenState extends State<OpeningScreen> {
  bool _isAuthenticated = false;
  bool _isRequestCompleted = false;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      await userProvider.initializerUser();

      setState(() => _isAuthenticated = userProvider.isAuthenticated);
    } catch (e) {
      print("Erro ao carregar dados do usuário: $e");
      _isAuthenticated = false;
    } finally {
      setState(() {
        _isRequestCompleted = true;
      });

      _redirectUser();
    }
  }

  void _redirectUser() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      _isAuthenticated ? AppRoutes.home : AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight =
        mediaQuery.size.height - mediaQuery.viewPadding.vertical;

    return Scaffold(
      extendBody: true,
      backgroundColor: AppColors.background,
      body: ConstrainedBox(
        constraints: BoxConstraints(minHeight: screenHeight),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Nummo',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                        letterSpacing: 0,
                      ),
                    ),
                    Image.asset('assets/images/nummo_logo.png'),
                    Text(
                      'Seu App de gestão financeira',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontSize: 18,
                        letterSpacing: 0,
                        fontStyle: FontStyle.italic,
                        color: AppColors.gray700,
                      ),
                    ),
                  ],
                ),
              ),
              LinearProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
