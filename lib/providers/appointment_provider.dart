import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

import '../models/app_data.dart';
import '../models/doctor.dart';
import '../models/location_data.dart';
import '../services/data_service.dart';
import '../services/storage_service.dart';

class AppointmentProvider extends ChangeNotifier {
  AppointmentProvider({
    DataService? dataService,
    StorageService? storageService,
  })  : _dataService = dataService ?? const DataService(),
        _storageService = storageService ?? const StorageService();

  final DataService _dataService;
  final StorageService _storageService;

  int _currentStep = 1;
  bool _initialized = false;
  bool _isLoadingData = false;
  AppData? _appData;
  String? _dataLoadError;

  final Map<String, dynamic> _draft = _initialDraft();

  int get currentStep => _currentStep;
  bool get initialized => _initialized;
  bool get isLoadingData => _isLoadingData;
  String? get dataLoadError => _dataLoadError;
  AppData? get appData => _appData;
  Map<String, dynamic> get draft => Map<String, dynamic>.unmodifiable(_draft);

  List<City> get cities => _appData?.locations ?? const <City>[];
  List<String> get existingTcs => _appData?.existingTcs ?? const <String>[];
  List<String> get insuranceCompanies =>
      _appData?.insuranceCompanies ?? const <String>[];
  List<String> get chronicDiseases =>
      _appData?.chronicDiseases ?? const <String>[];
  Map<String, int> get servicesPricing =>
      _appData?.servicesPricing ?? const <String, int>{};
  Map<String, List<String>> get bookedSlots =>
      _appData?.bookedSlots ?? const <String, List<String>>{};

  String get firstName => _draft['firstName'] as String? ?? '';
  String get lastName => _draft['lastName'] as String? ?? '';
  String get tcKimlik => _draft['tcKimlik'] as String? ?? '';
  String get email => _draft['email'] as String? ?? '';
  String get phone => _draft['phone'] as String? ?? '';
  String get birthDate => _draft['birthDate'] as String? ?? '';
  String get address => _draft['address'] as String? ?? '';
  String get gender => _draft['gender'] as String? ?? 'erkek';
  String get insuranceType => _draft['insuranceType'] as String? ?? '';
  String get insuranceCompany => _draft['insuranceCompany'] as String? ?? '';
  bool get hasAllergy => _draft['hasAllergy'] as bool? ?? false;
  String get allergyDetails => _draft['allergyDetails'] as String? ?? '';
  String get cityId => _draft['cityId'] as String? ?? '';
  String get cityName => _draft['cityName'] as String? ?? '';
  String get hospitalId => _draft['hospitalId'] as String? ?? '';
  String get hospitalName => _draft['hospitalName'] as String? ?? '';
  String get departmentId => _draft['departmentId'] as String? ?? '';
  String get departmentName => _draft['departmentName'] as String? ?? '';
  String get doctorId => _draft['doctorId'] as String? ?? '';
  String get doctorName => _draft['doctorName'] as String? ?? '';
  String get doctorSpecialty => _draft['doctorSpecialty'] as String? ?? '';
  double? get doctorRating => (_draft['doctorRating'] as num?)?.toDouble();
  String get doctorImageUrl => _draft['doctorImageUrl'] as String? ?? '';
  String get appointmentDate => _draft['appointmentDate'] as String? ?? '';
  String get appointmentTime => _draft['appointmentTime'] as String? ?? '';
  bool get isUrgent => _draft['isUrgent'] as bool? ?? false;
  String get notes => _draft['notes'] as String? ?? '';
  bool get extraBloodTest => _draft['extraBloodTest'] as bool? ?? false;
  bool get extraMr => _draft['extraMr'] as bool? ?? false;
  bool get extraXray => _draft['extraXray'] as bool? ?? false;
  int get companionCount => _draft['companionCount'] as int? ?? 0;
  bool get kvkkApproved => _draft['kvkkApproved'] as bool? ?? false;
  bool get explicitConsentApproved =>
      _draft['explicitConsentApproved'] as bool? ?? false;
  String get confirmationCode => _draft['confirmationCode'] as String? ?? '';

