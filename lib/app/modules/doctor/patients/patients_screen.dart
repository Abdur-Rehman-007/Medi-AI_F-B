import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_theme.dart';
import 'patients_controller.dart';

export 'patients_binding.dart';

class PatientsScreen extends GetView<PatientsController> {
  const PatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('My Patients'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.patients.isEmpty) {
          return const Center(child: Text('No patients found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.patients.length,
          itemBuilder: (context, index) {
            final patient = controller.patients[index];
            final name = patient['fullName'] ?? 'Unknown';
            final email = patient['email'] ?? '';
            final phone = patient['phoneNumber'] ?? '';
            final image = patient['profileImageUrl'];
            final dob = patient['dateOfBirth']?.toString().split('T')[0] ?? '';
            final gender = patient['gender'] ?? '';

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primary.withOpacity(0.1),
                  backgroundImage: image != null ? NetworkImage(image) : null,
                  child: image == null
                      ? Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: const TextStyle(color: AppTheme.primary),
                        )
                      : null,
                ),
                title: Text(name,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(email),
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Column(
                      children: [
                        if (phone.isNotEmpty) _buildInfoRow(Icons.phone, 'Phone', phone),
                        if (email.isNotEmpty) _buildInfoRow(Icons.email, 'Email', email),
                        if (gender.isNotEmpty) _buildInfoRow(Icons.person, 'Gender', gender),
                        if (dob.isNotEmpty)
                          _buildInfoRow(Icons.cake, 'Date of Birth', dob),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(color: Colors.grey)),
          Expanded(
              child: Text(value,
                  style: const TextStyle(fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }
}

