class AppConfig {
  // API Configuration
  // TODO: Update this to your backend URL

  // Company WiFi (Commented out)
  // static const String baseUrl = 'http://192.168.18.86:5279/api';

  // Hostel WiFi (Current) - USE localhost for Chrome/Web to avoid CORS/Connection errors
  // static const String baseUrl = 'http://192.168.100.111:5279/api';
  static const String baseUrl = 'http://localhost:5281/api';

  // Use this for Mobile APK Release (Local Network Testing)
  //static const String baseUrl = 'http://192.168.100.111:5281/api';

  // For production: 'https://your-backend.azurewebsites.net/api'
  // Increased timeouts to handle slower local/dev backends and network latency
  static const Duration connectionTimeout = Duration(seconds: 60);
  static const Duration receiveTimeout = Duration(seconds: 60);

  // JWT Configuration
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userDataKey = 'user_data';

  // BUITEMS Configuration
  static const String allowedEmailDomain = '@student.buitms.edu.pk';
  static const String universityName = 'BUITEMS Medical Center';

  // App Configuration
  static const String appName = 'Medi-AI';
  static const String appVersion = '1.0.0';

  // Cache Configuration
  static const Duration cacheMaxAge = Duration(minutes: 5);

  // Notification Configuration
  static const String fcmTopicAll = 'all_users';
  static const String fcmTopicStudents = 'students';
  static const String fcmTopicDoctors = 'doctors';

  // // Backend Integration Status
  // static const bool useRealBackend = true; // Always use real backend

  // Backend flag
  static const bool useRealBackend = true;

  // API Endpoints
  static const String authLoginEndpoint = '$baseUrl/Auth/login';
  static const String authRegisterEndpoint = '$baseUrl/Auth/register';
  static const String authSendOtpEndpoint = '$baseUrl/Auth/send-otp';
  static const String authVerifyOtpEndpoint = '$baseUrl/Auth/verify-otp';
  static const String authRefreshTokenEndpoint = '$baseUrl/Auth/refresh-token';
}
