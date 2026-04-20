import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/auth_service.dart';
import '../../../routes/app_routes.dart';

class OtpVerificationController extends GetxController {
  final _authService = Get.find<AuthService>();

  // OTP controllers (4 or 6 digits)
  final otp1Controller = TextEditingController();
  final otp2Controller = TextEditingController();
  final otp3Controller = TextEditingController();
  final otp4Controller = TextEditingController();
  final otp5Controller = TextEditingController();
  final otp6Controller = TextEditingController();

  // Focus nodes
  final otp1Focus = FocusNode();
  final otp2Focus = FocusNode();
  final otp3Focus = FocusNode();
  final otp4Focus = FocusNode();
  final otp5Focus = FocusNode();
  final otp6Focus = FocusNode();

  // Observables
  final RxBool isLoading = false.obs;
  final RxBool isResending = false.obs;
  final RxInt resendTimer = 60.obs;
  final RxString email = ''.obs;

  bool _isDisposed = false; // Track disposal state

  @override
  void onInit() {
    super.onInit();
    // Get email from arguments
    email.value = Get.arguments?['email'] ?? '';

    // Check if OTP was passed in dev mode
    final devOtp = Get.arguments?['devOtp']?.toString();
    if (devOtp != null && devOtp.length == 6) {
      print('🔑 Auto-filling OTP in dev mode: $devOtp');
      // Auto-fill OTP fields
      otp1Controller.text = devOtp[0];
      otp2Controller.text = devOtp[1];
      otp3Controller.text = devOtp[2];
      otp4Controller.text = devOtp[3];
      otp5Controller.text = devOtp[4];
      otp6Controller.text = devOtp[5];

      // Show snackbar with OTP
      Get.snackbar(
        'Development Mode',
        'OTP auto-filled: $devOtp',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
    }

    startResendTimer();
  }

  @override
  void onClose() {
    _isDisposed = true; // Mark as disposed
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
    otp5Controller.dispose();
    otp6Controller.dispose();
    otp1Focus.dispose();
    otp2Focus.dispose();
    otp3Focus.dispose();
    otp4Focus.dispose();
    otp5Focus.dispose();
    otp6Focus.dispose();
    super.onClose();
  }

  void startResendTimer() {
    resendTimer.value = 60;
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (_isDisposed) return false; // Stop if disposed
      if (resendTimer.value > 0) {
        resendTimer.value--;
        return true;
      }
      return false;
    });
  }

  String getOtp() {
    return otp1Controller.text +
        otp2Controller.text +
        otp3Controller.text +
        otp4Controller.text +
        otp5Controller.text +
        otp6Controller.text;
  }

  Future<void> verifyOtp() async {
    final otp = getOtp();

    if (otp.length != 6) {
      Get.snackbar(
        'Invalid OTP',
        'Please enter complete 6-digit OTP',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final response = await _authService.verifyOtp(
        email: email.value,
        otp: otp,
      );

      if (response.success) {
        isLoading.value = false; // Set to false before navigation

        Get.snackbar(
          'Success',
          'Email verified successfully! Welcome!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // User is now authenticated - navigate to role-based dashboard
        await Future.delayed(const Duration(milliseconds: 500));

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
            // Default fallback
            Get.offAllNamed(AppRoutes.studentDashboard);
          }
        } else {
          // Fallback if user data not loaded
          Get.offAllNamed(AppRoutes.login);
        }
      } else {
        isLoading.value = false;
        Get.snackbar(
          'Error',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> resendOtp() async {
    if (resendTimer.value > 0) return;

    isResending.value = true;

    try {
      /*
      final response = await _authService.sendOtp(email.value);

      if (response.success) {
        Get.snackbar(
          'Success',
          'OTP sent successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        startResendTimer();
      } else {
        Get.snackbar(
      
          'Error',
          response.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      */

      Get.snackbar(
        'Info',
        'OTP Resend disabled temporarily',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isResending.value = false;
    }
  }
}
