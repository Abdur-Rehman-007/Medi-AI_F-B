import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../config/app_theme.dart';
import 'splash_controller.dart';
import '../../../../config/app_config.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'buitems-logo-png_seeklogo-273407.png',
              height: 150,
              width: 150,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.medical_services_rounded,
                    size: 64,
                    color: AppTheme.primary,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // App Name
            Text(
              AppConfig.appName,
              style: AppTheme.h1.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 8),

            // University Name
            Text(
              AppConfig.universityName,
              style: AppTheme.bodyLarge.copyWith(
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),

            // Loading Indicator
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
