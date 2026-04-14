import 'package:get/get.dart';
import '../../../services/doctor_service.dart';
import 'doctor_dashboard_controller.dart';

class DoctorDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorService>(() => DoctorService());
    Get.lazyPut<DoctorDashboardController>(() => DoctorDashboardController());
  }
}
