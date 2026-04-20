import 'package:get/get.dart';
import 'package:medi_ai/config/app_config.dart';
import '../data/models/user.dart';
import '../data/models/api_response.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService extends GetxService {
  final _apiService = Get.find<ApiService>();
  final _storageService = Get.find<StorageService>();

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isAuthenticated = false.obs;

  Future<AuthService> init() async {
    await _loadUser();
    return this;
  }

  Future<void> _loadUser() async {
    final user = await _storageService.getUser();
    if (user != null) {
      currentUser.value = user;
      isAuthenticated.value = true;
    }
  }

  // Register
  Future<ApiResponse<Map<String, dynamic>>> register({
    required String email,
    required String password,
    required String name,
    required String role,
    String? department,
    String? cmsId,
    String? phoneNumber,
    String? dateOfBirth,
    String? gender,
    String? address,
    String? specialization,
    String? licenseNumber,
    String? qualification,
    int? experience,
    String? roomNumber,
    String? bio,
  }) async {
    final requestData = {
      'Email': email,
      'Password': password,
      'FullName': name, // Backend C# property uses FullName (no space)
      'Role': role,
      'Department': department,
      'RegistrationNumber': cmsId,
      'PhoneNumber': phoneNumber,
      'DateOfBirth': dateOfBirth,
      'Gender': gender,
      'Address': address,
      'Specialization': specialization,
      'LicenseNumber': licenseNumber,
      'Qualification': qualification,
      'Experience': experience,
      'RoomNumber': roomNumber,
      'Bio': bio,
    };

    print('📤 Sending registration data to backend:');
    print('   Email: $email');
    print('   Role: $role');
    print('   Department: $department');
    print('   CMS ID (registrationNumber): $cmsId');
    print('   Phone: $phoneNumber');
    print('   DOB: $dateOfBirth');
    print('   Gender: $gender');

    final response = await _apiService.post<Map<String, dynamic>>(
      '${AppConfig.baseUrl}/Auth/register',
      data: requestData,
      fromJson: (json) => json as Map<String, dynamic>,
    );

    return response;
  }

  // Resend OTP
  Future<ApiResponse<dynamic>> resendOtp(String email) async {
    return await _apiService.post(
      '${AppConfig.baseUrl}/Auth/resend-otp',
      data: {'Email': email},
    );
  }

  // Verify OTP
  Future<ApiResponse<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await _apiService.post<Map<String, dynamic>>(
      '${AppConfig.baseUrl}/Auth/verify-otp',
      data: {
        'Email': email,
        'Otp': otp,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      await _saveAuthData(response.data!);
    }

    return response;
  }

  // Login
  Future<ApiResponse<Map<String, dynamic>>> login({
    required String email,
    required String password,
  }) async {
    // Real API call to backend
    final response = await _apiService.post<Map<String, dynamic>>(
      '${AppConfig.baseUrl}/Auth/login',
      data: {
        'Email': email,
        'Password': password,
      },
      fromJson: (json) => json as Map<String, dynamic>,
    );

    if (response.success && response.data != null) {
      await _saveAuthData(response.data!);
    }

    return response;
  }

  // Save auth data
  Future<void> _saveAuthData(Map<String, dynamic> data) async {
    // Support both camelCase and PascalCase response payloads.
    final token =
        data['token'] ?? data['Token'] ?? data['accessToken'] ?? data['AccessToken'];
    final refreshToken = data['refreshToken'] ??
        data['RefreshToken'] ??
        data['refresh_token'] ??
        data['Refresh_Token'];

    if (token is String && token.isNotEmpty) {
      await _storageService.saveAccessToken(token);
    }
    if (refreshToken is String && refreshToken.isNotEmpty) {
      await _storageService.saveRefreshToken(refreshToken);
    }

    // User may arrive nested (user/User) or flat (userId + role fields).
    final dynamic nestedUser = data['user'] ?? data['User'];
    if (nestedUser is Map) {
      final user = User.fromJson(Map<String, dynamic>.from(nestedUser));
      await _storageService.saveUser(user);
      currentUser.value = user;
      isAuthenticated.value = true;
      return;
    }

    final role = data['role'] ?? data['Role'];
    final userId = data['userId'] ?? data['UserId'] ?? data['id'] ?? data['Id'];
    if (role != null && userId != null) {
      final user = User(
        id: userId.toString(),
        email: (data['email'] ?? data['Email'] ?? '').toString(),
        name: (data['fullName'] ?? data['FullName'] ?? data['name'] ?? '').toString(),
        role: role.toString(),
        department: (data['department'] ?? data['Department'])?.toString(),
        emailVerified: (data['isEmailVerified'] ??
                data['emailVerified'] ??
                data['IsEmailVerified'] ??
                false) ==
            true,
        cmsId: (data['registrationNumber'] ?? data['RegistrationNumber'] ?? data['cmsId'])
            ?.toString(),
        phone: (data['phoneNumber'] ?? data['PhoneNumber'] ?? data['phone'])?.toString(),
      );
      await _storageService.saveUser(user);
      currentUser.value = user;
      isAuthenticated.value = true;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiService.post('${AppConfig.baseUrl}/Auth/logout');
    } catch (e) {
      // Continue with logout even if API call fails
    }

    await _storageService.clearAuthData();
    currentUser.value = null;
    isAuthenticated.value = false;
    Get.offAllNamed('/login');
  }

  // Get current user from API
  Future<User?> getCurrentUser() async {
    // Return cached user if available
    if (currentUser.value != null) {
      return currentUser.value;
    }

    // Try to load from storage
    final storedUser = await _storageService.getUser();
    if (storedUser != null) {
      currentUser.value = storedUser;
      return storedUser;
    }

    // Try to fetch from API (when backend is available)
    try {
      final response = await _apiService.get<User>(
        '${AppConfig.baseUrl}/Auth/current-user',
        fromJson: (json) => User.fromJson(json),
      );

      if (response.success && response.data != null) {
        await _storageService.saveUser(response.data!);
        currentUser.value = response.data;
        return response.data;
      }
    } catch (e) {
      // API not available, return stored user
    }

    return currentUser.value;
  }

  // Update profile
  Future<ApiResponse<User>> updateProfile({
    String? name,
    String? phone,
    String? department,
  }) async {
    final response = await _apiService.put<User>(
      '/Users/${currentUser.value?.id}',
      data: {
        'name': name,
        'phone': phone,
        'department': department,
      },
      fromJson: (json) => User.fromJson(json),
    );

    if (response.success && response.data != null) {
      await _storageService.saveUser(response.data!);
      currentUser.value = response.data;
    }

    return response;
  }

  /// Forgot Password — verifies email + phone number + CMS/registration number against DB.
  /// Returns reset token directly in response.data['resetToken'] — no email sent.
  Future<ApiResponse<Map<String, dynamic>>> forgotPassword({
    required String email,
    required String phoneNumber,
    required String registrationNumber,
  }) async {
    return await _apiService.post<Map<String, dynamic>>(
      '${AppConfig.baseUrl}/Auth/forgot-password',
      data: {
        'email': email,
        'phoneNumber': phoneNumber,
        'registrationNumber': registrationNumber,
      },
      fromJson: (json) => Map<String, dynamic>.from(json as Map),
    );
  }

  /// Reset Password — submit the token received from forgot-password + new password.
  Future<ApiResponse<void>> resetPassword({
    required String email,
    required String token,
    required String newPassword,
  }) async {
    return await _apiService.post<void>(
      '${AppConfig.baseUrl}/Auth/reset-password',
      data: {
        'email': email,
        'token': token,
        'newPassword': newPassword,
      },
      fromJson: (_) {},
    );
  }

  bool get isStudent => currentUser.value?.isStudent ?? false;
  bool get isDoctor => currentUser.value?.isDoctor ?? false;
  bool get isAdmin => currentUser.value?.isAdmin ?? false;
}
