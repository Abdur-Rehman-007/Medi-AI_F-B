import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:medi_ai/config/app_config.dart';
import '../../../../config/app_theme.dart';
import '../../../services/api_service.dart';

export 'health_tips_binding.dart';

class HealthTipsScreen extends StatefulWidget {
  const HealthTipsScreen({super.key});

  @override
  State<HealthTipsScreen> createState() => _HealthTipsScreenState();
}

class _HealthTipsScreenState extends State<HealthTipsScreen> {
  final _apiService = Get.find<ApiService>();
  String selectedCategory = 'All';
  bool isLoading = false;
  List<Map<String, dynamic>> tips = [];

  @override
  void initState() {
    super.initState();
    _loadHealthTips();
  }

  Future<void> _loadHealthTips() async {
    setState(() => isLoading = true);
    try {
      final response = await _apiService.get('${AppConfig.baseUrl}/HealthTips');
      if (response.success && response.data != null) {
        setState(() {
          tips = List<Map<String, dynamic>>.from(
              (response.data as List).map((x) => x as Map<String, dynamic>));
        });
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load health tips');
    } finally {
      setState(() => isLoading = false);
    }
  }

  List<Map<String, dynamic>> get filteredTips {
    if (selectedCategory == 'All') return tips;
    return tips.where((tip) => tip['category'] == selectedCategory).toList();
  }

  List<String> get categories {
    final cats = tips.map((tip) => tip['category'] as String).toSet().toList();
    cats.sort();
    return ['All', ...cats];
  }

  IconData _getIconForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'nutrition':
        return Icons.restaurant;
      case 'fitness':
        return Icons.fitness_center;
      case 'wellness':
        return Icons.spa;
      case 'prevention':
        return Icons.shield; // medical_services alternative
      case 'safety':
        return Icons.health_and_safety;
      default:
        return Icons.health_and_safety;
    }
  }

  Color _getColorForCategory(String category) {
    switch (category.toLowerCase()) {
      case 'nutrition':
        return Colors.green;
      case 'fitness':
        return Colors.orange;
      case 'wellness':
        return Colors.purple;
      case 'prevention':
        return Colors.red;
      default:
        return AppTheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Health Tips'),
        backgroundColor: AppTheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Category Filter
          Container(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories.map((category) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: selectedCategory == category,
                      onSelected: (selected) {
                        setState(() => selectedCategory = category);
                      },
                      selectedColor: AppTheme.primary.withOpacity(0.2),
                      checkmarkColor: AppTheme.primary,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // Tips Grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              itemCount: filteredTips.length,
              itemBuilder: (context, index) {
                final tip = filteredTips[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      _showTipDetails(tip);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _getColorForCategory(tip['category'])
                                  .withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              _getIconForCategory(tip['category']),
                              size: 40,
                              color: _getColorForCategory(tip['category']),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            tip['title'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getColorForCategory(tip['category'])
                                  .withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tip['category'],
                              style: TextStyle(
                                fontSize: 10,
                                color: _getColorForCategory(tip['category']),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showTipDetails(Map<String, dynamic> tip) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(_getIconForCategory(tip['category']),
                color: _getColorForCategory(tip['category'])),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                tip['title'],
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getColorForCategory(tip['category']).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tip['category'],
                  style: TextStyle(
                    color: _getColorForCategory(tip['category']),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                tip['content'] ?? tip['description'] ?? '',
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
