class Doctor {
  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String specialty;
  final double rating;
  final String imageUrl;

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['doctor_id'] as String? ?? '',
      name: json['doctor_name'] as String? ?? '',
      specialty: json['specialty'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      imageUrl: json['image_url'] as String? ?? '',
    );
  }
}
