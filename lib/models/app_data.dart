import 'location_data.dart';

class AppData {
  const AppData({
    required this.existingTcs,
    required this.insuranceCompanies,
    required this.chronicDiseases,
    required this.servicesPricing,
    required this.locations,
    required this.bookedSlots,
  });

  final List<String> existingTcs;
  final List<String> insuranceCompanies;
  final List<String> chronicDiseases;
  final Map<String, int> servicesPricing;
  final List<City> locations;
  final Map<String, List<String>> bookedSlots;

  factory AppData.fromJson(Map<String, dynamic> json) {
    return AppData(
      existingTcs: (json['existing_tcs'] as List<dynamic>? ?? <dynamic>[])
          .map((item) => item.toString())
          .toList(growable: false),
      insuranceCompanies:
          (json['insurance_companies'] as List<dynamic>? ?? <dynamic>[])
              .map((item) => item.toString())
              .toList(growable: false),
      chronicDiseases:
          (json['chronic_diseases'] as List<dynamic>? ?? <dynamic>[])
              .map((item) => item.toString())
              .toList(growable: false),
      servicesPricing: (json['services_pricing'] as Map<String, dynamic>? ??
              <String, dynamic>{})
          .map(
        (key, value) => MapEntry(key, (value as num?)?.toInt() ?? 0),
      ),
      locations: (json['locations'] as List<dynamic>? ?? <dynamic>[])
          .map((item) => City.fromJson(item as Map<String, dynamic>))
          .toList(growable: false),
      bookedSlots: (json['booked_slots'] as Map<String, dynamic>? ??
              <String, dynamic>{})
          .map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>).map((slot) => slot.toString()).toList(),
        ),
      ),
    );
  }
}
