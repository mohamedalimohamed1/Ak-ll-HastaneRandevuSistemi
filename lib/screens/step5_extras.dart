import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/appointment_provider.dart';
import 'step4_datetime.dart';
import 'step6_summary.dart';

class Step5ExtrasScreen extends StatefulWidget {
  const Step5ExtrasScreen({super.key});

  static const String routeName = '/step5';

  @override
  State<Step5ExtrasScreen> createState() => _Step5ExtrasScreenState();
}

class _Step5ExtrasScreenState extends State<Step5ExtrasScreen> {
  bool _bloodTest = false;
  bool _mr = false;
  bool _xray = false;
  int _companionCount = 0;
  bool _kvkk = false;
  bool _consent = false;
  bool _didSeed = false;
  bool _showConsentError = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    if (!_didSeed && provider.initialized) {
      _didSeed = true;
      _bloodTest = provider.extraBloodTest;
      _mr = provider.extraMr;
      _xray = provider.extraXray;
      _companionCount = provider.companionCount;
      _kvkk = provider.kvkkApproved;
      _consent = provider.explicitConsentApproved;
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Ek Hizmetler')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _StepHeader(step: 5, title: 'Ek Hizmetler'),
                      const SizedBox(height: 24),
                      Text(
                        'Ek tetkik ve destek seçenekleri',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 12,
                        runSpacing: 12,
                        children: [
                          FilterChip(
                            key: const ValueKey('chip_kan_tahlili'),
                            label: const Text('Kan Tahlili'),
                            selected: _bloodTest,
                            onSelected: (value) {
                              setState(() {
                                _bloodTest = value;
                              });
                            },
                          ),
                          FilterChip(
                            key: const ValueKey('chip_mr'),
                            label: const Text('MR'),
                            selected: _mr,
                            onSelected: (value) {
                              setState(() {
                                _mr = value;
                              });
                            },
                          ),
                          FilterChip(
                            key: const ValueKey('chip_rontgen'),
                            label: const Text('Röntgen'),
                            selected: _xray,
                            onSelected: (value) {
                              setState(() {
                                _xray = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),
                      _CardSection(
                        title: 'Refakatçi Sayısı',
                        child: Row(
                          children: [
                            const Expanded(
                              child: Text('0 ile 3 arasında seçim yapabilirsiniz.'),
                            ),
                            IconButton(
                              key: const ValueKey('stepper_refakatci_minus'),
                              onPressed: _companionCount > 0
                                  ? () {
                                      setState(() {
                                        _companionCount -= 1;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text(
                              '$_companionCount',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            IconButton(
                              key: const ValueKey('stepper_refakatci_plus'),
                              onPressed: _companionCount < 3
                                  ? () {
                                      setState(() {
                                        _companionCount += 1;
                                      });
                                    }
                                  : null,
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      _CardSection(
                        title: 'Onaylar',
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  key: const ValueKey('checkbox_kvkk'),
                                  value: _kvkk,
                                  onChanged: (value) {
                                    setState(() {
                                      _kvkk = value ?? false;
                                      _showConsentError = false;
                                    });
                                  },
                                ),
                                const Expanded(
                                  child: Text(
                                    'KVKK metnini okudum ve kabul ediyorum.',
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Checkbox(
                                  key: const ValueKey('checkbox_acik_riza'),
                                  value: _consent,
                                  onChanged: (value) {
                                    setState(() {
                                      _consent = value ?? false;
                                      _showConsentError = false;
                                    });
                                  },
                                ),
                                const Expanded(
                                  child: Text(
                                    'Açık rıza onayını veriyorum.',
                                  ),
                                ),
                              ],
                            ),
                            if (_showConsentError)
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Devam etmek için her iki onay da zorunludur.',
                                    style: TextStyle(
                                      color: Colors.red.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              key: const ValueKey('btn_geri'),
                              onPressed: () async {
                                await provider.goToStep(4);
                                if (!context.mounted) {
                                  return;
                                }
                                Navigator.pushReplacementNamed(
                                  context,
                                  Step4DateTimeScreen.routeName,
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
    );
  }

  Future<void> _submit() async {
    if (!_kvkk || !_consent) {
      setState(() {
        _showConsentError = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('KVKK ve Açık Rıza onayları olmadan devam edemezsiniz.'),
        ),
      );
      return;
    }

    final provider = context.read<AppointmentProvider>();
    await provider.updateExtrasInfo(
      bloodTest: _bloodTest,
      mr: _mr,
      xray: _xray,
      companionCount: _companionCount,
      kvkkApproved: _kvkk,
      explicitConsentApproved: _consent,
    );
    await provider.goToStep(6);

    if (!mounted) {
      return;
    }

    Navigator.pushReplacementNamed(context, Step6SummaryScreen.routeName);
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

class _CardSection extends StatelessWidget {
  const _CardSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}
