import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'admin_dashboard_controller.dart';
import '../../../../config/app_theme.dart';

export 'admin_dashboard_binding.dart';

class AdminDashboardScreen extends GetView<AdminDashboardController> {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(),
      body: Obx(() {
        if (controller.isLoading.value && controller.currentUser.value == null) {
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
                _buildStatisticsGrid(),
                const SizedBox(height: 24),
                _buildQuickActions(),
                const SizedBox(height: 24),
                _buildSystemOverview(),
              ],
            ),
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
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
      title: const Text('Admin Dashboard'),
      backgroundColor: AppTheme.primary,
      foregroundColor: Colors.white,
      elevation: 0,
      actions: [
        Obx(() {
          final alerts = controller.systemAlerts.value;
          return Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => _showNotifications(context),
              ),
              if (alerts > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      alerts.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          );
        }),
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
                user?.name ?? 'Admin',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              accountEmail: Text(user?.email ?? ''),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: user?.profileImage != null
                    ? ClipOval(child: Image.network(user!.profileImage!, fit: BoxFit.cover))
                    : const Icon(Icons.admin_panel_settings, size: 32, color: AppTheme.primary),
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
                  leading: const Icon(Icons.people_outline),
                  title: const Text('Manage Users'),
                  onTap: () {
                    Get.back();
                    controller.manageUsers();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.medical_services_outlined),
                  title: const Text('Manage Doctors'),
                  onTap: () {
                    Get.back();
                    controller.manageDoctors();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.calendar_today_outlined),
                  title: const Text('Appointments'),
                  onTap: () {
                    Get.back();
                    controller.viewAllAppointments();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.assessment_outlined),
                  title: const Text('Reports'),
                  onTap: () {
                    Get.back();
                    controller.viewReports();
                  },
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('My Profile'),
                  onTap: () {
                    Get.back();
                    controller.viewProfile();
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: const Text('System Settings'),
                  onTap: () {
                    Get.back();
                    controller.systemSettings();
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
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.admin_panel_settings,
                size: 40,
                color: Colors.white,
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
                    user?.name ?? 'Administrator',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'System Administrator',
                    style: TextStyle(
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

  Widget _buildStatisticsGrid() {
    return Obx(() {
      return GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.5,
        children: [
          _buildStatCard(
            'Total Users',
            controller.totalUsers.value.toString(),
            Icons.people,
            const Color(0xFF2196F3),
          ),
          _buildStatCard(
            'Students',
            controller.totalStudents.value.toString(),
            Icons.school,
            const Color(0xFF4CAF50),
          ),
          _buildStatCard(
            'Faculty',
            controller.totalFaculty.value.toString(),
            Icons.work,
            const Color(0xFFFF9800),
          ),
          _buildStatCard(
            'Doctors',
            controller.totalDoctors.value.toString(),
            Icons.medical_services,
            const Color(0xFF9C27B0),
          ),
          _buildStatCard(
            'Appointments',
            controller.totalAppointments.value.toString(),
            Icons.calendar_today,
            const Color(0xFF00BCD4),
          ),
          _buildStatCard(
            'Pending',
            controller.pendingVerifications.value.toString(),
            Icons.pending_actions,
            const Color(0xFFF44336),
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
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
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 32),
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
              fontSize: 12,
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
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.8,
          children: [
            _buildActionCard(
              'Manage Users',
              Icons.people,
              const Color(0xFF2196F3),
              controller.manageUsers,
            ),
            _buildActionCard(
              'Doctors',
              Icons.medical_services,
              const Color(0xFF4CAF50),
              controller.manageDoctors,
            ),
            _buildActionCard(
              'Reports',
              Icons.assessment,
              const Color(0xFFFF9800),
              controller.viewReports,
            ),
            _buildActionCard(
              'Settings',
              Icons.settings,
              const Color(0xFF9C27B0),
              controller.systemSettings,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(String label, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildSystemOverview() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'System Overview',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
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
              Obx(() => _buildOverviewRow(
                'Today\'s Appointments',
                controller.todayAppointments.value.toString(),
                Icons.event_available,
                const Color(0xFF4CAF50),
              )),
              const Divider(height: 24),
              Obx(() => _buildOverviewRow(
                'Pending Verifications',
                controller.pendingVerifications.value.toString(),
                Icons.pending_actions,
                const Color(0xFFFF9800),
              )),
              const Divider(height: 24),
              Obx(() => _buildOverviewRow(
                'System Alerts',
                controller.systemAlerts.value.toString(),
                Icons.warning_amber,
                const Color(0xFFF44336),
              )),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewRow(String title, String value, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textPrimary,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: SizedBox(
          width: double.maxFinite,
          child: Obx(() {
            if (controller.notifications.isEmpty) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.notifications_off_outlined, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No new notifications'),
                ],
              );
            }
            return ListView.separated(
              shrinkWrap: true,
              itemCount: controller.notifications.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final notification = controller.notifications[index];
                return ListTile(
                  leading: const Icon(Icons.info_outline, color: AppTheme.primary),
                  title: Text(notification['title'] ?? 'Notification'),
                  subtitle: Text(notification['message'] ?? ''),
                  trailing: Text(
                    notification['createdAt']?.toString().split('T')[0] ?? '',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                );
              },
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
