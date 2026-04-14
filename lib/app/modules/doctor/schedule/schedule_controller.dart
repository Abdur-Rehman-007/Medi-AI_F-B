import 'package:get/get.dart';
import '../../../services/doctor_service.dart';

class ScheduleController extends GetxController {
  final _doctorService = Get.find<DoctorService>();

  final RxList<Map<String, dynamic>> schedule = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadSchedule();
  }

  Future<void> loadSchedule() async {
    isLoading.value = true;
    try {
      final response = await _doctorService.getMySchedule();
      if (response.success && response.data != null) {
        schedule.value = response.data!;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load schedule');
    } finally {
      isLoading.value = false;
    }
  }

  void updateDayAvailability(int index, bool val) {
    var item = schedule[index];
    item['isAvailable'] = val;
    schedule[index] = item;
  }

  Future<void> saveSchedule() async {
    isSaving.value = true;
    try {
      final response = await _doctorService.updateSchedule(schedule);
      if (response.success) {
        Get.snackbar('Success', 'Schedule updated successfully', 
          backgroundColor: Get.theme.primaryColor, colorText: Get.theme.canvasColor);
      } else {
        Get.snackbar('Error', response.message);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to save schedule: $e');
    } finally {
      isSaving.value = false;
    }
  }
}
