import 'package:get/get.dart';
import 'ai_symptom_checker_controller.dart';

class AISymptomCheckerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SymptomCheckerController());
  }
}
