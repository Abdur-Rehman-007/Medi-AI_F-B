import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_theme.dart';
import 'schedule_controller.dart';

export 'schedule_binding.dart';

class ScheduleScreen extends GetView<ScheduleController> {
  const ScheduleScreen({super.key});

  TimeOfDay _parseTime(String value) {
    final parts = value.split(':');
    if (parts.length != 2) {
      return const TimeOfDay(hour: 9, minute: 0);
    }

    final hour = int.tryParse(parts[0]) ?? 9;
    final minute = int.tryParse(parts[1]) ?? 0;
    return TimeOfDay(hour: hour.clamp(0, 23), minute: minute.clamp(0, 59));
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Future<void> _pickTime(BuildContext context, int index, bool isStart) async {
    final item = controller.schedule[index];
    final key = isStart ? 'startTime' : 'endTime';
    final fallback = isStart ? '09:00' : '17:00';
    final raw = (item[key] ?? item[isStart ? 'StartTime' : 'EndTime'] ?? fallback).toString();

    final picked = await showTimePicker(
      context: context,
      initialTime: _parseTime(raw),
    );

    if (picked == null) return;

    controller.updateDayTime(index, isStart: isStart, value: _formatTime(picked));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Set Schedule'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.loadSchedule,
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.schedule.isEmpty) {
          return Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('No schedule configured yet.'),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Load Default Week Schedule'),
                onPressed: () => controller.loadSchedule(),
              )
            ]),
          );
        }

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.12)),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Doctor Working Days',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Set the days and time slots patients can book appointments. You can change these anytime.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: controller.schedule.length,
                itemBuilder: (context, index) {
                  final item = controller.schedule[index];
                  final day = (item['dayOfWeek'] ?? item['DayOfWeek'] ?? '').toString();
                  final start = (item['startTime'] ?? item['StartTime'] ?? '').toString();
                  final end = (item['endTime'] ?? item['EndTime'] ?? '').toString();
                  final available = item['isAvailable'] == true || item['IsAvailable'] == true;
                  final availabilityLabel = available ? 'Available' : 'Not Available';
                  final availabilityColor = available ? Colors.green : Colors.grey;

                  return Card(
                    color: available ? Colors.white : Colors.grey[200],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: available,
                                activeColor: AppTheme.primary,
                                onChanged: (val) {
                                  controller.updateDayAvailability(index, val ?? false);
                                },
                              ),
                              Text(day,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: availabilityColor.withOpacity(0.12),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  availabilityLabel,
                                  style: TextStyle(
                                    color: availabilityColor,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time,
                                    size: 16, color: Colors.grey),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    start.isNotEmpty && end.isNotEmpty ? '$start - $end' : 'No timing set',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textPrimary,
                                    ),
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed: () => _pickTime(context, index, true),
                                  icon: const Icon(Icons.schedule, size: 16),
                                  label: const Text('Start'),
                                ),
                                const SizedBox(width: 4),
                                TextButton.icon(
                                  onPressed: () => _pickTime(context, index, false),
                                  icon: const Icon(Icons.schedule_outlined, size: 16),
                                  label: const Text('End'),
                                ),
                              ],
                            ),
                          ),
                          if (!available)
                            const Padding(
                              padding: EdgeInsets.only(left: 16.0, top: 6.0),
                              child: Text(
                                'Timing saved but currently disabled',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: controller.isSaving.value
                    ? null
                    : () => _saveSchedule(controller),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: controller.isSaving.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2))
                    : const Text('Save Changes'),
              ),
            )
          ],
        );
      }),
    );
  }

  void _saveSchedule(ScheduleController controller) {
    controller.saveSchedule();
  }
}
