class CourseModel {
  final int id;
  final String titleEn;
  final String titleBn;
  final String descriptionEn;
  final String descriptionBn;
  final int durationWeeks;
  final int totalTasks;
  final String typeLabel;
  final double price;
  final bool isFree;
  final double rating;

  CourseModel({
    required this.id,
    required this.titleEn,
    required this.titleBn,
    required this.descriptionEn,
    required this.descriptionBn,
    required this.durationWeeks,
    required this.totalTasks,
    required this.typeLabel,
    required this.price,
    required this.isFree,
    required this.rating,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] ?? 0,
      titleEn: json['title_en'] ?? '',
      titleBn: json['title_bn'] ?? '',
      descriptionEn: json['description_en'] ?? '',
      descriptionBn: json['description_bn'] ?? '',
      durationWeeks: json['duration_weeks'] ?? 4,
      totalTasks: json['total_tasks'] ?? 10,
      typeLabel: json['type_label'] ?? 'Both',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      isFree: json['is_free'] ?? true,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.9,
    );
  }
}
