import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_theme.dart';
import 'controllers/today_appointments_controller.dart';
import 'package:intl/intl.dart';

export 'today_appointments_binding.dart';

class TodayAppointmentsScreen extends GetView<TodayAppointmentsController> {
  const TodayAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: const Text('Today\'s Appointments'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.appointments.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_available, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(
                  'No appointments for today',
                  style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.appointments.length,
          itemBuilder: (context, index) {
            final appointment = controller.appointments[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 16),
              color: Colors.white,
              elevation: 2,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('hh:mm a').format(appointment.dateTime),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary,
                          ),
                        ),
                        _buildStatusChip(appointment.status),
                      ],
                    ),
                    const Divider(height: 24),
                    const Text(
                      'Patient Name',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      appointment.patientName ?? 'Unknown',
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Symptoms',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    Text(
                      appointment.symptoms ?? 'No symptoms specified',
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (appointment.status == 'Pending' ||
                            appointment.status == 'Scheduled') ...[
                          OutlinedButton(
                            onPressed: () => controller.updateStatus(
                                appointment.id.toString(), 'Cancelled'),
                            style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => controller.updateStatus(
                                appointment.id.toString(), 'Confirmed'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.primary),
                            child: const Text('Confirm'),
                          ),
                        ] else if (appointment.status == 'Confirmed') ...[
                          ElevatedButton(
                            onPressed: () => controller.updateStatus(
                                appointment.id.toString(), 'Completed'),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green),
                            child: const Text('Mark Checked'),
                          ),
                        ] else if (appointment.status == 'Completed') ...[
                          const Chip(
                              label: Text('Completed'),
                              backgroundColor: Colors.greenAccent),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'Scheduled':
      case 'Pending':
        color = Colors.orange;
        break;
      case 'Confirmed':
        color = Colors.blue;
        break;
      case 'Completed':
      case 'Checked':
        color = Colors.green;
        break;
      case 'Cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        status,
        style:
            TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
