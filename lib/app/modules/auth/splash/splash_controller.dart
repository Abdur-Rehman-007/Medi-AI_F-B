import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Wait for 1 second (splash animation)
      await Future.delayed(const Duration(seconds: 1));

      // Navigate to login screen
      await Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      print('Error in splash: $e');
      // Fallback to login on any error
      await Get.offAllNamed(AppRoutes.login);
    }
  }
}
