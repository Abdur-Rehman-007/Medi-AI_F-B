import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:get/get.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/services/storage_service.dart';
import 'app/services/api_service.dart';
import 'app/services/auth_service.dart';
import 'app/services/notification_service.dart';
import 'config/app_theme.dart';
import 'config/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // final storageService = Get.find<StorageService>();
  // storageService.clearAll();
  // Initialize Firebase
  // await Firebase.initializeApp();

  // Initialize Hive (only on mobile/desktop, not web)
  if (!kIsWeb) {
    await Hive.initFlutter();
  }

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize services
  await initServices();

  runApp(const MediAIApp());
}

Future<void> initServices() async {
  Get.put(await StorageService().init());
  Get.put(await ApiService().init());
  Get.put(await AuthService().init());
  Get.put(await NotificationService().init());
}

class MediAIApp extends StatelessWidget {
  const MediAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 300),
    );
  }
}
