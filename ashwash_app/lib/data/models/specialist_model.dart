class SpecialistModel {
  final int id;
  final String name;
  final String titleEn;
  final String titleBn;
  final String bioEn;
  final String bioBn;
  final int experienceYears;
  final double rating;
  final int feeBdt;
  final String locationType;
  final bool isAvailable;
  final bool isOnline;

  SpecialistModel({
    required this.id,
    required this.name,
    required this.titleEn,
    required this.titleBn,
    required this.bioEn,
    required this.bioBn,
    required this.experienceYears,
    required this.rating,
    required this.feeBdt,
    required this.locationType,
    required this.isAvailable,
    required this.isOnline,
  });

  factory SpecialistModel.fromJson(Map<String, dynamic> json) {
    return SpecialistModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      titleEn: json['title_en'] ?? '',
      titleBn: json['title_bn'] ?? '',
      bioEn: json['bio_en'] ?? '',
      bioBn: json['bio_bn'] ?? '',
      experienceYears: json['experience_years'] ?? 10,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
      feeBdt: json['fee_bdt'] ?? 1500,
      locationType: json['location_type'] ?? 'local',
      isAvailable: json['is_available'] ?? true,
      isOnline: json['is_online'] ?? true,
    );
  }
}
