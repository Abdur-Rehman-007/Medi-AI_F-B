import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'student_dashboard_controller.dart';
import '../../../../config/app_theme.dart';
import '../../../data/models/appointment.dart';

class StudentDashboardScreen extends GetView<StudentDashboardController> {
  const StudentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
      body: Obx(() {
        if (controller.isLoading.value &&
            controller.currentUser.value == null) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: controller.refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildWelcomeCard(),
                const SizedBox(height: 20),
                _buildStatisticsCards(),
                const SizedBox(height: 24),
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildUpcomingAppointments(),
                const SizedBox(height: 24),
                _buildRecentAppointments(),
              ],
            ),
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      leading: Builder(
        builder: (context) => IconButton(
          icon: Image.asset(
            'buitems-logo-png_seeklogo-273407.png',
            width: 32,
            height: 32,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.menu);
            },
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: const Text('Student Dashboard'),
      backgroundColor: AppTheme.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Obx(() {
            final user = controller.currentUser.value;
            return UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: AppTheme.primary),
              accountName: Text(
                user?.name ?? 'Student',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text(user?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: user?.profileImage != null
                    ? ClipOval(
                        child: Image.network(user!.profileImage!,
                            fit: BoxFit.cover),
                      )
                    : const Icon(Icons.person,
                        size: 32, color: AppTheme.primary),
              ),
            );
          }),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ListTile(
                  leading: const Icon(Icons.dashboard_outlined),
                  title: const Text('Dashboard'),
                  selected: true,
                  selectedTileColor: AppTheme.primary.withOpacity(0.1),
                  onTap: () => Get.back(),
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_month_outlined),
                  title: const Text('Book Appointment'),
                  onTap: () {
                    Get.back();
                    controller.goToBookAppointment();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text('My Appointments'),
                  onTap: () {
                    Get.back();
                    controller.goToMyAppointments();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.psychology_outlined),
                  title: const Text('AI Symptom Checker'),
                  onTap: () {
                    Get.back();
                    controller.goToAIChecker();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.tips_and_updates_outlined),
                  title: const Text('Health Tips'),
                  onTap: () {
                    Get.back();
                    controller.goToHealthTips();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.alarm_outlined),
                  title: const Text('Medicine Reminders'),
                  onTap: () {
                    Get.back();
                    controller.goToMedicineReminders();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.history_edu),
                  title: const Text('Medical History'),
                  onTap: () {
                    Get.back();
                    controller.goToMedicalHistory();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.contact_phone_outlined),
                  title: const Text('Emergency Contacts'),
                  onTap: () {
                    Get.back();
                    controller.goToEmergencyContacts();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Profile'),
                  onTap: () {
                    Get.back();
                    controller.goToProfile();
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Logout', style: TextStyle(color: Colors.red)),
            onTap: controller.logout,
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Obx(() {
      final user = controller.currentUser.value;
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primary, Color(0xFF003D6E)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.white,
              child: user?.profileImage != null
                  ? ClipOval(
                      child:
                          Image.network(user!.profileImage!, fit: BoxFit.cover),
                    )
                  : const Icon(
                      Icons.person,
                      size: 32,
                      color: AppTheme.primary,
                    ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.getGreeting(),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.name ?? 'Student',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user?.department ?? 'BUITEMS Student',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildStatisticsCards() {
    return Obx(() => Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Appointments',
                controller.totalAppointments.value.toString(),
                Icons.calendar_today,
                const Color(0xFF2196F3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Completed',
                controller.completedAppointments.value.toString(),
                Icons.check_circle,
                const Color(0xFF4CAF50),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildStatCard(
                'Upcoming',
                controller.upcomingCount.value.toString(),
                Icons.pending,
                const Color(0xFFFF9800),
              ),
            ),
          ],
        ));
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick Actions',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'Book Appointment',
                Icons.add_circle,
                const Color(0xFF2196F3),
                controller.goToBookAppointment,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                'AI Symptom Checker',
                Icons.psychology,
                const Color(0xFF4CAF50),
                controller.goToAIChecker,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                'My Appointments',
                Icons.list_alt,
                const Color(0xFFFF9800),
                controller.goToMyAppointments,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionButton(
                'Medicine Reminders',
                Icons.alarm,
                const Color(0xFF9C27B0),
                controller.goToMedicineReminders,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingAppointments() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Upcoming Appointments',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              if (controller.upcomingAppointments.isNotEmpty)
                TextButton(
                  onPressed: controller.goToMyAppointments,
                  child: const Text('View All'),
                ),
            ],
          ),
          const SizedBox(height: 12),
          controller.upcomingAppointments.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.upcomingAppointments.length > 3
                      ? 3
                      : controller.upcomingAppointments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final appointment = controller.upcomingAppointments[index];
                    return _buildAppointmentCard(appointment);
                  },
                ),
        ],
      );
    });
  }

  Widget _buildRecentAppointments() {
    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox.shrink();
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent (Last 30 Days)',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          controller.recentAppointments.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.recentAppointments.length > 3
                      ? 3
                      : controller.recentAppointments.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final appointment = controller.recentAppointments[index];
                    return _buildAppointmentCard(appointment);
                  },
                ),
        ],
      );
    });
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_today_outlined,
            size: 64,
            color: Colors.grey[300],
          ),
          const SizedBox(height: 16),
          Text(
            'No upcoming appointments',
            style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.goToBookAppointment,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
            ),
            child: const Text('Book Appointment'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(Appointment appointment) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('hh:mm a');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.medical_services,
                  color: AppTheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.doctorName,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment.reason,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color:
                          _getStatusColor(appointment.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      appointment.status,
                      style: TextStyle(
                        color: _getStatusColor(appointment.status),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (controller.canEditAppointment(appointment))
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          InkWell(
                            onTap: () => _showEditDialog(appointment),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(Icons.edit,
                                  size: 20, color: Colors.blue),
                            ),
                          ),
                          const SizedBox(width: 8),
                          InkWell(
                            onTap: () => _confirmCancel(appointment),
                            child: const Padding(
                              padding: EdgeInsets.all(4.0),
                              child: Icon(Icons.cancel,
                                  size: 20, color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                dateFormat.format(appointment.appointmentDate),
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time, size: 16, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                timeFormat.format(appointment.appointmentDate),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    if (status == 'Confirmed') return Colors.green;
    if (status == 'Pending') return Colors.orange;
    if (status == 'Cancelled') return Colors.red;
    if (status == 'Completed') return Colors.blue;
    return Colors.grey;
  }

  void _confirmCancel(Appointment appointment) {
    Get.defaultDialog(
      title: 'Cancel Appointment',
      middleText: 'Are you sure you want to cancel this appointment?',
      textConfirm: 'Yes',
      textCancel: 'No',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        controller.cancelAppointment(appointment.id);
      },
    );
  }

  void _showEditDialog(Appointment appointment) {
    final dateController = TextEditingController(
        text: DateFormat('yyyy-MM-dd').format(appointment.appointmentDate));
    final timeController = TextEditingController(
        text: DateFormat('HH:mm').format(appointment.appointmentDate));
    final symptomsController =
        TextEditingController(text: appointment.symptoms);
    final notesController =
        TextEditingController(text: appointment.notes ?? '');

    DateTime selectedDate = appointment.appointmentDate;

    Get.dialog(
      AlertDialog(
        title: const Text('Edit Appointment'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dateController,
                decoration: const InputDecoration(
                    labelText: 'Date', suffixIcon: Icon(Icons.calendar_today)),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: Get.context!,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 30)),
                  );
                  if (date != null) {
                    selectedDate = date;
                    dateController.text = DateFormat('yyyy-MM-dd').format(date);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: timeController,
                decoration: const InputDecoration(
                    labelText: 'Time', suffixIcon: Icon(Icons.access_time)),
                readOnly: true,
                onTap: () async {
                  final currentT =
                      TimeOfDay.fromDateTime(appointment.appointmentDate);
                  final time = await showTimePicker(
                      context: Get.context!, initialTime: currentT);
                  if (time != null) {
                    final dt = DateTime(0, 0, 0, time.hour, time.minute);
                    timeController.text = DateFormat('HH:mm').format(dt);
                  }
                },
              ),
              const SizedBox(height: 16),
              TextField(
                  controller: symptomsController,
                  decoration: const InputDecoration(labelText: 'Symptoms'),
                  maxLines: 2),
              const SizedBox(height: 16),
              TextField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  maxLines: 2),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.updateAppointment(
                appointment.id,
                appointment.doctorId,
                selectedDate,
                timeController.text,
                symptomsController.text,
                notesController.text,
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}
