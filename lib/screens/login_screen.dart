import 'package:flutter/material.dart';

import '../services/validator_service.dart';
import '../widgets/ui_helper.dart';
import 'signup_screen.dart';
import 'step1_personal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  static const String routeName = '/login';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identityController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _identityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MediBook',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Randevu adımlarına devam etmek için giriş yapın.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.black54,
                              ),
                        ),
                        const SizedBox(height: 28),
                        Semantics(
                          label: 'TC veya e-posta alanı',
                          textField: true,
                          child: TextFormField(
                            controller: _identityController,
                            decoration: const InputDecoration(
                              labelText: 'TC / E-posta',
                              hintText: 'TC Kimlik veya e-posta giriniz',
                            ),
                            validator: (value) => ValidatorService.requiredField(
                              value,
                              fieldName: 'TC / E-posta',
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Semantics(
                          label: 'Şifre alanı',
                          textField: true,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Şifre',
                              hintText: 'Şifrenizi giriniz',
                            ),
                            validator: ValidatorService.validatePassword,
                            textInputAction: TextInputAction.done,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Semantics(
                          label: 'Giriş Yap butonu',
                          button: true,
                          child: ElevatedButton(
                            onPressed: _submit,
                            child: const Text('Giriş Yap'),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Text('Hesabınız yok mu?'),
                            TextButton(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  SignupScreen.routeName,
                                );
                              },
                              child: const Text('Kayıt Ol'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      UIHelper.showSnackBar(
        context,
        'Giriş bilgilerini kontrol ediniz.',
        isError: true,
      );
      return;
    }

    UIHelper.showSnackBar(context, 'Giriş başarılı!');
    Navigator.pushReplacementNamed(context, Step1PersonalScreen.routeName);
  }
}