  DateTime? get appointmentDateTime {
    if (appointmentDate.isEmpty || appointmentTime.isEmpty) {
      return null;
    }

    return DateTime.tryParse('${appointmentDate}T$appointmentTime');
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _isLoadingData = true;
    _dataLoadError = null;
    notifyListeners();

    try {
      final results = await Future.wait<dynamic>([
        _storageService.loadDraft(),
        _dataService.loadAppData(),
      ]);

      final storedDraft = results[0] as Map<String, dynamic>?;
      final loadedAppData = results[1] as AppData;

      if (storedDraft != null) {
        _currentStep = storedDraft['currentStep'] as int? ?? 1;
        final savedValues =
            (storedDraft['draft'] as Map?)?.cast<String, dynamic>() ??
                <String, dynamic>{};
        _draft.addAll(savedValues);
      }

      _appData = loadedAppData;
      _initialized = true;
    } catch (error) {
      _dataLoadError = error.toString();
    } finally {
      _isLoadingData = false;
      notifyListeners();
    }
  }

  List<Hospital> getHospitalsByCity(String city) {
    for (final item in cities) {
      if (item.id == city) {
        return item.hospitals;
      }
    }
    return const <Hospital>[];
  }

  List<Department> getDepartmentsByHospital(String city, String hospital) {
    for (final item in getHospitalsByCity(city)) {
      if (item.id == hospital) {
        return item.departments;
      }
    }
    return const <Department>[];
  }

  List<Doctor> getDoctorsByDepartment(
    String city,
    String hospital,
    String department,
  ) {
    for (final item in getDepartmentsByHospital(city, hospital)) {
      if (item.id == department) {
        return item.doctors;
      }
    }
    return const <Doctor>[];
  }

  bool isSlotBooked({
    required String doctorId,
    required DateTime date,
    required String time,
  }) {
    final bookedForDoctor = bookedSlots[doctorId] ?? const <String>[];
    final key = '${DateFormat('yyyy-MM-dd').format(date)}T$time';
    return bookedForDoctor.contains(key);
  }

