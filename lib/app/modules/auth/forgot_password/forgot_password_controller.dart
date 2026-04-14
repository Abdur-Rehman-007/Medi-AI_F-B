import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../routes/app_routes.dart';

class ForgotPasswordController extends GetxController {
  final _authService = Get.find<AuthService>();

  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final cmsController = TextEditingController();

  final RxBool isLoading = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    phoneController.dispose();
    cmsController.dispose();
    super.onClose();
  }

  Future<void> verifyAndReset() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final response = await _authService.forgotPassword(
        email: emailController.text.trim(),
        phoneNumber: phoneController.text.trim(),
        registrationNumber: cmsController.text.trim(),
      );

      isLoading.value = false;

      if (response.success) {
        final resetToken = response.data?['resetToken'] as String? ?? '';

        if (resetToken.isEmpty) {
          Get.snackbar(
            'Error',
            'Could not retrieve reset token. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          return;
        }

        // Navigate directly to SetPassword — no OTP screen
        Get.toNamed(
          AppRoutes.setPassword,
          arguments: {
            'email': emailController.text.trim(),
            'token': resetToken,
          },
        );
      } else {
        Get.snackbar(
          'Verification Failed',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        'Something went wrong. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
