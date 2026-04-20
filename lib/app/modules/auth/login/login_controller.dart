import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../routes/app_routes.dart';

class LoginController extends GetxController {
  final _authService = Get.find<AuthService>();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  // Controllers
  late TextEditingController emailController;
  late TextEditingController passwordController;

  // Observables
  final RxBool showPassword = false.obs;
  final RxBool isLoading = false.obs;
  final RxBool rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    _loadSavedCredentials();
  }

  @override
  void onClose() {
    // emailController.dispose();
    // passwordController.dispose();
    super.onClose();
  }

  Future<void> _loadSavedCredentials() async {
    // Load saved email if remember me was checked
    // You can implement this with SharedPreferences
  }

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  Future<void> handleLogin() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;

    try {
      final response = await _authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (response.success && response.data != null) {
        Get.snackbar(
          'Success',
          'Welcome back!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Check user role and navigate to respective dashboard
        final user = _authService.currentUser.value;
        if (user != null) {
          if (user.isStudent) {
            Get.offAllNamed(AppRoutes.studentDashboard);
          } else if (user.isFaculty) {
            Get.offAllNamed(AppRoutes.studentDashboard);
          } else if (user.isDoctor) {
            Get.offAllNamed(AppRoutes.doctorDashboard);
          } else if (user.isAdmin) {
            Get.offAllNamed(AppRoutes.adminDashboard);
          } else {
            // Default to student dashboard
            Get.offAllNamed(AppRoutes.studentDashboard);
          }
        }
      } else {
        // If login failed (e.g. incorrect password, user not found)
        Get.snackbar(
          'Login Failed',
          response.message.isNotEmpty
              ? response.message
              : 'Invalid email or password',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 4),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.toNamed(AppRoutes.registerEmail);
  }

  void forgotPassword() {
    Get.toNamed(AppRoutes.forgotPassword);
  }
}
