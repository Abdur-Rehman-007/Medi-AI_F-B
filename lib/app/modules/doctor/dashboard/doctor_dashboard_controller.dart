import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/models/user.dart';
import '../../../data/models/appointment.dart';
import '../../../services/auth_service.dart';
import '../../../services/doctor_service.dart';
import '../../../services/notification_service.dart';
import '../../../routes/app_routes.dart';

class DoctorDashboardController extends GetxController {
  final _authService = Get.find<AuthService>();
  final _doctorService = Get.find<DoctorService>();
  final _notificationService = Get.find<NotificationService>();

  final Rx<User?> currentUser = Rx<User?>(null);
  final RxList<Appointment> todayAppointments = <Appointment>[].obs;
  final RxList<Appointment> upcomingAppointments = <Appointment>[].obs;
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> unreadNotifications = <Map<String, dynamic>>[].obs;

  // Statistics
  final RxInt totalPatientsToday = 0.obs;
  final RxInt completedToday = 0.obs;
  final RxInt pendingToday = 0.obs;
  final RxInt totalPatients = 0.obs;

  Timer? _notificationTimer;
  DateTime _lastCheckTime = DateTime.now();
  final Set<int> _shownNotificationIds = <int>{};

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
    _startNotificationPolling();
  }

  @override
  void onClose() {
    _notificationTimer?.cancel();
    super.onClose();
  }

  void _startNotificationPolling() {
    // Check every 30 seconds for new appointments
    _notificationTimer =
        Timer.periodic(const Duration(seconds: 30), (timer) async {
      final prefs = await SharedPreferences.getInstance();
      final notificationsEnabled = prefs.getBool('pushNotifications') ?? true;

      if (notificationsEnabled) {
        await _loadUnreadNotifications(showPopups: true);
      }
    });
  }

  Future<void> _checkForNewAppointments() async {
    try {
      // Check for appointments created since last check
      final response = await _doctorService.getUpcomingAppointments();
      if (response.success && response.data != null) {
        final newAppointments = response.data!
            .where((apt) => apt.createdAt.isAfter(_lastCheckTime))
            .toList();

        if (newAppointments.isNotEmpty) {
          Get.snackbar(
            'New Appointment',
            'You have ${newAppointments.length} new appointment(s)',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors
                .blue, // Using a basic color if AppTheme not available in scope directly, or import config
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
            onTap: (_) => viewAllAppointments(),
          );

          // Refresh data
          await loadDashboardData();
        }
      }
      // Always update check time to avoid re-notifying (though logic above handles it via creation time)
      // Actually, if we update check time ONLY on success, we might miss some if we fetch late?
      // No, we want to know about appointments created AFTER the last time we checked successfully.
      // So update _lastCheckTime to now ONLY if we successfully checked.
      _lastCheckTime = DateTime.now();
    } catch (e) {
      print('Error checking for new appointments: $e');
    }
  }

  Future<void> _loadUnreadNotifications({bool showPopups = false}) async {
    try {
      final response = await _doctorService.getUnreadNotifications();
      if (!response.success || response.data == null) {
        return;
      }

      unreadNotifications.value = response.data!;

      if (!showPopups) {
        return;
      }

      for (final item in unreadNotifications) {
        final id = int.tryParse((item['id'] ?? item['Id'] ?? '').toString());
        if (id == null || _shownNotificationIds.contains(id)) {
          continue;
        }

        _shownNotificationIds.add(id);

        final title = (item['title'] ?? item['Title'] ?? 'New Notification').toString();
        final message = (item['message'] ?? item['Message'] ?? '').toString();

        await _notificationService.showNotification(
          id: id,
          title: title,
          body: message,
          payload: id.toString(),
        );

        Get.snackbar(
          title,
          message,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      print('Error loading unread notifications: $e');
    }
  }

  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      currentUser.value = await _authService.getCurrentUser();
      await Future.wait([
        loadTodayAppointments(),
        loadUpcomingAppointments(),
        loadStatistics(),
        _loadUnreadNotifications(showPopups: true),
      ]);
    } catch (e) {
      print('Error loading dashboard: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadTodayAppointments() async {
    try {
      final response = await _doctorService.getTodayAppointments();
      if (response.success && response.data != null) {
        todayAppointments.value = response.data!;

        // Calculate today's statistics
        totalPatientsToday.value = todayAppointments.length;
        completedToday.value = todayAppointments
            .where((apt) => apt.status.toLowerCase() == 'completed')
            .length;
        pendingToday.value = todayAppointments
            .where((apt) => apt.status.toLowerCase() == 'scheduled')
            .length;
      }
    } catch (e) {
      print('Error loading today appointments: $e');
    }
  }

  Future<void> loadUpcomingAppointments() async {
    try {
      final response = await _doctorService.getUpcomingAppointments();
      if (response.success && response.data != null) {
        upcomingAppointments.value = response.data!;
      }
    } catch (e) {
      print('Error loading upcoming appointments: $e');
    }
  }

  Future<void> loadStatistics() async {
    try {
      final response = await _doctorService.getStatistics();
      if (response.success && response.data != null) {
        final data = response.data!;

        if (data['totalPatients'] != null) {
          totalPatients.value = data['totalPatients'];
        }

        // Use backend values if available (from new API), otherwise fallback to local calculation
        if (data['todayTotal'] != null) {
          // If the API returns it, use it directly
          totalPatientsToday.value = data['todayTotal'];
        }
        if (data['completedToday'] != null) {
          completedToday.value = data['completedToday'];
        }
        if (data['pendingToday'] != null) {
          pendingToday.value = data['pendingToday'];
        }
      }
    } catch (e) {
      print('Error loading statistics: $e');
    }
  }

  @override
  Future<void> refresh() async {
    await loadDashboardData();
  }

  void viewAppointment(Appointment appointment) {
    Get.toNamed(
      AppRoutes.appointmentDetail,
      arguments: {'appointment': appointment},
    );
  }

  void viewAllAppointments() {
    Get.toNamed(AppRoutes.myAppointments);
  }

  void viewPatients() {
    Get.toNamed(AppRoutes.patients);
  }

  void viewSchedule() {
    Get.toNamed(AppRoutes.schedule);
  }

  void viewProfile() {
    Get.toNamed(AppRoutes.profile);
  }

  void viewBookingSettings() {
    Get.toNamed(AppRoutes.bookingSettings);
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

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return const Color(0xFF2196F3); // Blue
      case 'completed':
        return const Color(0xFF4CAF50); // Green
      case 'cancelled':
        return const Color(0xFFF44336); // Red
      case 'in_progress':
        return const Color(0xFFFF9800); // Orange
      default:
        return const Color(0xFF9E9E9E); // Grey
    }
  }

  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return 'Scheduled';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'in_progress':
        return 'In Progress';
      default:
        return status;
    }
  }
}
