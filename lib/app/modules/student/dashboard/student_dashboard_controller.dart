import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../services/auth_service.dart';
import '../../../services/api_service.dart';
import '../../../data/models/appointment.dart';
import '../../../data/models/user.dart';
import '../../../routes/app_routes.dart';
import 'package:medi_ai/config/app_config.dart';

class StudentDashboardController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _apiService = Get.find<ApiService>();

  final RxBool isLoading = false.obs;
  final RxList<Appointment> upcomingAppointments = <Appointment>[].obs;
  final RxList<Appointment> recentAppointments = <Appointment>[].obs;
  final Rx<User?> currentUser = Rx<User?>(null);

  // Statistics (to align with faculty dashboard layout)
  final RxInt totalAppointments = 0.obs;
  final RxInt completedAppointments = 0.obs;
  final RxInt upcomingCount = 0.obs;

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
        _loadUpcomingAppointments(),
        _loadRecentAppointments(),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadUpcomingAppointments() async {
    try {
      final response = await _apiService.get(
        '${AppConfig.baseUrl}/Appointments/student/${currentUser.value?.id}/upcoming',
      );
      if (response.success && response.data is List) {
        final list = response.data as List;
        upcomingAppointments.value =
            list.map((json) => Appointment.fromJson(json)).toList();
      } else {
        upcomingAppointments.clear();
      }

      _recomputeStatistics();
    } catch (e) {
      print('Error loading appointments: $e');
      upcomingAppointments.clear();
      _recomputeStatistics();
    }
  }

  Future<void> _loadRecentAppointments() async {
    try {
      final response = await _apiService.get(
        '${AppConfig.baseUrl}/Appointments/student/${currentUser.value?.id}/history',
      );
      if (response.success && response.data is List) {
        final now = DateTime.now();
        final thirtyDaysAgo = now.subtract(const Duration(days: 30));
        final list = response.data as List;
        recentAppointments.value = list
            .map((json) => Appointment.fromJson(json))
            .where((a) => a.dateTime.isAfter(thirtyDaysAgo))
            .toList();
      } else {
        recentAppointments.clear();
      }

      _recomputeStatistics();
    } catch (e) {
      print('Error loading history: $e');
      recentAppointments.clear();
      _recomputeStatistics();
    }
  }

  void _recomputeStatistics() {
    upcomingCount.value = upcomingAppointments.length;

    final completed = recentAppointments
        .where((a) => a.status.toLowerCase() == 'completed')
        .length;
    completedAppointments.value = completed;

    totalAppointments.value =
        upcomingAppointments.length + recentAppointments.length;
  }

  void goToBookAppointment() {
    Get.toNamed(AppRoutes.bookAppointment);
  }

  void goToMyAppointments() {
    Get.toNamed(AppRoutes.myAppointments);
  }

  void goToAIChecker() {
    Get.toNamed(AppRoutes.aiSymptomChecker);
  }

  void goToMedicineReminders() {
    Get.toNamed(AppRoutes.medicineReminders);
  }

  void goToHealthTips() {
    Get.toNamed(AppRoutes.healthTips);
  }

  void goToMedicalHistory() {
    Get.toNamed(AppRoutes.medicalHistory);
  }

  void goToEmergencyContacts() {
    Get.toNamed(AppRoutes.emergencyContacts);
  }

  void goToProfile() {
    Get.toNamed(AppRoutes.profile);
  }

  Future<void> logout() async {
    await _authService.logout();
    Get.offAllNamed(AppRoutes.login);
  }

  Future<void> updateAppointment(String appointmentId, String doctorId,
      DateTime newDate, String newTime, String symptoms, String notes) async {
    isLoading.value = true;
    try {
      final dateTimeStr =
          '${DateFormat('yyyy-MM-dd').format(newDate)}T$newTime:00';

      final data = {
        'doctorId': doctorId,
        'dateTime': dateTimeStr,
        'symptoms': symptoms,
        'notes': notes
      };

      final response = await _apiService
          .put('${AppConfig.baseUrl}/Appointments/$appointmentId', data: data);

      if (response.success) {
        await refresh(); // Reload lists
        if (Get.isDialogOpen ?? false) Get.back(); // Close dialog
        Get.snackbar('Success', 'Appointment updated successfully',
            backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update appointment: $e');
    } finally {
      isLoading.value = false;
    }
  }

  bool canEditAppointment(Appointment appointment) {
    if (appointment.status != 'Pending') return false;

    final appointmentDateTime = appointment.dateTime;
    final now = DateTime.now();
    final difference = appointmentDateTime.difference(now).inMinutes;

    // Allow edit only if appointment is more than 30 minutes away
    return difference > 30;
  }

  Future<void> cancelAppointment(String appointmentId) async {
    isLoading.value = true;
    try {
      final response = await _apiService
          .delete('${AppConfig.baseUrl}/Appointments/$appointmentId');
      if (response.success) {
        await refresh();
        Get.snackbar('Success', 'Appointment cancelled',
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel: $e');
    } finally {
      isLoading.value = false;
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning';
    if (hour < 17) return 'Good Afternoon';
    return 'Good Evening';
  }

  @override
  Future<void> refresh() async {
    await loadDashboardData();
  }
}
