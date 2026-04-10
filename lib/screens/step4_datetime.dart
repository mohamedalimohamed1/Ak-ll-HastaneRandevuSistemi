import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/appointment_provider.dart';
import 'step3_doctor.dart';
import 'step5_extras.dart';

class Step4DateTimeScreen extends StatefulWidget {
  const Step4DateTimeScreen({super.key});

  static const String routeName = '/step4';

  @override
  State<Step4DateTimeScreen> createState() => _Step4DateTimeScreenState();
}

class _Step4DateTimeScreenState extends State<Step4DateTimeScreen> {
  final _notesController = TextEditingController();

  DateTime? _selectedDate;
  String? _selectedTime;
  bool _isUrgent = false;
  bool _didSeed = false;

  static const Set<String> _fixedHolidays = <String>{
    '01-01',
    '04-23',
    '05-01',
    '05-19',
    '07-15',
    '08-30',
    '10-29',
  };

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();

    if (!_didSeed && provider.initialized) {
      _didSeed = true;
      _selectedDate = provider.appointmentDate.isEmpty
          ? null
          : DateTime.tryParse(provider.appointmentDate);
      _selectedTime =
          provider.appointmentTime.isEmpty ? null : provider.appointmentTime;
      _isUrgent = provider.isUrgent;
      _notesController.text = provider.notes;
    }

    final slots = provider.generateTimeSlots();

    return Scaffold(
      appBar: AppBar(title: const Text('Tarih ve Saat')),
      body: SafeArea(
        child: provider.isLoadingData
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
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
                            const _StepHeader(step: 4, title: 'Tarih ve Saat'),
                            const SizedBox(height: 24),
                            _InfoCard(
                              title: 'Seçilen Doktor',
                              child: Text(
                                provider.doctorName.isEmpty
                                    ? 'Doktor seçimi bulunamadı'
                                    : provider.doctorName,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              key: const ValueKey('btn_tarih_sec'),
                              onPressed: provider.doctorId.isEmpty ? null : _pickDate,
                              child: Text(
                                _selectedDate == null
                                    ? 'Tarih Seç'
                                    : DateFormat('dd.MM.yyyy')
                                        .format(_selectedDate!),
                              ),
                            ),
                            const SizedBox(height: 20),
                            if (_selectedDate != null) ...[
                              Text(
                                'Uygun Saatler',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 12),
                              Wrap(
                                spacing: 10,
                                runSpacing: 10,
                                children: slots.map((saat) {
                                  final isBooked = provider.isSlotBooked(
                                    doctorId: provider.doctorId,
                                    date: _selectedDate!,
                                    time: saat,
                                  );
                                  final isSelected = _selectedTime == saat;

                                  return InkWell(
                                    key: ValueKey('slot_${saat}'),
                                    onTap: isBooked
                                        ? null
                                        : () {
                                            setState(() {
                                              _selectedTime = saat;
                                            });
                                          },
                                    borderRadius: BorderRadius.circular(16),
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 180),
                                      width: 100,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isBooked
                                            ? Colors.grey.shade300
                                            : isSelected
                                                ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                                : Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(
                                          color: isBooked
                                              ? Colors.grey.shade300
                                              : isSelected
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : Colors.grey.shade400,
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            saat,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: isBooked
                                                  ? Colors.grey.shade600
                                                  : isSelected
                                                      ? Colors.white
                                                      : Colors.black87,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          if (isBooked)
                                            Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Text(
                                                'Dolu',
                                                style: TextStyle(
                                                  color: Colors.grey.shade700,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                            const SizedBox(height: 24),
                            _InfoCard(
                              title: 'Randevu Önceliği',
                              child: Row(
                                children: [
                                  const Expanded(
                                    child: Text(
                                      'Acil randevu seçeneğini ihtiyaç halinde aktif edin.',
                                    ),
                                  ),
                                  Switch(
                                    key: const ValueKey('switch_acil'),
                                    value: _isUrgent,
                                    onChanged: (value) {
                                      setState(() {
                                        _isUrgent = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              key: const ValueKey('input_notlar'),
                              controller: _notesController,
                              minLines: 3,
                              maxLines: 4,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.done,
                              decoration: const InputDecoration(
                                labelText: 'Ek Notlar',
                                hintText:
                                    'Doktora iletmek istediğiniz ek bilgileri yazın',
                              ),
                            ),
                            const SizedBox(height: 28),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    key: const ValueKey('btn_geri'),
                                    onPressed: () async {
                                      await provider.goToStep(3);
                                      if (!context.mounted) {
                                        return;
                                      }
                                      Navigator.pushReplacementNamed(
                                        context,
                                        Step3DoctorScreen.routeName,
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

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final initialDate = _selectedDate != null && _isSelectableDate(_selectedDate!)
        ? _selectedDate!
        : _nextSelectableDate(now);

    final picked = await showDatePicker(
      context: context,
      firstDate: now,
      initialDate: initialDate,
      lastDate: now.add(const Duration(days: 90)),
      helpText: 'Randevu Tarihi Seçin',
      selectableDayPredicate: _isSelectableDate,
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _selectedTime = null;
      });
    }
  }

  bool _isSelectableDate(DateTime date) {
    final isWeekend = date.weekday == DateTime.saturday ||
        date.weekday == DateTime.sunday;
    final holidayKey =
        '${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    return !isWeekend && !_fixedHolidays.contains(holidayKey);
  }

  DateTime _nextSelectableDate(DateTime from) {
    var candidate = from;
    while (!_isSelectableDate(candidate)) {
      candidate = candidate.add(const Duration(days: 1));
    }
    return candidate;
  }

  Future<void> _submit() async {
    if (_selectedDate == null || _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tarih ve saat seçimi zorunludur.')),
      );
      return;
    }

    final provider = context.read<AppointmentProvider>();
    await provider.updateDateTimeInfo(
      appointmentDate: _selectedDate!,
      appointmentTime: _selectedTime!,
      isUrgent: _isUrgent,
      notes: _notesController.text.trim(),
    );
    await provider.goToStep(5);

    if (!mounted) {
      return;
    }

    Navigator.pushReplacementNamed(context, Step5ExtrasScreen.routeName);
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

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.title, required this.child});

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
