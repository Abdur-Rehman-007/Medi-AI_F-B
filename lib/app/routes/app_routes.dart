class AppRoutes {
  // Auth Routes
  static const splash = '/';
  static const onboarding = '/onboarding';
  static const registerEmail = '/register-email';
  static const otpVerification = '/otp-verification';
  static const setPassword = '/set-password';
  static const login = '/login';
  static const forgotPassword = '/forgot-password';

  // Student Routes
  static const studentDashboard = '/student-dashboard';
  static const bookAppointment = '/book-appointment';
  static const myAppointments = '/my-appointments';
  static const aiSymptomChecker = '/ai-symptom-checker';
  static const medicineReminders = '/medicine-reminders';
  static const healthTips = '/health-tips';
  static const medicalHistory = '/medical-history';
  static const emergencyContacts = '/emergency-contacts';
  static const profile = '/profile';

  // Doctor Routes
  static const doctorDashboard = '/doctor-dashboard';
  static const todayAppointments = '/today-appointments';
  static const patientDetail = '/patient-detail';
  static const writePrescription = '/write-prescription';
  static const appointmentDetail = '/appointment-detail';
  static const patients = '/patients';
  static const schedule = '/schedule';
  static const bookingSettings = '/booking-settings';

  // Faculty Routes
  static const facultyDashboard = studentDashboard;
  static const facultyMedicineReminders = medicineReminders;

  // Admin Routes
  static const adminDashboard = '/admin-dashboard';
  static const manageUsers = '/manage-users';
  static const manageDoctors = '/manage-doctors';
  static const systemSettings = '/system-settings';
  static const reports = '/reports';

  // Common Routes
  static const notifications = '/notifications';
  static const settings = '/settings';
}
