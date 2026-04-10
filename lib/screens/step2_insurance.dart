import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/appointment_provider.dart';
import '../services/validator_service.dart';
import 'step1_personal.dart';
import 'step3_doctor.dart';

class Step2InsuranceScreen extends StatefulWidget {
  const Step2InsuranceScreen({super.key});

  static const String routeName = '/step2';

  @override
  State<Step2InsuranceScreen> createState() => _Step2InsuranceScreenState();
}

class _Step2InsuranceScreenState extends State<Step2InsuranceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _insuranceCompanyController = TextEditingController();
  final _allergyDetailsController = TextEditingController();

  String? _insuranceType;
  bool _hasAllergy = false;
  bool _didSeed = false;

  static const List<String> _fallbackInsuranceTypes = <String>[
    'SGK',
    'Bağ-Kur',
    'Özel',
    'Tamamlayıcı',
  ];

  @override
  void dispose() {
    _insuranceCompanyController.dispose();
    _allergyDetailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    if (!_didSeed && provider.initialized) {
      _didSeed = true;
      _insuranceType =
          provider.insuranceType.isEmpty ? null : provider.insuranceType;
      _insuranceCompanyController.text = provider.insuranceCompany;
      _allergyDetailsController.text = provider.allergyDetails;
      _hasAllergy = provider.hasAllergy;
    }

    final insuranceOptions = provider.insuranceCompanies.isEmpty
        ? _fallbackInsuranceTypes
        : provider.insuranceCompanies;

    return Scaffold(
      appBar: AppBar(title: const Text('Sigorta ve Sağlık')),
      body: SafeArea(
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
                        const _StepHeader(step: 2, title: 'Sigorta ve Sağlık'),
                        const SizedBox(height: 24),
                        DropdownButtonFormField<String>(
                          key: const ValueKey('dropdown_sigorta'),
                          initialValue: _insuranceType,
                          decoration: const InputDecoration(
                            labelText: 'Sigorta Türü',
                          ),
                          items: insuranceOptions
                              .map(
                                (type) => DropdownMenuItem<String>(
                                  value: type,
                                  child: Text(type),
                                ),
                              )
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _insuranceType = value;
                              if (value != 'Özel') {
                                _insuranceCompanyController.clear();
                              }
                            });
                          },
                          validator: (value) =>
                              ValidatorService.requiredField(
                            value,
                            fieldName: 'Sigorta Türü',
                          ),
                        ),
                        if (_insuranceType == 'Özel') ...[
                          const SizedBox(height: 16),
                          TextFormField(
                            key: const ValueKey('input_sigorta_firma'),
                            controller: _insuranceCompanyController,
                            decoration: const InputDecoration(
                              labelText: 'Sigorta Firması',
                              hintText: 'Sigorta firma adını giriniz',
                            ),
                            validator: (value) {
                              if (_insuranceType != 'Özel') {
                                return null;
                              }
                              return ValidatorService.requiredField(
                                value,
                                fieldName: 'Sigorta Firması',
                              );
                            },
                          ),
                        ],
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Alerji Bilgisi',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(fontWeight: FontWeight.w700),
                                    ),
                                    const SizedBox(height: 6),
                                    const Text(
                                      'Bilinen alerjiniz varsa aktif hale getirin.',
                                    ),
                                  ],
                                ),
                              ),
                              Switch(
                                key: const ValueKey('switch_alerji'),
                                value: _hasAllergy,
                                onChanged: (value) {
                                  setState(() {
                                    _hasAllergy = value;
                                    if (!value) {
                                      _allergyDetailsController.clear();
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        if (_hasAllergy) ...[
                          const SizedBox(height: 16),
                          TextFormField(
                            key: const ValueKey('input_alerji_aciklama'),
                            controller: _allergyDetailsController,
                            minLines: 3,
                            maxLines: 4,
                            decoration: const InputDecoration(
                              labelText: 'Alerji Detayı',
                              hintText: 'Alerji detayını yazınız',
                            ),
                            validator: (value) {
                              if (!_hasAllergy) {
                                return null;
                              }
                              return ValidatorService.requiredField(
                                value,
                                fieldName: 'Alerji Detayı',
                              );
                            },
                          ),
                        ],
                        const SizedBox(height: 28),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                key: const ValueKey('btn_geri'),
                                onPressed: () async {
                                  await context
                                      .read<AppointmentProvider>()
                                      .goToStep(1);
                                  if (!mounted) {
                                    return;
                                  }
                                  Navigator.pushReplacementNamed(
                                    context,
                                    Step1PersonalScreen.routeName,
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  side: BorderSide(
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                                child: const Text('Geri'),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                key: const ValueKey('btn_ileri'),
                                onPressed: _submit,
                                child: const Text('İleri'),
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

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final provider = context.read<AppointmentProvider>();
    await provider.updateInsuranceInfo(
      insuranceType: _insuranceType ?? '',
      insuranceCompany: _insuranceCompanyController.text.trim(),
      hasAllergy: _hasAllergy,
      allergyDetails: _allergyDetailsController.text.trim(),
    );
    await provider.goToStep(3);

    if (!mounted) {
      return;
    }

    Navigator.pushReplacementNamed(context, Step3DoctorScreen.routeName);
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
