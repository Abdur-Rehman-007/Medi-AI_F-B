import 'package:get/get.dart';
import '../../../services/doctor_service.dart';

class PatientsController extends GetxController {
  final _doctorService = Get.find<DoctorService>();

  final RxList<Map<String, dynamic>> patients = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadPatients();
  }

  Future<void> loadPatients() async {
    isLoading.value = true;
    try {
      final response = await _doctorService.getPatients();
      if (response.success && response.data != null) {
        patients.value = response.data!;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load patients');
    } finally {
      isLoading.value = false;
    }
  }
}
