class SystemSettingsModel {
  bool maintenanceMode;
  bool emailNotifications;
  bool smsNotifications;
  bool autoApproveRegistrations;
  bool requireEmailVerification;
  bool twoFactorAuth;
  int sessionTimeoutMinutes;
  int maxLoginAttempts;
  String systemName;
  String contactEmail;
  String supportEmail;

  SystemSettingsModel({
    this.maintenanceMode = false,
    this.emailNotifications = true,
    this.smsNotifications = false,
    this.autoApproveRegistrations = false,
    this.requireEmailVerification = true,
    this.twoFactorAuth = false,
    this.sessionTimeoutMinutes = 30,
    this.maxLoginAttempts = 5,
    this.systemName = '',
    this.contactEmail = '',
    this.supportEmail = '',
  });

  factory SystemSettingsModel.fromJson(Map<String, dynamic> json) {
    return SystemSettingsModel(
      maintenanceMode: json['maintenanceMode'] ?? false,
      emailNotifications: json['emailNotifications'] ?? true,
      smsNotifications: json['smsNotifications'] ?? false,
      autoApproveRegistrations: json['autoApproveRegistrations'] ?? false,
      requireEmailVerification: json['requireEmailVerification'] ?? true,
      twoFactorAuth: json['twoFactorAuth'] ?? false,
      sessionTimeoutMinutes: json['sessionTimeoutMinutes'] ?? 30,
      maxLoginAttempts: json['maxLoginAttempts'] ?? 5,
      systemName: json['systemName'] ?? '',
      contactEmail: json['contactEmail'] ?? '',
      supportEmail: json['supportEmail'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'maintenanceMode': maintenanceMode,
      'emailNotifications': emailNotifications,
      'smsNotifications': smsNotifications,
      'autoApproveRegistrations': autoApproveRegistrations,
      'requireEmailVerification': requireEmailVerification,
      'twoFactorAuth': twoFactorAuth,
      'sessionTimeoutMinutes': sessionTimeoutMinutes,
      'maxLoginAttempts': maxLoginAttempts,
      'systemName': systemName,
      'contactEmail': contactEmail,
      'supportEmail': supportEmail,
    };
  }
}
