import 'package:get/get.dart';
import 'controllers/today_appointments_controller.dart';

class TodayAppointmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TodayAppointmentsController>(
      () => TodayAppointmentsController(),
    );
  }
}
