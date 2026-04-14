class MedicalHistory {
  final int id;
  final String recordType;
  final String title;
  final String? description;
  final String? diagnosisDate;
  final String? notes;
  final String createdAt;

  MedicalHistory({
    required this.id,
    required this.recordType,
    required this.title,
    this.description,
    this.diagnosisDate,
    this.notes,
    required this.createdAt,
  });

  factory MedicalHistory.fromJson(Map<String, dynamic> json) {
    return MedicalHistory(
      id: json['id'],
      recordType: json['recordType'] ?? 'Unknown',
      title: json['title'] ?? 'Untitled',
      description: json['description'],
      diagnosisDate: json['diagnosisDate'],
      notes: json['notes'],
      createdAt: json['createdAt'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'recordType': recordType,
      'title': title,
      'description': description,
      'diagnosisDate': diagnosisDate,
      'notes': notes,
      'createdAt': createdAt,
    };
  }
}
