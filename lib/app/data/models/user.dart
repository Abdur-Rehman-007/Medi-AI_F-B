class User {
  final String id;
  String name; // Made mutable for profile updates
  final String email;
  final String role; // Student, Doctor, Admin, Faculty
  final String? department;
  final bool emailVerified;
  String? phone; // Made mutable
  final String? profileImage;
  final String? cmsId; // CMS ID for all users

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.department, // Optional for Doctors and Admins
    required this.emailVerified, // Default to false
    this.phone, // Optional
    this.profileImage,
    this.cmsId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    var u = User(
        id: json['userId']?.toString() ?? "",
        name: json['fullName'] ?? '',
        email: json['email'] ?? '',
        role: json['role'] ?? 'Student',
        department: json['department'],
        emailVerified: json['isEmailVerified'] ?? false,
        phone: json['phoneNumber'],
        profileImage: json['profileImageUrl'],
        //cmsId: json['cmsId'],
        cmsId: json['registrationNumber'] ?? json['cmsId']);

    return u;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'department': department,
      'emailVerified': emailVerified,
      'phone': phone,
      'profileImage': profileImage,
      'cmsId': cmsId,
    };
  }

  bool get isStudent => role.toLowerCase() == 'student';
  bool get isFaculty => role.toLowerCase() == 'faculty';
  bool get isDoctor => role.toLowerCase() == 'doctor';
  bool get isAdmin => role.toLowerCase() == 'admin';
  bool get isStudentOrFaculty => isStudent || isFaculty;
}
