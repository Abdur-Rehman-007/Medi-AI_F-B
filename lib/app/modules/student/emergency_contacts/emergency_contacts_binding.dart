import 'package:get/get.dart';
import 'package:medi_ai/app/modules/student/emergency_contacts/emergency_contacts_controller.dart';

class EmergencyContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmergencyContactsController>(
      () => EmergencyContactsController(),
    );
  }
}
