import 'package:get/get.dart';
import 'booking_settings_controller.dart';

class BookingSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingSettingsController>(
      () => BookingSettingsController(),
    );
  }
}
