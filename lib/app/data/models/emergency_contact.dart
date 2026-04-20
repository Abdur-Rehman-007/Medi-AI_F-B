class EmergencyContact {
  final int id;
  final String contactName;
  final String relationship;
  final String phoneNumber;
  final String? email;
  final String? address;

  EmergencyContact({
    required this.id,
    required this.contactName,
    required this.relationship,
    required this.phoneNumber,
    this.email,
    this.address,
  });

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      id: json['id'],
      contactName: json['contactName'] ?? 'Unknown',
      relationship: json['relationship'] ?? 'Unknown',
      phoneNumber: json['phoneNumber'] ?? '',
      email: json['email'],
      address: json['address'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contactName': contactName,
      'relationship': relationship,
      'phoneNumber': phoneNumber,
      'email': email,
      'address': address,
    };
  }
}
