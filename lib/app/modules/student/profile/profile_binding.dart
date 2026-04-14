import 'package:get/get.dart';
import '../../../../app/services/doctor_service.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DoctorService>(() => DoctorService());
  }
}