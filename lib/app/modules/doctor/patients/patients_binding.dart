import 'package:get/get.dart';
import '../../../../app/services/doctor_service.dart';
import 'patients_controller.dart';

class PatientsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorService>(() => DoctorService());
    Get.lazyPut<PatientsController>(() => PatientsController());
  }
}
