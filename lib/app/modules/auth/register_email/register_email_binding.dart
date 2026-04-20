import 'package:get/get.dart';
import 'register_email_controller.dart';

class RegisterEmailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterEmailController>(() => RegisterEmailController());
  }
}
