import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:provider/provider.dart';

import '../providers/appointment_provider.dart';
import '../services/validator_service.dart';
import '../widgets/ui_helper.dart';
import 'login_screen.dart';
import 'step2_insurance.dart';

class Step1PersonalScreen extends StatefulWidget {
  const Step1PersonalScreen({super.key});

  static const String routeName = '/step1';

  @override
  State<Step1PersonalScreen> createState() => _Step1PersonalScreenState();
}

class _Step1PersonalScreenState extends State<Step1PersonalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _tcController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneFormatter = MaskTextInputFormatter(
    mask: '#(###) ### ## ##',
    filter: <String, RegExp>{'#': RegExp(r'\d')},
  );

  String _selectedGender = 'erkek';
  bool _didSeed = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _surnameController.dispose();
    _tcController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthDateController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    if (!_didSeed && provider.initialized) {
      _didSeed = true;
      _nameController.text = provider.firstName;
      _surnameController.text = provider.lastName;
      _tcController.text = provider.tcKimlik;
      _emailController.text = provider.email;
      _phoneController.text = provider.phone;
      _birthDateController.text = provider.birthDate;
      _addressController.text = provider.address;
      _selectedGender = provider.gender;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Kişisel Bilgiler')),
      body: provider.isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _StepHeader(
                                step: 1,
                                title: 'Kişisel Bilgiler',
                              ),
                              const SizedBox(height: 24),
                              TextFormField(
                                key: const ValueKey('input_ad'),
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Ad',
                                  hintText: 'Adınızı giriniz',
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) => ValidatorService.validateName(
                                  value,
                                  fieldName: 'Ad',
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                key: const ValueKey('input_soyad'),
                                controller: _surnameController,
                                decoration: const InputDecoration(
                                  labelText: 'Soyad',
                                  hintText: 'Soyadınızı giriniz',
                                ),
                                textInputAction: TextInputAction.next,
                                validator: (value) => ValidatorService.validateName(
                                  value,
                                  fieldName: 'Soyad',
                                ),
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                key: const ValueKey('input_tc'),
                                controller: _tcController,
                                decoration: const InputDecoration(
                                  labelText: 'TC Kimlik',
                                  hintText: '11 haneli TC Kimlik numarası',
                                  counterText: '',
                                ),
                                keyboardType: TextInputType.number,
                                maxLength: 11,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                validator: ValidatorService.validateTcKimlik,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                key: const ValueKey('input_email'),
                                controller: _emailController,
                                decoration: const InputDecoration(
                                  labelText: 'E-posta',
                                  hintText: 'ornek@mail.com',
                                ),
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                validator: ValidatorService.validateEmail,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                key: const ValueKey('input_telefon'),
                                controller: _phoneController,
                                decoration: const InputDecoration(
                                  labelText: 'Telefon',
                                  hintText: '0(5XX) XXX XX XX',
                                ),
                                keyboardType: TextInputType.phone,
                                textInputAction: TextInputAction.next,
                                inputFormatters: [_phoneFormatter],
                                validator: ValidatorService.validatePhone,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                key: const ValueKey('input_dogum'),
                                controller: _birthDateController,
                                readOnly: true,
                                decoration: const InputDecoration(
                                  labelText: 'Doğum Tarihi',
                                  hintText: 'GG.AA.YYYY',
                                  suffixIcon: Icon(Icons.calendar_today_rounded),
                                ),
                                onTap: _pickBirthDate,
                                validator: (value) =>
                                    ValidatorService.requiredField(
                                  value,
                                  fieldName: 'Doğum Tarihi',
                                ),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Cinsiyet',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 12,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<String>(
                                        key: const ValueKey('radio_erkek'),
                                        value: 'erkek',
                                        groupValue: _selectedGender,
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              _selectedGender = value;
                                            });
                                          }
                                        },
                                      ),
                                      const Text('Erkek'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Radio<String>(
                                        key: const ValueKey('radio_kadin'),
                                        value: 'kadin',
                                        groupValue: _selectedGender,
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              _selectedGender = value;
                                            });
                                          }
                                        },
                                      ),
                                      const Text('Kadın'),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                key: const ValueKey('input_adres'),
                                controller: _addressController,
                                decoration: const InputDecoration(
                                  labelText: 'Adres',
                                  hintText: 'Adresinizi giriniz',
                                ),
                                minLines: 3,
                                maxLines: 4,
                                keyboardType: TextInputType.multiline,
                                validator: (value) =>
                                    ValidatorService.requiredField(
                                  value,
                                  fieldName: 'Adres',
                                ),
                              ),
                              const SizedBox(height: 28),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      key: const ValueKey('btn_geri'),
                                      onPressed: () {
                                        Navigator.pushReplacementNamed(
                                          context,
                                          LoginScreen.routeName,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor:
                                            Theme.of(context).colorScheme.primary,
                                        side: BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                      ),
                                      child: const Text('Geri'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      key: const ValueKey('btn_ileri'),
                                      onPressed: _isSubmitting ? null : _submit,
                                      child: Text(
                                        _isSubmitting
                                            ? 'Kontrol Ediliyor...'
                                            : 'İleri',
                                      ),
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
                ),
              ),
            ),
    );
  }

  Future<void> _pickBirthDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 25),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      helpText: 'Doğum Tarihi Seçin',
    );

    if (picked != null) {
      _birthDateController.text = DateFormat('dd.MM.yyyy').format(picked);
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      UIHelper.showSnackBar(
        context,
        'Lütfen formdaki hataları düzeltin.',
        isError: true,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    if (mounted) {
      setState(() {
        _isSubmitting = false;
      });
    }

    if (!mounted) {
      return;
    }

    final provider = context.read<AppointmentProvider>();
    await provider.updatePersonalInfo(
      firstName: _nameController.text.trim(),
      lastName: _surnameController.text.trim(),
      tcKimlik: _tcController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      birthDate: _birthDateController.text.trim(),
      address: _addressController.text.trim(),
      gender: _selectedGender,
    );
    await provider.goToStep(2);

    if (!mounted) {
      return;
    }

    UIHelper.showSnackBar(context, 'Kişisel bilgiler kaydedildi.');
    Navigator.pushReplacementNamed(context, Step2InsuranceScreen.routeName);
  }
}

class _StepHeader extends StatelessWidget {
  const _StepHeader({required this.step, required this.title});

  final int step;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adım $step / 6',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}
