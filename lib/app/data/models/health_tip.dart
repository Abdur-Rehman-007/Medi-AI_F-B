class HealthTip {
  final String id;
  final String title;
  final String content;
  final String category; // General, Nutrition, Exercise, Mental Health
  final String? doctorId;
  final String? doctorName;
  final DateTime createdAt;

  HealthTip({
    required this.id,
    required this.title,
    required this.content,
    required this.category,
    this.doctorId,
    this.doctorName,
    required this.createdAt,
  });

  factory HealthTip.fromJson(Map<String, dynamic> json) {
    return HealthTip(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      category: json['category'] ?? 'General',
      doctorId: json['doctorId'],
      doctorName: json['doctorName'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'category': category,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
