class Appointment {
  final String id;
  final String patientId;
  final String patientName;
  final String doctorId;
  final String doctorName;
  final String specialization;
  final DateTime dateTime;
  final String status; // Pending, Confirmed, Completed, Cancelled
  final String? symptoms;
  final String? notes;
  final String? prescription;
  final DateTime createdAt;

  // Convenience getters
  String get reason => symptoms ?? 'General Consultation';
  DateTime get appointmentDate => dateTime;

  Appointment({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.doctorId,
    required this.doctorName,
    required this.specialization,
    required this.dateTime,
    required this.status,
    this.symptoms,
    this.notes,
    this.prescription,
    required this.createdAt,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? '',
      patientId: json['patientId'] ?? '',
      patientName: json['patientName'] ?? '',
      doctorId: json['doctorId'] ?? '',
      doctorName: json['doctorName'] ?? '',
      specialization: json['specialization'] ?? '',
      dateTime: DateTime.parse(json['dateTime']),
      status: json['status'] ?? 'Pending',
      symptoms: json['symptoms'],
      notes: json['notes'],
      prescription: json['prescription'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'patientName': patientName,
      'doctorId': doctorId,
      'doctorName': doctorName,
      'specialization': specialization,
      'dateTime': dateTime.toIso8601String(),
      'status': status,
      'symptoms': symptoms,
      'notes': notes,
      'prescription': prescription,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  bool get isPending => status.toLowerCase() == 'pending';
  bool get isConfirmed => status.toLowerCase() == 'confirmed';
  bool get isCompleted => status.toLowerCase() == 'completed';
  bool get isCancelled => status.toLowerCase() == 'cancelled';
  bool get canCancel => isPending || isConfirmed;
  bool get canReschedule => isPending;
}
