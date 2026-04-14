import 'package:get/get.dart';
import 'package:medi_ai/app/modules/student/medical_history/medical_history_controller.dart';

class MedicalHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MedicalHistoryController>(
      () => MedicalHistoryController(),
    );
  }
}
