import 'package:get/get.dart';
import '../data/models/api_response.dart';
import '../data/models/appointment.dart';
import '../services/api_service.dart';
import '../../config/app_config.dart';

class DoctorService extends GetxService {
  final _apiService = Get.find<ApiService>();

  // Get doctor's dashboard statistics
  Future<ApiResponse<Map<String, dynamic>>> getStatistics() async {
    return await _apiService.get<Map<String, dynamic>>(
      '${AppConfig.baseUrl}/Doctors/statistics',
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  // Get today's appointments for the doctor
  Future<ApiResponse<List<Appointment>>> getTodayAppointments() async {
    return await _apiService.get<List<Appointment>>(
      '${AppConfig.baseUrl}/Doctors/appointments/today',
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => Appointment.fromJson(item)).toList();
        }
        return [];
      },
    );
  }

  // Get upcoming appointments for the doctor
  Future<ApiResponse<List<Appointment>>> getUpcomingAppointments() async {
    return await _apiService.get<List<Appointment>>(
      '${AppConfig.baseUrl}/Doctors/appointments/upcoming',
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => Appointment.fromJson(item)).toList();
        }
        return [];
      },
    );
  }

  // Get all appointments for the doctor
  Future<ApiResponse<List<Appointment>>> getAllAppointments() async {
    return await _apiService.get<List<Appointment>>(
      '${AppConfig.baseUrl}/Doctors/appointments',
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => Appointment.fromJson(item)).toList();
        }
        return [];
      },
    );
  }

  // Get doctor's patients
  Future<ApiResponse<List<Map<String, dynamic>>>> getPatients() async {
    return await _apiService.get<List<Map<String, dynamic>>>(
      '${AppConfig.baseUrl}/Doctors/patients',
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => item as Map<String, dynamic>).toList();
        }
        return [];
      },
    );
  }

  // Get doctor's schedule
  Future<ApiResponse<List<Map<String, dynamic>>>> getMySchedule() async {
    return await _apiService.get<List<Map<String, dynamic>>>(
      '${AppConfig.baseUrl}/Doctors/my-schedule',
      fromJson: (json) {
        if (json is List) {
          return json.map((item) => item as Map<String, dynamic>).toList();
        }
        return [];
      },
    );
  }

  // Update schedule
  Future<ApiResponse<Object>> updateSchedule(List<Map<String, dynamic>> schedules) async {
    return await _apiService.post<Object>(
      '${AppConfig.baseUrl}/Doctors/schedule',
      data: {'schedules': schedules},
    );
  }

  // Get specific appointment details
  Future<ApiResponse<Appointment>> getAppointmentDetails(String id) async {
    return await _apiService.get<Appointment>(
      '${AppConfig.baseUrl}/Appointments/$id',
      fromJson: (json) => Appointment.fromJson(json),
    );
  }

  // Get current doctor profile
  Future<ApiResponse<Map<String, dynamic>>> getMyProfile() async {
    return await _apiService.get<Map<String, dynamic>>(
      '${AppConfig.baseUrl}/Doctors/profile',
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  // Update doctor profile
  Future<ApiResponse<Map<String, dynamic>>> updateProfile(
      Map<String, dynamic> data) async {
    return await _apiService.put<Map<String, dynamic>>(
      '${AppConfig.baseUrl}/Doctors/profile',
      data: data,
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }

  // Add prescription to appointment
  Future<ApiResponse<Map<String, dynamic>>> addPrescription(String appointmentId, String prescription) async {
    return await _apiService.put<Map<String, dynamic>>(
      '${AppConfig.baseUrl}/Appointments/$appointmentId/prescription',
      data: { 'prescription': prescription },
      fromJson: (json) => json as Map<String, dynamic>,
    );
  }
}


