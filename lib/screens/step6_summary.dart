import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/appointment_provider.dart';
import 'step1_personal.dart';
import 'step5_extras.dart';

class Step6SummaryScreen extends StatefulWidget {
  const Step6SummaryScreen({super.key});

  static const String routeName = '/step6';

  @override
  State<Step6SummaryScreen> createState() => _Step6SummaryScreenState();
}

class _Step6SummaryScreenState extends State<Step6SummaryScreen> {
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();
    final currency = NumberFormat.currency(symbol: '₺', decimalDigits: 0);

    return Scaffold(
      appBar: AppBar(title: const Text('Özet ve Onay')),
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
                      const _StepHeader(step: 6, title: 'Randevu Özeti'),
                      const SizedBox(height: 24),
                      _SummarySection(
                        title: 'Kişisel Bilgiler',
                        rows: [
                          _SummaryRow(
                            'Ad Soyad',
                            '${provider.firstName} ${provider.lastName}'.trim(),
                          ),
                          _SummaryRow('TC Kimlik', provider.tcKimlik),
                          _SummaryRow('Telefon', provider.phone),
                          _SummaryRow('E-posta', provider.email),
                          _SummaryRow('Doğum Tarihi', provider.birthDate),
                          _SummaryRow(
                            'Cinsiyet',
                            provider.gender == 'kadin' ? 'Kadın' : 'Erkek',
                          ),
                          _SummaryRow('Adres', provider.address),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _SummarySection(
                        title: 'Sağlık ve Sigorta',
                        rows: [
                          _SummaryRow(
                            'Sigorta Türü',
                            provider.insuranceType.isEmpty
                                ? '-'
                                : provider.insuranceType,
                          ),
                          _SummaryRow(
                            'Sigorta Firması',
                            provider.insuranceCompany.isEmpty
                                ? '-'
                                : provider.insuranceCompany,
                          ),
                          _SummaryRow(
                            'Alerji Durumu',
                            provider.hasAllergy ? 'Var' : 'Yok',
                          ),
                          _SummaryRow(
                            'Alerji Detayı',
                            provider.allergyDetails.isEmpty
                                ? '-'
                                : provider.allergyDetails,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _SummarySection(
                        title: 'Randevu Detayları',
                        rows: [
                          _SummaryRow('Şehir', provider.cityName),
                          _SummaryRow('Hastane', provider.hospitalName),
                          _SummaryRow('Bölüm', provider.departmentName),
                          _SummaryRow('Doktor', provider.doctorName),
                          _SummaryRow(
                            'Tarih',
                            provider.appointmentDate.isEmpty
                                ? '-'
                                : DateFormat('dd.MM.yyyy').format(
                                    DateTime.parse(provider.appointmentDate),
                                  ),
                          ),
                          _SummaryRow(
                            'Saat',
                            provider.appointmentTime.isEmpty
                                ? '-'
                                : provider.appointmentTime,
                          ),
                          _SummaryRow(
                            'Acil Randevu',
                            provider.isUrgent ? 'Evet' : 'Hayır',
                          ),
                          _SummaryRow(
                            'Ek Notlar',
                            provider.notes.isEmpty ? '-' : provider.notes,
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      _SummarySection(
                        title: 'Ek Hizmetler',
                        rows: [
                          _SummaryRow(
                            'Kan Tahlili',
                            provider.extraBloodTest ? 'Seçildi' : 'Yok',
                          ),
                          _SummaryRow(
                            'MR',
                            provider.extraMr ? 'Seçildi' : 'Yok',
                          ),
                          _SummaryRow(
                            'Röntgen',
                            provider.extraXray ? 'Seçildi' : 'Yok',
                          ),
                          _SummaryRow(
                            'Refakatçi Sayısı',
                            provider.companionCount.toString(),
                          ),
                          _SummaryRow(
                            'KVKK Onayı',
                            provider.kvkkApproved ? 'Verildi' : 'Verilmedi',
                          ),
                          _SummaryRow(
                            'Açık Rıza',
                            provider.explicitConsentApproved
                                ? 'Verildi'
                                : 'Verilmedi',
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.08),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            Text(
                              'Toplam Ücret',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            const Spacer(),
                            Text(
                              currency.format(provider.calculateTotalPrice()),
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(fontWeight: FontWeight.w800),
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
                              onPressed: _isSubmitting
                                  ? null
                                  : () async {
                                      await provider.goToStep(5);
                                      if (!context.mounted) {
                                        return;
                                      }
                                      Navigator.pushReplacementNamed(
                                        context,
                                        Step5ExtrasScreen.routeName,
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
                              key: const ValueKey('btn_onayla'),
                              onPressed: _isSubmitting ? null : _submit,
                              child: _isSubmitting
                                  ? const SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2.4,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text('Onayla'),
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
    setState(() {
      _isSubmitting = true;
    });

    await Future<void>.delayed(const Duration(seconds: 2));

    final provider = context.read<AppointmentProvider>();
    final code = await provider.completeAppointment();
    await provider.clearSavedDraftOnly();

    if (!mounted) {
      return;
    }

    setState(() {
      _isSubmitting = false;
    });

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return Dialog(
          insetPadding: const EdgeInsets.all(24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: const Color(0xFF4CAF50).withOpacity(0.14),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF4CAF50),
                    size: 36,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Randevunuz başarıyla oluşturuldu',
                  textAlign: TextAlign.center,
                  style: Theme.of(dialogContext).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Randevu kodunuzu saklayın. Bu kod işlem takibi için gereklidir.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    'Randevu Kodu: $code',
                    textAlign: TextAlign.center,
                    style:
                        Theme.of(dialogContext).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w800,
                            ),
                  ),
                ),
                const SizedBox(height: 18),
                ElevatedButton(
                  onPressed: () async {
                    await provider.clearDraft();
                    if (!dialogContext.mounted) {
                      return;
                    }
                    Navigator.of(dialogContext).pop();
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      Step1PersonalScreen.routeName,
                      (route) => false,
                    );
                  },
                  child: const Text('Yeni Randevu'),
                ),
              ],
            ),
          ),
        );
      },
    );
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

class _SummarySection extends StatelessWidget {
  const _SummarySection({required this.title, required this.rows});

  final String title;
  final List<_SummaryRow> rows;

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
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 14),
          ...rows.map(
            (row) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: Text(row.label)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      row.value.isEmpty ? '-' : row.value,
                      textAlign: TextAlign.end,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow {
  const _SummaryRow(this.label, this.value);

  final String label;
  final String value;
}
