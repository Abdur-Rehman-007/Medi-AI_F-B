import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../config/app_theme.dart';
import '../../../services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


export 'faculty_medicine_reminders_binding.dart';

class FacultyMedicineRemindersScreen extends StatefulWidget {
  const FacultyMedicineRemindersScreen({super.key});

  @override
  State<FacultyMedicineRemindersScreen> createState() =>
      _FacultyMedicineRemindersScreenState();
}

class _FacultyMedicineRemindersScreenState
    extends State<FacultyMedicineRemindersScreen> {
  final _notificationService = Get.find<NotificationService>();

  final List<Map<String, dynamic>> reminders = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  Future<void> _loadReminders() async {
    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? remindersJson =
          prefs.getString('offline_faculty_medicine_reminders');

      if (remindersJson != null) {
        final List<dynamic> decoded = jsonDecode(remindersJson);
        setState(() {
          reminders
            ..clear()
            ..addAll(decoded.map((e) => Map<String, dynamic>.from(e as Map)));
        });
      } else {
        setState(() {
          reminders.clear();
        });
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load reminders: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  int _generateNotificationId(String reminderId, int index) {
    // Determine a base ID from the string hash
    // We mask it to ensure positive integer limits
    // Adding 10000 offset for faculty space
    return ((reminderId.hashCode + index) & 0x7FFFFFFF) + 10000;
  }

  Future<void> _scheduleRemindersFor(Map<String, dynamic> reminder) async {
    final reminderId = reminder['id'].toString();
    final medicineName = reminder['medicineName']?.toString() ?? 'Medicine';
    final dosage = reminder['dosage']?.toString() ?? '';
    final isActive = reminder['isActive'] == true;

    List<String> timesApp;
    final timesRaw = reminder['times'];
    if (timesRaw is String) {
      if (timesRaw.trim().startsWith('[')) {
        try {
          // It's a JSON array string
          final List<dynamic> parsed = jsonDecode(timesRaw);
          timesApp = parsed.map((e) => e.toString()).toList();
        } catch (_) {
          // Fallback if parsing fails
          timesApp = timesRaw.replaceAll(RegExp(r'[\[\]"]'), '').split(',');
        }
      } else {
        // Assume comma separated
        timesApp = timesRaw.split(',');
      }
    } else if (timesRaw is List) {
      timesApp = timesRaw.map((e) => e.toString()).toList();
    } else {
      timesApp = [];
    }

    // First cancel any existing notifications for this reminder (indices 0..19)
    for (int i = 0; i < 20; i++) {
      await _notificationService
          .cancelNotification(_generateNotificationId(reminderId, i));
    }

    if (!isActive) return;

    for (int i = 0; i < timesApp.length; i++) {
      final timeStr = timesApp[i].trim();
      // Parse "hh:mm a"
      final format = DateFormat('hh:mm a');
      final dt = format.parse(timeStr); // returns DateTime(1970, 1, 1, hh, mm)
      final timeOfDay = TimeOfDay(hour: dt.hour, minute: dt.minute);

      await _notificationService.scheduleNotification(
        id: _generateNotificationId(reminderId, i),
        title: 'Work/Medicine Reminder',
        body: 'It\'s time to take/do $medicineName ($dosage)',
        scheduledTime: timeOfDay,
        payload: reminderId,
      );
    }
  }

  List<String> _getTimesForFrequency(String frequency) {
    return ['08:00 AM'];
  }

  void _showAddReminderDialog(
      [Map<String, dynamic>? existingReminder, int? index]) {
    final nameController = TextEditingController(
        text: existingReminder?['medicineName'] ??
            existingReminder?['name'] ??
            '');
    final dosageController =
        TextEditingController(text: existingReminder?['dosage'] ?? '');
    final isEditing = existingReminder != null;

    // Parse initial times
    List<TimeOfDay> currentTimes = [];
    if (existingReminder != null && existingReminder['times'] != null) {
      final timesStr = existingReminder['times'].toString().split(',');
      final format = DateFormat('hh:mm a');
      for (var t in timesStr) {
        if (t.trim().isEmpty) continue;
        try {
          final dt = format.parse(t.trim());
          currentTimes.add(TimeOfDay(hour: dt.hour, minute: dt.minute));
        } catch (_) {}
      }
    }

    if (currentTimes.isEmpty) {
      currentTimes.add(const TimeOfDay(hour: 8, minute: 0));
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text(isEditing ? 'Edit Reminder' : 'Add Reminder'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        labelText: 'Reminder Name',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: dosageController,
                      decoration: const InputDecoration(
                        labelText: 'Details/Dosage',
                        border: OutlineInputBorder(),
                        hintText: 'e.g., Take with food',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Reminder Times:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        ...currentTimes.map((time) {
                          return InputChip(
                            label: Text(time.format(context)),
                            onDeleted: () {
                              setStateDialog(() {
                                currentTimes.remove(time);
                              });
                            },
                            onPressed: () async {
                              final picked = await showTimePicker(
                                context: context,
                                initialTime: time,
                              );
                              if (picked != null) {
                                setStateDialog(() {
                                  final index = currentTimes.indexOf(time);
                                  currentTimes[index] = picked;
                                });
                              }
                            },
                          );
                        }),
                        ActionChip(
                          avatar: const Icon(Icons.add, size: 16),
                          label: const Text('Add Time'),
                          onPressed: () async {
                            final picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setStateDialog(() {
                                currentTimes.add(picked);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        dosageController.text.isNotEmpty &&
                        currentTimes.isNotEmpty) {
                      // Format times to strings
                      final formattedTimes = currentTimes.map((t) {
                        final now = DateTime.now();
                        final dt = DateTime(
                            now.year, now.month, now.day, t.hour, t.minute);
                        return DateFormat('hh:mm a').format(dt);
                      }).toList();

                      _saveReminder(
                        isEditing: isEditing,
                        reminderId: existingReminder?['id']?.toString(),
                        name: nameController.text,
                        dosage: dosageController.text,
                        frequency: 'Custom',
                        timesList: formattedTimes,
                        isActive: existingReminder?['isActive'] ?? true,
                      );
                      Navigator.of(context).pop();
                    } else if (currentTimes.isEmpty) {
                      Get.snackbar('Error', 'Please add at least one time');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: Text(isEditing ? 'Save' : 'Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _saveReminder({
    required bool isEditing,
    String? reminderId,
    required String name,
    required String dosage,
    required String frequency,
    List<String>? timesList,
    required bool isActive,
    String? notes,
  }) async {
    final finalTimes = timesList ?? _getTimesForFrequency(frequency);

    final newReminder = {
      'id': reminderId ?? DateTime.now().millisecondsSinceEpoch.toString(),
      'medicineName': name,
      'dosage': dosage,
      'frequency': frequency,
      'customFrequency': null,
      'times': finalTimes.join(','),
      'startDate': DateFormat('yyyy-MM-dd').format(DateTime.now()),
      'endDate': null,
      'notes': notes ?? '',
      'isActive': isActive,
    };

    setState(() => isLoading = true);
    try {
      final prefs = await SharedPreferences.getInstance();

      if (isEditing && reminderId != null) {
        final index =
            reminders.indexWhere((r) => r['id'].toString() == reminderId);
        if (index != -1) {
          reminders[index] = newReminder;
        }
      } else {
        reminders.add(newReminder);
      }

      await prefs.setString(
          'offline_faculty_medicine_reminders', jsonEncode(reminders));

      // Schedule notification
      await _scheduleRemindersFor(newReminder);

      Get.back();
      Get.snackbar(
        'Success',
        isEditing
            ? 'Reminder updated successfully'
            : 'Reminder added successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to save reminder: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _toggleReminder(dynamic id) async {
    if (id == null) return;
    try {
      final index =
          reminders.indexWhere((r) => r['id'].toString() == id.toString());
      if (index != -1) {
        setState(() {
          reminders[index]['isActive'] =
              !(reminders[index]['isActive'] == true);
        });

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(
            'offline_faculty_medicine_reminders', jsonEncode(reminders));

        final updated = reminders[index];
        if (updated['isActive'] == true) {
          await _scheduleRemindersFor(updated);
        } else {
          for (int i = 0; i < 20; i++) {
            await _notificationService
                .cancelNotification(_generateNotificationId(id.toString(), i));
          }
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to toggle reminder: $e');
    }
  }

  Future<void> _deleteReminder(dynamic id) async {
    if (id == null) return;
    try {
      setState(() {
        reminders.removeWhere((r) => r['id'].toString() == id.toString());
      });

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          'offline_faculty_medicine_reminders', jsonEncode(reminders));

      // Cancel notifications locally
      for (int i = 0; i < 20; i++) {
        await _notificationService
            .cancelNotification(_generateNotificationId(id.toString(), i));
      }

      Get.snackbar(
        'Deleted',
        'Reminder removed',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete reminder: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Faculty Reminders'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : reminders.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.alarm, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'No reminders set',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Tap + to add your first reminder',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: reminders.length,
                  itemBuilder: (context, index) {
                    final reminder = reminders[index];
                    final times = (reminder['times'] ?? '')
                        .toString()
                        .split(',')
                        .where((e) => e.trim().isNotEmpty)
                        .toList();
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Icon(
                                    Icons.alarm,
                                    color: AppTheme.primary,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        reminder['medicineName'] ??
                                            reminder['name'] ??
                                            '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${reminder['dosage'] ?? ''}',
                                        style:
                                            const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                                Switch(
                                  value: reminder['isActive'] == true,
                                  onChanged: (_) =>
                                      _toggleReminder(reminder['id']),
                                  activeColor: AppTheme.primary,
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            if (times.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: times
                                    .map((t) => Chip(
                                          label: Text(t.trim()),
                                          backgroundColor:
                                              AppTheme.primary.withOpacity(0.1),
                                          labelStyle: const TextStyle(
                                              color: AppTheme.primary),
                                        ))
                                    .toList(),
                              ),
                            if (reminder['notes'] != null &&
                                (reminder['notes'] as String).isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                'Notes: ${reminder['notes']}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () =>
                                      _showAddReminderDialog(reminder, index),
                                  child: const Text('Edit'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      _deleteReminder(reminder['id']),
                                  child: const Text('Delete',
                                      style: TextStyle(color: Colors.red)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddReminderDialog(),
        backgroundColor: AppTheme.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
