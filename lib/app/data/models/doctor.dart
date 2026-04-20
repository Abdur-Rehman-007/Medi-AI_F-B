class Doctor {
  final String id;
  final String userId;
  final String name;
  final String email;
  final String specialization;
  final List<String> availableDays; // ["Monday", "Tuesday"]
  final String? startTime; // "09:00 AM"
  final String? endTime; // "05:00 PM"
  final String? profileImage;
  final String? qualification;
  final int? experience; // years
  final double? rating;
  final int? totalAppointments;

  Doctor({
    required this.id,
    required this.userId,
    required this.name,
    required this.email,
    required this.specialization,
    required this.availableDays,
    this.startTime,
    this.endTime,
    this.profileImage,
    this.qualification,
    this.experience,
    this.rating,
    this.totalAppointments,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      specialization: json['specialization'] ?? '',
      availableDays: json['availableDays'] != null
          ? List<String>.from(json['availableDays'])
          : [],
      startTime: json['startTime'],
      endTime: json['endTime'],
      profileImage: json['profileImage'],
      qualification: json['qualification'],
      experience: json['experience'],
      rating: json['rating']?.toDouble(),
      totalAppointments: json['totalAppointments'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'name': name,
      'email': email,
      'specialization': specialization,
      'availableDays': availableDays,
      'startTime': startTime,
      'endTime': endTime,
      'profileImage': profileImage,
      'qualification': qualification,
      'experience': experience,
      'rating': rating,
      'totalAppointments': totalAppointments,
    };
  }

  String get availabilityText =>
      availableDays.isNotEmpty ? availableDays.join(', ') : 'Not Available';
  String get timeSlotText =>
      startTime != null && endTime != null ? '$startTime - $endTime' : 'N/A';
}
