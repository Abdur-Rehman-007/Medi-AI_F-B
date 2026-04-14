import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_theme.dart';
import 'system_settings_controller.dart';

class SystemSettingsScreen extends StatelessWidget {
  const SystemSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SystemSettingsController());

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('System Settings'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadSettings,
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: controller.saveSettings,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('General Settings'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: controller.systemNameController,
                      decoration: const InputDecoration(
                        labelText: 'System Name',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.emailController,
                      decoration: const InputDecoration(
                        labelText: 'Admin Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.email),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.supportEmailController,
                      decoration: const InputDecoration(
                        labelText: 'Support Email',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.support_agent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Security Settings'),
            Card(
              child: Column(
                children: [
                   Obx(() => SwitchListTile(
                    title: const Text('Require Email Verification'),
                    subtitle: const Text('Users must verify email before login'),
                    value: controller.requireEmailVerification.value,
                    onChanged: (value) => controller.requireEmailVerification.value = value,
                    activeColor: AppTheme.primary,
                  )),
                  const Divider(height: 1),
                  Obx(() => SwitchListTile(
                    title: const Text('Two-Factor Authentication'),
                    subtitle: const Text('Enable 2FA for admin accounts'),
                    value: controller.twoFactorAuth.value,
                    onChanged: (value) => controller.twoFactorAuth.value = value,
                    activeColor: AppTheme.primary,
                  )),
                  const Divider(height: 1),
                  Obx(() => ListTile(
                    title: const Text('Session Timeout'),
                    subtitle: Text(' minutes'),
                    trailing: SizedBox(
                      width: 100,
                      child: DropdownButton<int>(
                        value: controller.sessionTimeout.value,
                        isExpanded: true,
                        items: [15, 30, 60, 120]
                            .map((min) => DropdownMenuItem(value: min, child: Text(' min')))
                            .toList(),
                        onChanged: (value) => controller.sessionTimeout.value = value!,
                      ),
                    ),
                  )),
                  const Divider(height: 1),
                  Obx(() => ListTile(
                    title: const Text('Max Login Attempts'),
                    subtitle: Text(' attempts before lockout'),
                    trailing: SizedBox(
                      width: 100,
                      child: DropdownButton<int>(
                        value: controller.maxLoginAttempts.value,
                        isExpanded: true,
                        items: [3, 5, 10]
                            .map((val) => DropdownMenuItem(value: val, child: Text('')))
                            .toList(),
                        onChanged: (value) => controller.maxLoginAttempts.value = value!,
                      ),
                    ),
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Notification Settings'),
            Card(
              child: Column(
                children: [
                   Obx(() => SwitchListTile(
                    title: const Text('Email Notifications'),
                    subtitle: const Text('Send email notifications to users'),
                    value: controller.emailNotifications.value,
                    onChanged: (val) => controller.emailNotifications.value = val,
                    activeColor: AppTheme.primary,
                  )),
                  const Divider(height: 1),
                   Obx(() => SwitchListTile(
                    title: const Text('SMS Notifications'),
                    subtitle: const Text('Send SMS notifications to users'),
                    value: controller.smsNotifications.value,
                    onChanged: (val) => controller.smsNotifications.value = val,
                    activeColor: AppTheme.primary,
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('Registration Settings'),
            Card(
              child: Column(
                children: [
                   Obx(() => SwitchListTile(
                    title: const Text('Auto-Approve Registrations'),
                    subtitle: const Text('Automatically approve new user registrations'),
                    value: controller.autoApproveRegistrations.value,
                    onChanged: (val) => controller.autoApproveRegistrations.value = val,
                    activeColor: AppTheme.primary,
                  )),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('System Maintenance'),
            Card(
              child: Column(
                children: [
                   Obx(() => SwitchListTile(
                    title: const Text('Maintenance Mode'),
                    subtitle: const Text('Put system in maintenance mode'),
                    value: controller.maintenanceMode.value,
                    onChanged: (val) => controller.maintenanceMode.value = val,
                    activeColor: Colors.orange,
                  )),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.clear_all, color: Colors.orange),
                    title: const Text('Clear Cache'),
                    subtitle: const Text('Clear all cached data'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: controller.clearCache,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.backup, color: Colors.blue),
                    title: const Text('Backup Database'),
                    subtitle: const Text('Create a database backup'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: controller.backupDatabase,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionHeader('System Information'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildInfoRow('Version', '1.0.0'),
                    const Divider(height: 24),
                    _buildInfoRow('Build', '2024.12.02'),
                    const Divider(height: 24),
                    _buildInfoRow('Environment', 'Development'),
                    const Divider(height: 24),
                    _buildInfoRow('Database', 'Connected'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
             // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.saveSettings,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Save All Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      }),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        Text(value, style: TextStyle(color: Colors.grey[600], fontSize: 15)),
      ],
    );
  }
}
