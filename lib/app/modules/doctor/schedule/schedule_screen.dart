import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_theme.dart';
import 'schedule_controller.dart';

export 'schedule_binding.dart';

class ScheduleScreen extends GetView<ScheduleController> {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('My Schedule'),
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
              const Text('No schedule configured.'),
              const SizedBox(height: 16),
              ElevatedButton(
                child: const Text('Initialize Default Schedule'),
                onPressed: () => controller.loadSchedule(),
              )
            ]),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.schedule.length,
                itemBuilder: (context, index) {
                  // Get reactive item from list
                  final item = controller.schedule[index];
                  final day = item['dayOfWeek'] ?? '';
                  final start = item['startTime'] ?? '';
                  final end = item['endTime'] ?? '';
                  final available = item['isAvailable'] == true;

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
                                  // Update the item in the reactive list
                                  var newItem = Map<String, dynamic>.from(item);
                                  newItem['isAvailable'] = val;
                                  controller.schedule[index] = newItem;
                                },
                              ),
                              Text(day,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                            ],
                          ),
                          if (available)
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      size: 16, color: Colors.grey),
                                  const SizedBox(width: 8),
                                  Text('$start - $end'),
                                  // Placeholder for time picker
                                ],
                              ),
                            ),
                          if (!available)
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16.0),
                              child: Text('Not Available',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontStyle: FontStyle.italic)),
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
