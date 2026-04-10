import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../services/validator_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  static const String routeName = '/signup';

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _tcController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordAgainController = TextEditingController();
  final _phoneFormatter = MaskTextInputFormatter(
    mask: '0(5##) ### ## ##',
    filter: <String, RegExp>{'#': RegExp(r'\d')},
  );

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _tcController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordAgainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hesap Oluştur',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Hızlı randevu takibi için üyelik bilgilerinizi tamamlayın.',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.black54,
                              ),
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Ad'),
                          validator: (value) => ValidatorService.validateName(
                            value,
                            fieldName: 'Ad',
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _surnameController,
                          decoration: const InputDecoration(labelText: 'Soyad'),
                          validator: (value) => ValidatorService.validateName(
                            value,
                            fieldName: 'Soyad',
                          ),
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _tcController,
                          decoration: const InputDecoration(labelText: 'TC Kimlik'),
                          keyboardType: TextInputType.number,
                          validator: ValidatorService.validateTcKimlik,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(labelText: 'E-posta'),
                          keyboardType: TextInputType.emailAddress,
                          validator: ValidatorService.validateEmail,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(labelText: 'Telefon'),
                          keyboardType: TextInputType.phone,
                          inputFormatters: [_phoneFormatter],
                          validator: ValidatorService.validatePhone,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(labelText: 'Şifre'),
                          validator: ValidatorService.validatePassword,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordAgainController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Şifre Tekrar',
                          ),
                          validator: (value) {
                            final requiredError = ValidatorService.requiredField(
                              value,
                              fieldName: 'Şifre Tekrar',
                            );
                            if (requiredError != null) {
                              return requiredError;
                            }
                            if (value != _passwordController.text) {
                              return 'Şifreler eşleşmiyor.';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed: _submit,
                          child: const Text('Kayıt Ol'),
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
      return;
    }

    Navigator.pop(context);
  }
}
