import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/doctor.dart';
import '../providers/appointment_provider.dart';
import '../services/validator_service.dart';
import '../widgets/ui_helper.dart';
import 'step2_insurance.dart';
import 'step4_datetime.dart';

class Step3DoctorScreen extends StatelessWidget {
  const Step3DoctorScreen({super.key});

  static const String routeName = '/step3';

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();
    final hospitals = provider.getHospitalsByCity(provider.cityId);
    final departments =
        provider.getDepartmentsByHospital(provider.cityId, provider.hospitalId);
    final doctors = provider.getDoctorsByDepartment(
      provider.cityId,
      provider.hospitalId,
      provider.departmentId,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Bölüm ve Doktor')),
      body: provider.isLoadingData
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
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
                            const _StepHeader(
                              step: 3,
                              title: 'Bölüm ve Doktor Seçimi',
                            ),
                            const SizedBox(height: 24),
                            FormField<String>(
                              initialValue:
                                  provider.cityId.isEmpty ? null : provider.cityId,
                              validator: (value) => ValidatorService.requiredField(
                                value,
                                fieldName: 'Şehir',
                              ),
                              builder: (field) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Şehir',
                                    errorText: field.errorText,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      key: const ValueKey('dropdown_sehir'),
                                      value: provider.cityId.isEmpty
                                          ? null
                                          : provider.cityId,
                                      isExpanded: true,
                                      hint: const Text('Şehir seçiniz'),
                                      items: provider.cities
                                          .map(
                                            (city) => DropdownMenuItem<String>(
                                              value: city.id,
                                              child: Text(city.name),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) async {
                                        if (value == null) {
                                          return;
                                        }
                                        final city = provider.cities.firstWhere(
                                          (item) => item.id == value,
                                        );
                                        await provider.selectCity(
                                          id: city.id,
                                          name: city.name,
                                        );
                                        field.didChange(value);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            FormField<String>(
                              initialValue: provider.hospitalId.isEmpty
                                  ? null
                                  : provider.hospitalId,
                              validator: (value) => ValidatorService.requiredField(
                                value,
                                fieldName: 'Hastane',
                              ),
                              builder: (field) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Hastane',
                                    errorText: field.errorText,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      key: const ValueKey('dropdown_hastane'),
                                      value: provider.hospitalId.isEmpty
                                          ? null
                                          : provider.hospitalId,
                                      isExpanded: true,
                                      hint: const Text('Hastane seçiniz'),
                                      items: hospitals
                                          .map(
                                            (hospital) =>
                                                DropdownMenuItem<String>(
                                              value: hospital.id,
                                              child: Text(hospital.name),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) async {
                                        if (value == null) {
                                          return;
                                        }
                                        final hospital = hospitals.firstWhere(
                                          (item) => item.id == value,
                                        );
                                        await provider.selectHospital(
                                          id: hospital.id,
                                          name: hospital.name,
                                        );
                                        field.didChange(value);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            FormField<String>(
                              initialValue: provider.departmentId.isEmpty
                                  ? null
                                  : provider.departmentId,
                              validator: (value) => ValidatorService.requiredField(
                                value,
                                fieldName: 'Bölüm',
                              ),
                              builder: (field) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Bölüm',
                                    errorText: field.errorText,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      key: const ValueKey('dropdown_bolum'),
                                      value: provider.departmentId.isEmpty
                                          ? null
                                          : provider.departmentId,
                                      isExpanded: true,
                                      hint: const Text('Bölüm seçiniz'),
                                      items: departments
                                          .map(
                                            (department) =>
                                                DropdownMenuItem<String>(
                                              value: department.id,
                                              child: Text(department.name),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) async {
                                        if (value == null) {
                                          return;
                                        }
                                        final department =
                                            departments.firstWhere(
                                          (item) => item.id == value,
                                        );
                                        await provider.selectDepartment(
                                          id: department.id,
                                          name: department.name,
                                        );
                                        field.didChange(value);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 16),
                            FormField<String>(
                              initialValue: provider.doctorId.isEmpty
                                  ? null
                                  : provider.doctorId,
                              validator: (value) => ValidatorService.requiredField(
                                value,
                                fieldName: 'Doktor',
                              ),
                              builder: (field) {
                                return InputDecorator(
                                  decoration: InputDecoration(
                                    labelText: 'Doktor',
                                    errorText: field.errorText,
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      key: const ValueKey('dropdown_doktor'),
                                      value: provider.doctorId.isEmpty
                                          ? null
                                          : provider.doctorId,
                                      isExpanded: true,
                                      hint: const Text('Doktor seçiniz'),
                                      items: doctors
                                          .map(
                                            (doctor) => DropdownMenuItem<String>(
                                              value: doctor.id,
                                              child: Text(doctor.name),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (value) async {
                                        if (value == null) {
                                          return;
                                        }
                                        final doctor = doctors.firstWhere(
                                          (item) => item.id == value,
                                        );
                                        await _selectDoctor(provider, doctor);
                                        field.didChange(value);
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                            if (doctors.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              Text(
                                'Uygun Doktorlar',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w700),
                              ),
                              const SizedBox(height: 12),
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: doctors.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: 10),
                                itemBuilder: (context, index) {
                                  final doctor = doctors[index];
                                  final isSelected = provider.doctorId == doctor.id;
                                  return ListTile(
                                    key: ValueKey('doktor_item_$index'),
                                    tileColor: isSelected
                                        ? Theme.of(context)
                                            .colorScheme
                                            .primary
                                            .withOpacity(0.08)
                                        : Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18),
                                    ),
                                    leading: CircleAvatar(
                                      backgroundColor: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.12),
                                      child: Text(
                                        doctor.name.split(' ').last.substring(0, 1),
                                      ),
                                    ),
                                    title: Text(doctor.name),
                                    subtitle: Text(doctor.specialty),
                                    trailing: Text(
                                      doctor.rating.toStringAsFixed(1),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    onTap: () => _selectDoctor(provider, doctor),
                                  );
                                },
                              ),
                            ],
                            if (provider.doctorId.isNotEmpty) ...[
                              const SizedBox(height: 24),
                              _DoctorCard(
                                name: provider.doctorName,
                                specialty: provider.doctorSpecialty,
                                city: provider.cityName,
                                hospital: provider.hospitalName,
                                department: provider.departmentName,
                                rating: provider.doctorRating ?? 0,
                              ),
                            ],
                            const SizedBox(height: 28),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    key: const ValueKey('btn_geri'),
                                    onPressed: () async {
                                      await provider.goToStep(2);
                                      if (!context.mounted) {
                                        return;
                                      }
                                      Navigator.pushReplacementNamed(
                                        context,
                                        Step2InsuranceScreen.routeName,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white,
                                      foregroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      side: BorderSide(
                                        color:
                                            Theme.of(context).colorScheme.primary,
                                      ),
                                    ),
                                    child: const Text('Geri'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    key: const ValueKey('btn_ileri'),
                                    onPressed: () async {
                                      if (provider.cityId.isEmpty ||
                                          provider.hospitalId.isEmpty ||
                                          provider.departmentId.isEmpty ||
                                          provider.doctorId.isEmpty) {
                                        UIHelper.showSnackBar(
                                          context,
                                          'Lütfen şehir, hastane, bölüm ve doktor seçimini tamamlayın.',
                                          isError: true,
                                        );
                                        return;
                                      }
                                      await provider.goToStep(4);
                                      if (!context.mounted) {
                                        return;
                                      }
                                      UIHelper.showSnackBar(
                                        context,
                                        'Doktor seçimi kaydedildi.',
                                      );
                                      Navigator.pushReplacementNamed(
                                        context,
                                        Step4DateTimeScreen.routeName,
                                      );
                                    },
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

  Future<void> _selectDoctor(
    AppointmentProvider provider,
    Doctor doctor,
  ) async {
    await provider.selectDoctor(
      id: doctor.id,
      name: doctor.name,
      specialty: doctor.specialty,
      rating: doctor.rating,
      imageUrl: doctor.imageUrl,
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

class _DoctorCard extends StatelessWidget {
  const _DoctorCard({
    required this.name,
    required this.specialty,
    required this.city,
    required this.hospital,
    required this.department,
    required this.rating,
  });

  final String name;
  final String specialty;
  final String city;
  final String hospital;
  final String department;
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor:
                    Theme.of(context).colorScheme.primary.withOpacity(0.18),
                child: const Icon(Icons.person_rounded),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(specialty),
                  ],
                ),
              ),
              Chip(
                label: Text('Puan ${rating.toStringAsFixed(1)}'),
                avatar: const Icon(Icons.star_rounded, color: Colors.amber),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text('Şehir: $city'),
          Text('Hastane: $hospital'),
          Text('Bölüm: $department'),
        ],
      ),
    );
  }
}
