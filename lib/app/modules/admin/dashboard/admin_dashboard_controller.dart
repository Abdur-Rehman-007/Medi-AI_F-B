import 'package:get/get.dart';
import '../../../data/models/user.dart';
import '../../../services/auth_service.dart';
import '../../../services/api_service.dart';
import '../../../routes/app_routes.dart';

class AdminDashboardController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _apiService = Get.find<ApiService>();

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxBool isLoading = false.obs;

  // Statistics
  final RxInt totalUsers = 0.obs;
  final RxInt totalStudents = 0.obs;
  final RxInt totalFaculty = 0.obs;
  final RxInt totalDoctors = 0.obs;
  final RxInt totalAppointments = 0.obs;
  final RxInt todayAppointments = 0.obs;
  final RxInt pendingVerifications = 0.obs;
  final RxInt systemAlerts = 0.obs;

  // Recent activities
  final RxList<Map<String, dynamic>> recentActivities =
      <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> notifications =
      <Map<String, dynamic>>[].obs;
  final RxList<User> recentUsers = <User>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      currentUser.value = await _authService.getCurrentUser();
      await Future.wait([
        loadStatistics(),
        loadRecentActivities(),
        loadRecentUsers(),
        loadNotifications(),
      ]);
    } catch (e) {
      print('Error loading dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStatistics() async {
    try {
      final response = await _apiService.get('/Admin/statistics');
      if (response.success && response.data != null) {
        final data = response.data;
        if (data is Map<String, dynamic>) {
          totalUsers.value = (data['totalUsers'] as num?)?.toInt() ?? 0;
          totalStudents.value = (data['totalStudents'] as num?)?.toInt() ?? 0;
          totalFaculty.value = (data['totalFaculty'] as num?)?.toInt() ?? 0;
          totalDoctors.value = (data['totalDoctors'] as num?)?.toInt() ?? 0;
          totalAppointments.value =
              (data['totalAppointments'] as num?)?.toInt() ?? 0;
          todayAppointments.value =
              (data['todayAppointments'] as num?)?.toInt() ?? 0;
          pendingVerifications.value =
              (data['pendingVerifications'] as num?)?.toInt() ?? 0;
          systemAlerts.value = (data['systemAlerts'] as num?)?.toInt() ?? 0;
        }
      }
    } catch (e) {
      print('Error loading statistics: $e');
      totalUsers.value = 0;
      totalStudents.value = 0;
      totalFaculty.value = 0;
      totalDoctors.value = 0;
      totalAppointments.value = 0;
      todayAppointments.value = 0;
      pendingVerifications.value = 0;
      systemAlerts.value = 0;
    }
  }

  Future<void> loadRecentActivities() async {
    try {
      final response = await _apiService.get('/Admin/recent-activities');
      if (response.success && response.data != null) {
        recentActivities.value = List<Map<String, dynamic>>.from(response.data);
      }
    } catch (e) {
      print('Error loading activities: $e');
    }
  }

  Future<void> loadRecentUsers() async {
    try {
      final response = await _apiService.get('/Admin/recent-users');
      if (response.success && response.data != null) {
        recentUsers.value =
            (response.data as List).map((json) => User.fromJson(json)).toList();
      }
    } catch (e) {
      print('Error loading recent users: $e');
    }
  }

  Future<void> loadNotifications() async {
    try {
      final response = await _apiService.get('/Admin/notifications');
      if (response.success && response.data != null) {
        notifications.value = List<Map<String, dynamic>>.from(response.data);
      }
    } catch (e) {
      print('Error loading notifications: $e');
    }
  }

  @override
  Future<void> refresh() async {
    await loadDashboardData();
  }

  // Navigation methods
  void manageUsers() {
    Get.toNamed(AppRoutes.manageUsers);
  }

  void manageDoctors() {
    Get.toNamed(AppRoutes.manageDoctors);
  }

  void viewReports() {
    Get.toNamed(AppRoutes.reports);
  }

  void systemSettings() {
    Get.toNamed(AppRoutes.systemSettings);
  }

  void viewAllAppointments() {
    Get.toNamed(AppRoutes.myAppointments);
  }

  void viewProfile() {
    Get.toNamed(AppRoutes.profile);
  }

  void viewSettings() {
    Get.toNamed(AppRoutes.settings);
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }
}
