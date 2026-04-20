import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../config/app_theme.dart';
import '../../../services/api_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'download_helper_stub.dart'
    if (dart.library.html) 'download_helper_web.dart' as download_helper;

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  final ApiService _apiService = Get.find<ApiService>();
  String selectedPeriod = 'This Month';

  final Map<String, dynamic> reportData = {
    'totalAppointments': 245,
    'completedAppointments': 198,
    'cancelledAppointments': 32,
    'pendingAppointments': 15,
    'totalUsers': 150,
    'newUsers': 23,
    'activeUsers': 142,
  };

  final List<Map<String, dynamic>> recentReports = [
    {
      'name': 'Monthly Appointments Report',
      'date': DateTime(2024, 11, 30),
      'type': 'Appointments',
      'status': 'Generated',
    },
    {
      'name': 'User Registration Report',
      'date': DateTime(2024, 11, 28),
      'type': 'Users',
      'status': 'Generated',
    },
    {
      'name': 'Doctor Performance Report',
      'date': DateTime(2024, 11, 25),
      'type': 'Doctors',
      'status': 'Generated',
    },
  ];

  void _generateReport(String reportType) {
    Get.dialog(
      AlertDialog(
        title: Text('Generate $reportType Report'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Generate $reportType report for $selectedPeriod?'),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedPeriod,
              decoration: const InputDecoration(
                labelText: 'Period',
                border: OutlineInputBorder(),
              ),
              items: ['Today', 'This Week', 'This Month', 'This Year', 'Custom']
                  .map((period) => DropdownMenuItem(
                        value: period,
                        child: Text(period),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() => selectedPeriod = value!);
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar(
                'Success',
                '$reportType report generated successfully',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primary),
            child: const Text('Generate'),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadReport(Map<String, dynamic> report) async {
    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Generate CSV content
      String csvContent = await _generateReportCSV(report);

      Get.back(); // Close loading dialog

      if (kIsWeb) {
        // Web download
        download_helper.downloadFile(csvContent, '${report['name']}.csv');
      } else {
        // Mobile notification
        Get.snackbar(
          'Report Generated',
          '${report['name']} report generated. File download available on web version.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.blue,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }

      Get.snackbar(
        'Success',
        '${report['name']} ${kIsWeb ? 'downloaded' : 'generated'} successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      Get.snackbar(
        'Error',
        'Failed to generate report: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<String> _generateReportCSV(Map<String, dynamic> report) async {
    final String reportName = report['name'];
    final String reportType = report['type'];
    final DateTime reportDate = report['date'];

    // Generate CSV header
    String csv = 'Report Name,Type,Generated Date\n';
    csv +=
        '$reportName,$reportType,${DateFormat('yyyy-MM-dd').format(reportDate)}\n\n';

    if (reportType == 'Appointments') {
      csv += 'Date,Patient,Doctor,Status,Time\n';

      // Fetch appointments
      final response = await _apiService.get('/Appointments');
      if (response.success && response.data != null) {
        final List<dynamic> appointments = response.data;
        for (var appt in appointments) {
          final date = appt['appointmentDate']?.toString() ?? '';
          final patient =
              appt['patient']?['fullName'] ?? appt['patientName'] ?? 'Unknown';
          final doctor = appt['doctor']?['user']?['fullName'] ??
              appt['doctorName'] ??
              'Unknown';
          final status = appt['status'] ?? 'Unknown';
          final time = appt['appointmentTime']?.toString() ?? '';

          csv += '$date,$patient,$doctor,$status,$time\n';
        }
      }
    } else if (reportType == 'Users') {
      csv += 'Name,Email,Role,Status,Registration Date\n';

      // Fetch users
      final response = await _apiService.get('/Admin/users');
      if (response.success && response.data != null) {
        final List<dynamic> users = response.data;
        for (var user in users) {
          final name = user['fullName'] ?? '';
          final email = user['email'] ?? '';
          final role = user['role'] ?? '';
          final status = (user['isActive'] == true) ? 'Active' : 'Inactive';
          final date = user['createdAt'] != null
              ? DateFormat('yyyy-MM-dd')
                  .format(DateTime.parse(user['createdAt'].toString()))
              : '';

          csv += '$name,$email,$role,$status,$date\n';
        }
      }
    } else if (reportType == 'Doctors') {
      csv += 'Name,Specialization,Rating,Status\n';

      // Fetch doctors
      final response = await _apiService.get('/Doctors');
      if (response.success && response.data != null) {
        final List<dynamic> doctors = response.data;
        for (var doc in doctors) {
          final name = doc['user']?['fullName'] ?? '';
          final spec = doc['specialization'] ?? '';
          final rating = doc['averageRating']?.toString() ?? '0.0';
          final status =
              (doc['isAvailable'] == true) ? 'Available' : 'Unavailable';

          csv += '$name,$spec,$rating,$status\n';
        }
      }
    }

    return csv;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Reports'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Statistics Overview
            const Text(
              'Overview',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
              children: [
                _buildStatCard(
                  'Total Appointments',
                  reportData['totalAppointments'].toString(),
                  Icons.calendar_today,
                  Colors.blue,
                ),
                _buildStatCard(
                  'Completed',
                  reportData['completedAppointments'].toString(),
                  Icons.check_circle,
                  Colors.green,
                ),
                _buildStatCard(
                  'Active Users',
                  reportData['activeUsers'].toString(),
                  Icons.people,
                  Colors.orange,
                ),
                _buildStatCard(
                  'New Users',
                  reportData['newUsers'].toString(),
                  Icons.person_add,
                  Colors.purple,
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Generate Reports
            const Text(
              'Generate Reports',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildReportCard(
                  'Appointments',
                  Icons.calendar_month,
                  Colors.blue,
                  () => _generateReport('Appointments'),
                ),
                _buildReportCard(
                  'Users',
                  Icons.people,
                  Colors.green,
                  () => _generateReport('Users'),
                ),
                _buildReportCard(
                  'Doctors',
                  Icons.medical_services,
                  Colors.orange,
                  () => _generateReport('Doctors'),
                ),
              ],
            ),
            const SizedBox(height: 32),

            // Recent Reports
            const Text(
              'Recent Reports',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentReports.length,
              itemBuilder: (context, index) {
                final report = recentReports[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primary.withOpacity(0.1),
                      child: const Icon(
                        Icons.description,
                        color: AppTheme.primary,
                      ),
                    ),
                    title: Text(
                      report['name'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          DateFormat('MMM dd, yyyy').format(report['date']),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            report['type'],
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () {
                        // Create a copy of the report map to avoid issues if we modify it
                        final reportCopy = Map<String, dynamic>.from(report);
                        _downloadReport(reportCopy);
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
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
        mainAxisAlignment: MainAxisAlignment.center,
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

  Widget _buildReportCard(
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
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
            Icon(icon, color: color, size: 36),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Generate',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
