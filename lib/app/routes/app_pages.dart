import 'package:get/get.dart';
import '../modules/auth/splash/splash_screen.dart';
import '../modules/auth/splash/splash_binding.dart';
import '../modules/auth/onboarding/onboarding_screen.dart';
import '../modules/auth/register_email/register_email_screen.dart';
import '../modules/auth/register_email/register_email_binding.dart';
import '../modules/auth/otp_verification/otp_verification_screen.dart';
import '../modules/auth/otp_verification/otp_verification_binding.dart';
import '../modules/auth/set_password/set_password_screen.dart';
import '../modules/auth/login/login_screen.dart';
import '../modules/auth/login/login_binding.dart';
import '../modules/auth/forgot_password/forgot_password_screen.dart';
import '../modules/auth/forgot_password/forgot_password_binding.dart';

// Student screens
import '../modules/student/dashboard/student_dashboard_screen.dart';
import '../modules/student/dashboard/student_dashboard_binding.dart';
import '../modules/student/book_appointment/book_appointment_screen.dart';
import '../modules/student/my_appointments/my_appointments_screen.dart';
import '../modules/student/ai_symptom_checker/ai_symptom_checker_screen.dart';
import '../modules/student/ai_symptom_checker/ai_symptom_checker_binding.dart';
import '../modules/student/medicine_reminders/medicine_reminders_screen.dart';
import '../modules/student/health_tips/health_tips_screen.dart';
import '../modules/student/profile/profile_screen.dart';
import '../modules/student/medical_history/medical_history_screen.dart';
import '../modules/student/medical_history/medical_history_binding.dart';
import '../modules/student/emergency_contacts/emergency_contacts_screen.dart';
import '../modules/student/emergency_contacts/emergency_contacts_binding.dart';

// Doctor screens
import '../modules/doctor/dashboard/doctor_dashboard_screen.dart';
import '../modules/doctor/today_appointments/today_appointments_screen.dart';
import '../modules/doctor/patient_detail/patient_detail_screen.dart';
import '../modules/doctor/write_prescription/write_prescription_screen.dart';
import '../modules/doctor/patients/patients_screen.dart';
import '../modules/doctor/schedule/schedule_screen.dart';
import '../modules/doctor/booking_settings/booking_settings_screen.dart';

// Admin screens
import '../modules/admin/dashboard/admin_dashboard_screen.dart';
import '../modules/admin/manage_users/manage_users_screen.dart';
import '../modules/admin/manage_doctors/manage_doctors_screen.dart';
import '../modules/admin/reports/reports_screen.dart';
import '../modules/admin/system_settings/system_settings_screen.dart';

import 'app_routes.dart';

class AppPages {
  static final routes = [
    // Auth
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
    ),
    GetPage(
      name: AppRoutes.registerEmail,
      page: () => RegisterEmailScreen(),
      binding: RegisterEmailBinding(),
    ),
    GetPage(
      name: AppRoutes.otpVerification,
      page: () => const OtpVerificationScreen(),
      binding: OtpVerificationBinding(),
    ),
    GetPage(
      name: AppRoutes.setPassword,
      page: () => const SetPasswordScreen(),
      binding: SetPasswordBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => LoginScreen(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
      binding: ForgotPasswordBinding(),
    ),

    // Student
    GetPage(
      name: AppRoutes.studentDashboard,
      page: () => const StudentDashboardScreen(),
      binding: StudentDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.bookAppointment,
      page: () => const BookAppointmentScreen(),
      binding: BookAppointmentBinding(),
    ),
    GetPage(
      name: AppRoutes.myAppointments,
      page: () => const MyAppointmentsScreen(),
      binding: MyAppointmentsBinding(),
    ),
    GetPage(
      name: AppRoutes.aiSymptomChecker,
      page: () => const AiSymptomCheckerScreen(),
      binding: AISymptomCheckerBinding(),
    ),
    GetPage(
      name: AppRoutes.medicineReminders,
      page: () => const MedicineRemindersScreen(),
      binding: MedicineRemindersBinding(),
    ),
    GetPage(
      name: AppRoutes.healthTips,
      page: () => const HealthTipsScreen(),
      binding: HealthTipsBinding(),
    ),
    GetPage(
      name: AppRoutes.medicalHistory,
      page: () => const MedicalHistoryScreen(),
      binding: MedicalHistoryBinding(),
    ),
    GetPage(
      name: AppRoutes.emergencyContacts,
      page: () => const EmergencyContactsScreen(),
      binding: EmergencyContactsBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
    ),

    // Doctor
    GetPage(
      name: AppRoutes.doctorDashboard,
      page: () => const DoctorDashboardScreen(),
      binding: DoctorDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.todayAppointments,
      page: () => const TodayAppointmentsScreen(),
      binding: TodayAppointmentsBinding(),
    ),
    GetPage(
      name: AppRoutes.patientDetail,
      page: () => const PatientDetailScreen(),
      binding: PatientDetailBinding(),
    ),
    GetPage(
      name: AppRoutes.writePrescription,
      page: () => const WritePrescriptionScreen(),
      binding: WritePrescriptionBinding(),
    ),
    GetPage(
      name: AppRoutes.patients,
      page: () => const PatientsScreen(),
      binding: PatientsBinding(),
    ),
    GetPage(
      name: AppRoutes.schedule,
      page: () => const ScheduleScreen(),
      binding: ScheduleBinding(),
    ),
    GetPage(
      name: AppRoutes.bookingSettings,
      page: () => const BookingSettingsScreen(),
      binding: BookingSettingsBinding(),
    ),

    // Admin
    GetPage(
      name: AppRoutes.adminDashboard,
      page: () => const AdminDashboardScreen(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.manageUsers,
      page: () => const ManageUsersScreen(),
    ),
    GetPage(
      name: AppRoutes.manageDoctors,
      page: () => const ManageDoctorsScreen(),
    ),
    GetPage(
      name: AppRoutes.reports,
      page: () => const ReportsScreen(),
    ),
    GetPage(
      name: AppRoutes.systemSettings,
      page: () => const SystemSettingsScreen(),
    ),
  ];
}
