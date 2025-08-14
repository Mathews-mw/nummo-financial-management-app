import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:nummo/@exceptions/invalid_credentials_exception.dart';

import 'package:nummo/app_routes.dart';
import 'package:nummo/providers/user_provider.dart';
import 'package:nummo/components/custom_button.dart';
import 'package:nummo/components/custom_text_field.dart';
import 'package:nummo/@mixins/form_validations_mixin.dart';
import 'package:nummo/components/password_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with FormValidationsMixin {
  bool _isLoading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, Object> formData = <String, Object>{};

  Future<void> _handleLogin() async {
    setState(() => _isLoading = true);

    final bool isValidForm = formKey.currentState?.validate() ?? false;

    if (!isValidForm) {
      print('Invalid form!');
      setState(() => _isLoading = false);
      return;
    }

    formKey.currentState?.save();

    print('form data: $formData');

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      await userProvider.login(
        email: formData['email'] as String,
        password: formData['password'] as String,
      );

      if (context.mounted) {
        await Future.delayed(Duration(seconds: 3));

        Navigator.of(context).pushReplacementNamed(AppRoutes.home);
      }
    } on InvalidCredentialsException catch (e) {
      return _invalidCredentialsError();
    } catch (e) {
      print('Erro inesperado ao tentar fazer o login: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  _invalidCredentialsError() {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Ops! Credenciais inválidas. Caso ainda não tenha uma conta, crie uma.',
        ),
        action: SnackBarAction(
          label: 'Criar conta',
          onPressed: () {
            Navigator.of(context).pushNamed(AppRoutes.signup);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Image.asset(
                  'assets/images/nummo_cover.png',
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Form(
                key: formKey,
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      const Text(
                        'Boas vindas!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Pronto para organizar suas finanças? Acesse agora.',
                      ),
                      const SizedBox(height: 20),
                      CustomTextField(
                        hintText: 'E-mail',
                        enabled: !_isLoading,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) => combine([
                          () => isNotEmpty(value),
                          () => isEmail(
                            value,
                            'Por favor, informe um e-mail válido.',
                          ),
                        ]),
                        onSaved: (value) {
                          formData['email'] = value ?? '';
                        },
                      ),
                      const SizedBox(height: 10),
                      PasswordTextField(
                        hintText: 'Senha',
                        enabled: !_isLoading,
                        validator: isNotEmpty,
                        onSaved: (value) {
                          formData['password'] = value ?? '';
                        },
                        onFieldSubmitted: (value) async {
                          print('value: $value');
                          await _handleLogin();
                        },
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              label: 'Entrar',
                              isLoading: _isLoading,
                              disabled: _isLoading,
                              onPressed: () => _handleLogin(),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'Esqueceu a senha?',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                      Divider(),
                      const SizedBox(height: 10),
                      const Text('Ainda não tem uma conta?'),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AppRoutes.signup);
                        },
                        child: const Text(
                          'Criar conta',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
