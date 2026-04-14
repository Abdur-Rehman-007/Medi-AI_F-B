import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'login_controller.dart';
import '../../../../config/app_theme.dart';
import '../../../../config/app_config.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppTheme.primary, AppTheme.primary.withOpacity(0.8)],
          ),
        ),
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Center(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(24),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _buildHeader(context),
                          const SizedBox(height: 32),
                          _buildFormFields(),
                          const SizedBox(height: 16),
                          _buildRememberMeAndForgot(),
                          const SizedBox(height: 32),
                          _buildLoginButton(),
                          const SizedBox(height: 16),
                          _buildRegisterLink(),
                          // const SizedBox(height: 24),
                          // _buildTestCredentials(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'buitems-logo-png_seeklogo-273407.png',
          height: 120,
          width: 120,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primary.withOpacity(0.2),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.medical_services_rounded,
                size: 50,
                color: AppTheme.primary,
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Medi-AI',
          style: AppTheme.h2.copyWith(color: AppTheme.primary),
        ),
        const SizedBox(height: 8),
        Text(
          AppConfig.universityName,
          style: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
        ),
      ],
    );
  }

  Widget _buildFormFields() {
    return Obx(() => Column(
          children: [
            TextFormField(
              controller: controller.emailController,
              keyboardType: TextInputType.emailAddress,
              maxLength: 50,
              decoration: InputDecoration(
                labelText: 'Email Address',
                hintText: 'your.email@example.com',
                prefixIcon: const Icon(Icons.email_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Required';
                if (!value!.contains('@')) return 'Invalid email';
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controller.passwordController,
              obscureText: !controller.showPassword.value,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.showPassword.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value?.isEmpty ?? true) return 'Required';
                return null;
              },
            ),
          ],
        ));
  }

  Widget _buildRememberMeAndForgot() {
    return Obx(() => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Checkbox(
                  value: controller.rememberMe.value,
                  onChanged: (value) => controller.toggleRememberMe(),
                  activeColor: AppTheme.primary,
                ),
                Text(
                  'Remember me',
                  style: AppTheme.bodySmall,
                ),
              ],
            ),
            TextButton(
              onPressed: controller.forgotPassword,
              child: Text(
                'Forgot Password?',
                style: AppTheme.bodySmall.copyWith(
                  color: AppTheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ));
  }

  Widget _buildLoginButton() {
    return Obx(() => SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed:
                controller.isLoading.value ? null : controller.handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ));
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Don\'t have an account?',
          style: AppTheme.bodyMedium,
        ),
        TextButton(
          onPressed: controller.goToRegister,
          child: Text(
            'Sign Up',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

//   Widget _buildTestCredentials() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.blue.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.blue.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(Icons.info_outline, size: 18, color: Colors.blue.shade700),
//               const SizedBox(width: 8),
//               Text(
//                 'Test Credentials',
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   fontSize: 14,
//                   color: Colors.blue.shade900,
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           _buildCredentialRow('Student', 'student@buitms.edu.pk', '123456'),
//           const SizedBox(height: 8),
//           _buildCredentialRow('Faculty', 'faculty@buitms.edu.pk', '123456'),
//           const SizedBox(height: 8),
//           _buildCredentialRow('Doctor', 'doctor@buitms.edu.pk', '123456'),
//           const SizedBox(height: 8),
//           _buildCredentialRow('Admin', 'admin@buitms.edu.pk', '123456'),
//         ],
//       ),
//     );
//   }

//   Widget _buildCredentialRow(String role, String email, String password) {
//     return Row(
//       children: [
//         SizedBox(
//           width: 60,
//           child: Text(
//             '$role:',
//             style: const TextStyle(
//               fontSize: 12,
//               fontWeight: FontWeight.w600,
//               color: AppTheme.textPrimary,
//             ),
//           ),
//         ),
//         Expanded(
//           child: Text(
//             '$email / $password',
//             style: TextStyle(
//               fontSize: 11,
//               color: Colors.grey.shade700,
//             ),
//           ),
//         ),
//       ],
//     );
// }
}