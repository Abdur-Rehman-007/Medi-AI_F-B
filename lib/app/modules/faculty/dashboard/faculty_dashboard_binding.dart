import 'package:get/get.dart';
import 'faculty_dashboard_controller.dart';

class FacultyDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FacultyDashboardController>(() => FacultyDashboardController());
  }
}
