import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../services/auth_service.dart';
import '../../../routes/app_routes.dart';

class RegisterEmailController extends GetxController {
  final _authService = Get.find<AuthService>();

  late GlobalKey<FormState> formKey;

  // Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final phoneController = TextEditingController();
  final cmsIdController = TextEditingController();
  final registrationNumberController = TextEditingController();
  final addressController = TextEditingController();
  final specializationController = TextEditingController();
  final licenseNumberController = TextEditingController();
  final qualificationController = TextEditingController();
  final experienceController = TextEditingController();
  final roomNumberController = TextEditingController();
  final bioController = TextEditingController();

  // Observables
  final RxBool showPassword = false.obs;
  final RxBool showConfirmPassword = false.obs;
  final RxBool isLoading = false.obs;
  final RxString selectedRole = ''.obs;
  final RxString selectedDepartment = ''.obs;
  final RxString selectedGender = ''.obs;
  final RxString dateOfBirth = ''.obs;

  @override
  void onClose() {
    // Commented out disposal to prevent crash during navigation transition
    // access to disposed controller
    // firstNameController.dispose();
    // lastNameController.dispose();
    // emailController.dispose();
    // passwordController.dispose();
    // confirmPasswordController.dispose();
    // cmsIdController.dispose();
    // phoneController.dispose();
    // addressController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    showPassword.value = !showPassword.value;
  }

  void toggleConfirmPasswordVisibility() {
    showConfirmPassword.value = !showConfirmPassword.value;
  }

  void selectRole(String role) {
    selectedRole.value = role;
  }

  void selectDepartment(String dept) {
    selectedDepartment.value = dept;
  }

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  void setDateOfBirth(DateTime date) {
    dateOfBirth.value = DateFormat('dd/MM/yyyy').format(date);
  }

  String? _convertDateFormat(String date) {
    try {
      // Convert from dd/MM/yyyy to yyyy-MM-dd
      final parsedDate = DateFormat('dd/MM/yyyy').parse(date);
      return DateFormat('yyyy-MM-dd').format(parsedDate);
    } catch (e) {
      print('❌ Error converting date: $e');
      return null;
    }
  }

  Future<void> handleSignup() async {
    print('🔍 Signup button clicked');
    print('📋 Form validation: ${formKey.currentState?.validate()}');

    if (!formKey.currentState!.validate()) {
      print('❌ Form validation failed - check required fields');
      Get.snackbar(
        'Validation Error',
        'Please fill all required fields correctly',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (selectedRole.value.isEmpty) {
      print('❌ Role not selected');
      Get.snackbar(
        'Required',
        'Please select your role (Student/Faculty/Doctor)',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (selectedGender.value.isEmpty) {
      print('❌ Gender not selected');
      Get.snackbar(
        'Required',
        'Please select your gender',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (dateOfBirth.value.isEmpty) {
      print('❌ Date of birth not selected');
      Get.snackbar(
        'Required',
        'Please select your date of birth',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    // Validate Department for Student/Faculty
    if ((selectedRole.value == 'Student' || selectedRole.value == 'Faculty') &&
        selectedDepartment.value.isEmpty) {
      print('❌ Department not selected for ${selectedRole.value}');
      Get.snackbar(
        'Required',
        'Please select your department',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    if (selectedRole.value == 'Doctor') {
      if (specializationController.text.trim().isEmpty ||
          licenseNumberController.text.trim().isEmpty ||
          qualificationController.text.trim().isEmpty) {
        Get.snackbar(
          'Required',
          'For doctor account, specialization, license number, and qualification are required',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        return;
      }
    }

    print('✅ All validations passed, proceeding with registration...');
    isLoading.value = true;

    try {
      print('🚀 Starting registration for: ${emailController.text.trim()}');
      print('📝 Form data:');
      print('  - Role: ${selectedRole.value}');
      print('  - Department: ${selectedDepartment.value}');
      print('  - CMS ID: ${cmsIdController.text.trim()}');
      print('  - Gender: ${selectedGender.value}');
      print('  - DOB: ${dateOfBirth.value}');
      print('  - Phone: ${phoneController.text.trim()}');
      print('  - Address: ${addressController.text.trim()}');

      final response = await _authService.register(
        email: emailController.text.trim(),
        password: passwordController.text,
        name:
            '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
        role: selectedRole.value,
        department: selectedDepartment.value.isNotEmpty
            ? selectedDepartment.value
            : null,
        cmsId: cmsIdController.text.trim().isNotEmpty
            ? cmsIdController.text.trim()
            : null,
        phoneNumber: phoneController.text.trim().isNotEmpty
            ? phoneController.text.trim()
            : null,
        dateOfBirth: dateOfBirth.value.isNotEmpty
            ? _convertDateFormat(dateOfBirth.value)
            : null,
        gender: selectedGender.value.isNotEmpty ? selectedGender.value : null,
        address: addressController.text.trim().isNotEmpty
            ? addressController.text.trim()
            : null,
        specialization: specializationController.text.trim().isNotEmpty
          ? specializationController.text.trim()
          : null,
        licenseNumber: licenseNumberController.text.trim().isNotEmpty
          ? licenseNumberController.text.trim()
          : null,
        qualification: qualificationController.text.trim().isNotEmpty
          ? qualificationController.text.trim()
          : null,
        experience: int.tryParse(experienceController.text.trim()),
        roomNumber: roomNumberController.text.trim().isNotEmpty
          ? roomNumberController.text.trim()
          : null,
        bio: bioController.text.trim().isNotEmpty
          ? bioController.text.trim()
          : null,
      );

      print(
          '📦 Registration response - Success: ${response.success}, Message: ${response.message}');

      if (response.success) {
        // Check if backend returned OTP in dev mode
        String? devOtp;
        if (response.data != null && response.data is Map) {
          final data = response.data as Map<String, dynamic>;
          devOtp = data['otp']?.toString();
          if (devOtp != null) {
            print('🔑 DEV MODE - OTP received from backend: $devOtp');
          }
        }

        // Show success message with OTP if available
        /*
        String successMessage = response.message;
        if (devOtp != null) {
          successMessage = 'Registration successful! Your OTP: $devOtp';
        }

        Get.snackbar(
          'Success',
          successMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: devOtp != null ? 10 : 3),
        );

        print('✅ Registration successful! Navigating to OTP screen...');
        */
        
        Get.snackbar(
          'Success',
          'Registration successful! Please login.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        // Navigate to Login screen directly skipping OTP
        await Future.delayed(
            const Duration(milliseconds: 500)); // Small delay for snackbar
        
        Get.offAllNamed(AppRoutes.login);

        print('🔄 Navigation command sent to Login screen');
      } else {
        print('❌ Registration failed: ${response.message}');
        Get.snackbar(
          'Error',
          response.message,
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
}
