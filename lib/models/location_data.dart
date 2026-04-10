import 'doctor.dart';

class Department {
  const Department({
    required this.id,
    required this.name,
    required this.doctors,
  });

  final String id;
  final String name;
  final List<Doctor> doctors;

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      id: json['department_id'] as String? ?? '',
      name: json['department_name'] as String? ?? '',
      doctors: (json['doctors'] as List<dynamic>? ?? <dynamic>[])
          .map((doctor) => Doctor.fromJson(doctor as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}

class Hospital {
  const Hospital({
    required this.id,
    required this.name,
    required this.departments,
  });

  final String id;
  final String name;
  final List<Department> departments;

  factory Hospital.fromJson(Map<String, dynamic> json) {
    return Hospital(
      id: json['hospital_id'] as String? ?? '',
      name: json['hospital_name'] as String? ?? '',
      departments: (json['departments'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (department) =>
                Department.fromJson(department as Map<String, dynamic>),
          )
          .toList(growable: false),
    );
  }
}

class City {
  const City({
    required this.id,
    required this.name,
    required this.hospitals,
  });

  final String id;
  final String name;
  final List<Hospital> hospitals;

  factory City.fromJson(Map<String, dynamic> json) {
    return City(
      id: json['city_id'] as String? ?? '',
      name: json['city_name'] as String? ?? '',
      hospitals: (json['hospitals'] as List<dynamic>? ?? <dynamic>[])
          .map((hospital) => Hospital.fromJson(hospital as Map<String, dynamic>))
          .toList(growable: false),
    );
  }
}