  List<String> generateTimeSlots() {
    final slots = <String>[];
    for (int hour = 9; hour <= 17; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        if (hour == 17 && minute > 0) {
          continue;
        }
        slots.add(
          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}',
        );
      }
    }
    return slots;
  }

  int calculateTotalPrice() {
    int total = _priceForService(const <String>['base_examination']);
    if (extraBloodTest) {
      total += _priceForService(const <String>['Kan Tahlili']);
    }
    if (extraMr) {
      total += _priceForService(const <String>['MR']);
    }
    if (extraXray) {
      total += _priceForService(const <String>['Röntgen', 'RÃ¶ntgen']);
    }
    return total;
  }

  Future<void> goToStep(int step) async {
    if (step < 1 || step > 6 || step == _currentStep) {
      return;
    }

    _currentStep = step;
    await _persist();
    notifyListeners();
  }

  Future<void> updatePersonalInfo({
    required String firstName,
    required String lastName,
    required String tcKimlik,
    required String email,
    required String phone,
    required String birthDate,
    required String address,
    required String gender,
  }) async {
    _draft
      ..['firstName'] = firstName
      ..['lastName'] = lastName
      ..['tcKimlik'] = tcKimlik
      ..['email'] = email
      ..['phone'] = phone
      ..['birthDate'] = birthDate
      ..['address'] = address
      ..['gender'] = gender;

    await _persist();
    notifyListeners();
  }

  Future<void> updateInsuranceInfo({
    required String insuranceType,
    required String insuranceCompany,
    required bool hasAllergy,
    required String allergyDetails,
  }) async {
    _draft
      ..['insuranceType'] = insuranceType
      ..['insuranceCompany'] = insuranceCompany
      ..['hasAllergy'] = hasAllergy
      ..['allergyDetails'] = allergyDetails;

    await _persist();
    notifyListeners();
  }

  Future<void> selectCity({
    required String id,
    required String name,
  }) async {
    _draft
      ..['cityId'] = id
      ..['cityName'] = name
      ..['hospitalId'] = ''
      ..['hospitalName'] = ''
      ..['departmentId'] = ''
      ..['departmentName'] = ''
      ..['doctorId'] = ''
      ..['doctorName'] = ''
      ..['doctorSpecialty'] = ''
      ..['doctorRating'] = null
      ..['doctorImageUrl'] = ''
      ..['appointmentDate'] = ''
      ..['appointmentTime'] = '';

    await _persist();
    notifyListeners();
  }

  Future<void> selectHospital({
    required String id,
    required String name,
  }) async {
    _draft
      ..['hospitalId'] = id
      ..['hospitalName'] = name
      ..['departmentId'] = ''
      ..['departmentName'] = ''
      ..['doctorId'] = ''
      ..['doctorName'] = ''
      ..['doctorSpecialty'] = ''
      ..['doctorRating'] = null
      ..['doctorImageUrl'] = ''
      ..['appointmentDate'] = ''
      ..['appointmentTime'] = '';

    await _persist();
    notifyListeners();
  }

  Future<void> selectDepartment({
    required String id,
    required String name,
  }) async {
    _draft
      ..['departmentId'] = id
      ..['departmentName'] = name
      ..['doctorId'] = ''
      ..['doctorName'] = ''
      ..['doctorSpecialty'] = ''
      ..['doctorRating'] = null
      ..['doctorImageUrl'] = ''
      ..['appointmentDate'] = ''
      ..['appointmentTime'] = '';

    await _persist();
    notifyListeners();
  }

  Future<void> selectDoctor({
    required String id,
    required String name,
    required String specialty,
    required double rating,
    required String imageUrl,
  }) async {
    _draft
      ..['doctorId'] = id
      ..['doctorName'] = name
      ..['doctorSpecialty'] = specialty
      ..['doctorRating'] = rating
      ..['doctorImageUrl'] = imageUrl
      ..['appointmentDate'] = ''
      ..['appointmentTime'] = '';

    await _persist();
    notifyListeners();
  }

  Future<void> updateDateTimeInfo({
    required DateTime appointmentDate,
    required String appointmentTime,
    required bool isUrgent,
    required String notes,
  }) async {
    _draft
      ..['appointmentDate'] = DateFormat('yyyy-MM-dd').format(appointmentDate)
      ..['appointmentTime'] = appointmentTime
      ..['isUrgent'] = isUrgent
      ..['notes'] = notes;

    await _persist();
    notifyListeners();
  }

  Future<void> updateExtrasInfo({
    required bool bloodTest,
    required bool mr,
    required bool xray,
    required int companionCount,
    required bool kvkkApproved,
    required bool explicitConsentApproved,
  }) async {
    _draft
      ..['extraBloodTest'] = bloodTest
      ..['extraMr'] = mr
      ..['extraXray'] = xray
      ..['companionCount'] = companionCount
      ..['kvkkApproved'] = kvkkApproved
      ..['explicitConsentApproved'] = explicitConsentApproved;

    await _persist();
    notifyListeners();
  }

  Future<String> completeAppointment() async {
    final code = 'MB-UUID-${_randomCode(5)}';
    _draft['confirmationCode'] = code;
    await _persist();
    notifyListeners();
    return code;
  }

  Future<void> clearSavedDraftOnly() {
    return _storageService.clearDraft();
  }

  Future<void> clearDraft() async {
    _currentStep = 1;
    _draft
      ..clear()
      ..addAll(_initialDraft());
    await _storageService.clearDraft();
    notifyListeners();
  }

  Future<void> _persist() {
    return _storageService.saveDraft(
      <String, dynamic>{
        'currentStep': _currentStep,
        'draft': _draft,
      },
    );
  }

  int _priceForService(List<String> keys) {
    for (final key in keys) {
      final price = servicesPricing[key];
      if (price != null) {
        return price;
      }
    }
    return 0;
  }

  String _randomCode(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    return List<String>.generate(
      length,
      (_) => chars[random.nextInt(chars.length)],
    ).join();
  }

  static Map<String, dynamic> _initialDraft() {
    return <String, dynamic>{
      'firstName': '',
      'lastName': '',
      'tcKimlik': '',
      'email': '',
      'phone': '',
      'birthDate': '',
      'address': '',
      'gender': 'erkek',
      'insuranceType': '',
      'insuranceCompany': '',
      'hasAllergy': false,
      'allergyDetails': '',
      'cityId': '',
      'cityName': '',
      'hospitalId': '',
      'hospitalName': '',
      'departmentId': '',
      'departmentName': '',
      'doctorId': '',
      'doctorName': '',
      'doctorSpecialty': '',
      'doctorRating': null,
      'doctorImageUrl': '',
      'appointmentDate': '',
      'appointmentTime': '',
      'isUrgent': false,
      'notes': '',
      'extraBloodTest': false,
      'extraMr': false,
      'extraXray': false,
      'companionCount': 0,
      'kvkkApproved': false,
      'explicitConsentApproved': false,
      'confirmationCode': '',
    };
  }
}
