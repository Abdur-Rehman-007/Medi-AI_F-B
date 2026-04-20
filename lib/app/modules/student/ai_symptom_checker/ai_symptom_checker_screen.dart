import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_theme.dart';
import 'ai_symptom_checker_controller.dart';

// export 'ai_symptom_checker_binding.dart'; // No need to export here, usually

class AiSymptomCheckerScreen extends GetView<SymptomCheckerController> {
  const AiSymptomCheckerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('AI Symptom Checker'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Warning Card
          Card(
            color: Colors.orange[50],
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.warning_amber, color: Colors.orange[700]),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This is not a substitute for professional medical advice. Consult a doctor for accurate diagnosis.',
                      style: TextStyle(color: Colors.orange[900], fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Common Symptoms
          const Text(
            'Select Your Symptoms',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Obx(() => Wrap(
                spacing: 8,
                runSpacing: 8,
                children: controller.commonSymptoms.map((symptom) {
                  final isSelected =
                      controller.selectedSymptoms.contains(symptom);
                  return FilterChip(
                    label: Text(symptom),
                    selected: isSelected,
                    onSelected: (selected) => controller.toggleSymptom(symptom),
                    selectedColor: AppTheme.primary.withOpacity(0.2),
                    checkmarkColor: AppTheme.primary,
                  );
                }).toList(),
              )),
          const SizedBox(height: 24),

          // Additional Symptoms
          const Text(
            'Describe Additional Symptoms',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.symptomsController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Describe any other symptoms you\'re experiencing...',
            ),
            maxLines: 4,
          ),
          const SizedBox(height: 24),

          // Analyze Button
          Obx(() => ElevatedButton(
                onPressed: controller.isAnalyzing.value
                    ? null
                    : controller.analyzeSymptoms,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: controller.isAnalyzing.value
                    ? const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text('Analyzing...'),
                        ],
                      )
                    : const Text(
                        'Analyze Symptoms',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              )),

          // Analysis Result
          Obx(() {
            final result = controller.analysisResult.value;
            if (result == null) return const SizedBox.shrink();

            return Column(
              children: [
                const SizedBox(height: 32),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.medical_services,
                                color: AppTheme.primary),
                            const SizedBox(width: 8),
                            const Text(
                              'Analysis Result',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        _buildResultRow('Possible Condition',
                            result['condition'].toString()),
                        _buildResultRow('Confidence Level',
                            result['confidence'].toString()),
                        _buildResultRow(
                            'Severity', result['severity'].toString()),
                        const SizedBox(height: 16),
                        const Text(
                          'Recommendations:',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        if (result['recommendations'] != null)
                          ...(result['recommendations'] as List)
                              .map((rec) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.check_circle,
                                            size: 16, color: Colors.green),
                                        const SizedBox(width: 8),
                                        Expanded(child: Text(rec.toString())),
                                      ],
                                    ),
                                  )),
                        const SizedBox(height: 16),
                        const Text(
                          'See a Doctor If:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.red,
                          ),
                        ),
                        const SizedBox(height: 8),
                        if (result['whenToSeeDoctor'] != null)
                          ...(result['whenToSeeDoctor'] as List)
                              .map((warning) => Padding(
                                    padding: const EdgeInsets.only(bottom: 4),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.warning,
                                            size: 16, color: Colors.red),
                                        const SizedBox(width: 8),
                                        Expanded(
                                            child: Text(warning.toString())),
                                      ],
                                    ),
                                  )),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => Get.toNamed('/book-appointment'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Book an Appointment'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          Text(value),
        ],
      ),
    );
  }
}
