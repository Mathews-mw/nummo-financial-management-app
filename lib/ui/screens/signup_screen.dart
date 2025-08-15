import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:nummo/theme/app_colors.dart';
import 'package:nummo/providers/user_provider.dart';
import 'package:nummo/components/custom_button.dart';
import 'package:nummo/components/custom_text_field.dart';
import 'package:nummo/components/password_text_field.dart';
import 'package:nummo/@mixins/form_validations_mixin.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> with FormValidationsMixin {
  bool _isLoading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final Map<String, Object> formData = <String, Object>{};

  Future<void> _handleRegisterUser() async {
    setState(() => _isLoading = true);

    final bool isValidForm = formKey.currentState?.validate() ?? false;

    if (!isValidForm) {
      print('Invalid form!');
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, verifique os campos do formulário.'),
        ),
      );

      return;
    }

    formKey.currentState?.save();
    print('formdata: $formData');

    if (formData['password'] != formData['confirmPassword']) {
      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'A confirmação de senhas não conferem. Verifique os campos.',
          ),
        ),
      );

      return;
    }

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      await Future.delayed(Duration(seconds: 3));

      await userProvider.createUser(
        name: formData['name'] as String,
        email: formData['email'] as String,
        password: formData['password'] as String,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cadastro realizado com sucesso!')),
        );

        Navigator.of(context).pop();
      }
    } catch (e) {
      print('Erro ao tentar cadastrar usuário: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight =
        mediaQuery.size.height - mediaQuery.viewPadding.vertical;

    return Scaffold(
      extendBody: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: screenHeight),
            child: Padding(
              padding: const EdgeInsets.only(
                top: 0,
                left: 32,
                right: 32,
                bottom: 32,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [BackButton()],
                      ),
                      const SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                          ),
                          children: <TextSpan>[
                            const TextSpan(text: 'Crie sua conta no '),
                            TextSpan(
                              text: 'Nummo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors
                                    .primary, // Escolha a cor que desejar
                              ),
                            ),
                            const TextSpan(
                              text: ' para aproveitar o melhor do app!',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: [
                        CustomTextField(
                          hintText: 'Nome',
                          enabled: !_isLoading,
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          validator: isNotEmpty,
                          onSaved: (value) {
                            formData['name'] = value ?? '';
                          },
                        ),
                        const SizedBox(height: 10),
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
                          textInputAction: TextInputAction.next,
                          validator: isNotEmpty,
                          onSaved: (value) {
                            formData['password'] = value ?? '';
                          },
                        ),
                        const SizedBox(height: 10),
                        PasswordTextField(
                          hintText: 'Confirmar senha',
                          enabled: !_isLoading,
                          validator: isNotEmpty,
                          onSaved: (value) {
                            formData['confirmPassword'] = value ?? '';
                          },
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          label: 'Cadastrar',
                          isLoading: _isLoading,
                          disabled: _isLoading,
                          onPressed: () => _handleRegisterUser(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
