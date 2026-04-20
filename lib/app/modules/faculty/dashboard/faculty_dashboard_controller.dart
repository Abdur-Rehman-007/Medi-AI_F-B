import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/user.dart';
import '../../../data/models/appointment.dart';
import '../../../services/auth_service.dart';
import '../../../services/api_service.dart';
import '../../../routes/app_routes.dart';

class FacultyDashboardController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _apiService = Get.find<ApiService>();

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxList<Appointment> upcomingAppointments = <Appointment>[].obs;
  final RxList<Appointment> recentAppointments = <Appointment>[].obs;
  final RxBool isLoading = false.obs;

  // Statistics
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
        loadAppointments(),
        loadStatistics(),
        loadRecentAppointments(),
      ]);
    } catch (e) {
      print('Error loading dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAppointments() async {
    try {
      final response =
          await _apiService.get('/Appointments/Faculty/appointments');
      if (response.success && response.data != null) {
        upcomingAppointments.value = (response.data as List)
            .map((json) => Appointment.fromJson(json))
            .toList();
        upcomingCount.value = upcomingAppointments.length;
      }
    } catch (e) {
      print('Error loading appointments: $e');
    }
  }

  Future<void> loadRecentAppointments() async {
    try {
      final response =
          await _apiService.get('/Appointments/Faculty/appointments');
      if (response.success && response.data != null) {
        final now = DateTime.now();
        final thirtyDaysAgo = now.subtract(const Duration(days: 30));
        recentAppointments.value = (response.data as List)
            .map((json) => Appointment.fromJson(json))
            .where((a) => a.dateTime.isAfter(thirtyDaysAgo))
            .toList();
      }
    } catch (e) {
      print('Error loading recent appointments: $e');
    }
  }

  Future<void> loadStatistics() async {
    try {
      final response = await _apiService.get('/Faculty/statistics');
      if (response.success && response.data != null) {
        totalAppointments.value = response.data['totalAppointments'] ?? 0;
        completedAppointments.value =
            response.data['completedAppointments'] ?? 0;
      }
    } catch (e) {
      print('Error loading statistics: $e');
    }
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

      final response =
          await _apiService.put('/Appointments/$appointmentId', data: data);

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
      final response = await _apiService.delete('/Appointments/$appointmentId');
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

  @override
  Future<void> refresh() async {
    await loadDashboardData();
  }

  void bookAppointment() {
    Get.toNamed(AppRoutes.bookAppointment);
  }

  void viewAppointments() {
    Get.toNamed(AppRoutes.myAppointments);
  }

  void viewHealthTips() {
    Get.toNamed(AppRoutes.healthTips);
  }

  void aiSymptomChecker() {
    Get.toNamed(AppRoutes.aiSymptomChecker);
  }

  void medicineReminders() {
    Get.toNamed(AppRoutes.facultyMedicineReminders);
  }

  void viewMedicalHistory() {
    Get.toNamed(AppRoutes.medicalHistory);
  }

  void viewEmergencyContacts() {
    Get.toNamed(AppRoutes.emergencyContacts);
  }

  void viewProfile() {
    Get.toNamed(AppRoutes.profile);
  }

  void viewAppointment(Appointment appointment) {
    // Navigate to appointment detail
    Get.snackbar('Appointment', 'Viewing appointment details');
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
