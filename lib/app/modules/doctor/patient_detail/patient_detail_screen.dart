import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_theme.dart';

export 'patient_detail_binding.dart';

class PatientDetailScreen extends StatelessWidget {
  const PatientDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get patient data from arguments
    final args = Get.arguments as Map<String, dynamic>? ?? {};
    final patientName = args['patientName'] ?? 'Patient';
    final patientId = args['patientId'] ?? 'N/A';

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: Image.asset(
            'buitems-logo-png_seeklogo-273407.png',
            width: 32,
            height: 32,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.arrow_back);
            },
          ),
          onPressed: () => Get.back(),
        ),
        title: const Text('Patient Details'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Get.snackbar(
                'Edit Patient',
                'Edit functionality coming in next update',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppTheme.primary,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildPatientHeader(patientName, patientId),
            const SizedBox(height: 16),
            _buildInfoCard('Personal Information', [
              _buildInfoRow('Age', '22 years'),
              _buildInfoRow('Gender', 'Male'),
              _buildInfoRow('Blood Group', 'O+'),
              _buildInfoRow('Phone', '+92 300 1234567'),
              _buildInfoRow('Email', 'patient@buitms.edu.pk'),
            ]),
            const SizedBox(height: 16),
            _buildInfoCard('Medical History', [
              _buildInfoRow('Allergies', 'Penicillin'),
              _buildInfoRow('Chronic Conditions', 'None'),
              _buildInfoRow('Last Visit', '5 days ago'),
              _buildInfoRow('Total Visits', '8'),
            ]),
            const SizedBox(height: 16),
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildPatientHeader(String name, String id) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: AppTheme.primary,
              child: Text(
                name.substring(0, 1).toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    id,
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Active Patient',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {
              Get.snackbar(
                'Medical Records',
                'Viewing patient medical records',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppTheme.primary,
                colorText: Colors.white,
              );
            },
            icon: const Icon(Icons.description),
            label: const Text('Medical Records'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () {
              Get.snackbar(
                'Write Prescription',
                'Opening prescription form',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: AppTheme.primary,
                colorText: Colors.white,
              );
            },
            icon: const Icon(Icons.edit_note),
            label: const Text('Prescribe'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
}
