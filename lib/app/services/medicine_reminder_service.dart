import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'api_service.dart';
import 'notification_service.dart';
import '../../config/app_config.dart';

class MedicineReminderService extends GetxService {
  final _apiService = Get.find<ApiService>();
  final _notificationService = Get.find<NotificationService>();

  Future<MedicineReminderService> init() async {
    return this;
  }

  Future<void> scheduleLocalReminder({
    required int id,
    required String title,
    required String body,
    required TimeOfDay scheduledTime,
    String? payload,
  }) async {
    await _notificationService.scheduleNotification(
      id: id,
      title: title,
      body: body,
      scheduledTime: scheduledTime,
      payload: payload,
    );
  }

  Future<void> syncReminders(List<Map<String, dynamic>> reminders) async {
    final mapped = reminders.map((r) {
      final timesRaw = (r['times'] ?? '').toString();
      final startDateRaw = (r['startDate'] ?? '').toString().trim();
      final endDateRaw = (r['endDate'] ?? '').toString().trim();
      final times = timesRaw
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      return {
        'id': int.tryParse((r['id'] ?? '').toString()),
        'medicineName': (r['medicineName'] ?? '').toString(),
        'dosage': (r['dosage'] ?? '').toString(),
        'frequency': (r['frequency'] ?? 'Custom').toString(),
        'customFrequency': r['customFrequency'],
        'times': times,
        'startDate': startDateRaw.isEmpty ? null : startDateRaw,
        'endDate': endDateRaw.isEmpty ? null : endDateRaw,
        'notes': (r['notes'] ?? '').toString(),
        'isActive': r['isActive'] == true,
      };
    }).toList();

    final response = await _apiService.post<dynamic>(
      '${AppConfig.baseUrl}/reminders/sync',
      data: {'reminders': mapped},
    );

    if (!response.success) {
      throw Exception(response.message);
    }
  }
}
