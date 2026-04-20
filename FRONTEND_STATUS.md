# Frontend Status — Medi-AI (Flutter + GetX)

> Last Updated: February 18, 2026

## Tech Stack

| Component          | Technology                                |
| ------------------ | ----------------------------------------- |
| Framework          | Flutter 3.24+ / Dart 3.5+                |
| State Management   | GetX 4.6.6                                |
| HTTP Client        | Dio 5.4.0 with auth interceptor           |
| Secure Storage     | FlutterSecureStorage (mobile) / SharedPreferences (web) |
| Local DB           | Hive 2.2.3                                |
| UI                 | Material Design 3, Google Fonts, Lottie   |
| Backend URL        | `http://localhost:5280/api`               |
| Platforms          | Chrome (Web), Windows (Desktop), Android  |

---

## Completed Features

### Authentication Module

- [x] **Splash Screen** — auto-detects auth state and routes to correct dashboard
- [x] **Onboarding Screen** — first-run introduction slides
- [x] **Login Screen** — email/password login with JWT token handling
- [x] **Registration Screen** — email registration with role selection
- [x] Auto token injection on all API calls via `_AuthInterceptor`
- [x] Auto token refresh on 401 responses
- [x] Secure token storage (platform-adaptive)
- [x] Role-based routing (Student → `/student-dashboard`, Doctor → `/doctor-dashboard`, etc.)

### Student Module (7 screens)

- [x] **Dashboard** — overview with quick actions, upcoming appointments
- [x] **Book Appointment** — select doctor, date, time, symptoms → books via API
- [x] **My Appointments** — list of upcoming/past appointments with status tracking
- [x] **AI Symptom Checker** — UI screen (frontend only, no backend endpoint yet)
- [x] **Medicine Reminders** — CRUD reminders with custom schedules via API
- [x] **Health Tips** — display health tips (UI ready)
- [x] **Profile** — view and edit user profile

### Doctor Module (6 screens)

- [x] **Dashboard** — real-time statistics cards (Total Patients, Today's Appointments, Completed, Pending)
- [x] **Today's Appointments** — list with Confirm / Cancel / Mark Checked actions
- [x] **Patients** — view unique patients list
- [x] **Schedule** — view and manage weekly schedule
- [x] **Patient Detail** — view individual patient information
- [x] **Write Prescription** — add prescription to appointment

### Doctor Dashboard — API Integration

- [x] `DoctorService.getStatistics()` → `GET /api/Doctors/statistics`
- [x] `DoctorService.getTodayAppointments()` → `GET /api/Doctors/appointments/today`
- [x] `DoctorService.getUpcomingAppointments()` → `GET /api/Doctors/appointments/upcoming`
- [x] `DoctorService.getAllAppointments()` → `GET /api/Doctors/appointments`
- [x] `DoctorService.getPatients()` → `GET /api/Doctors/patients`
- [x] `DoctorService.getMySchedule()` → `GET /api/Doctors/my-schedule`
- [x] `DoctorService.updateSchedule()` → `POST /api/Doctors/schedule`
- [x] `DoctorService.addPrescription()` → `PUT /api/Appointments/{id}/prescription`
- [x] `TodayAppointmentsController.updateStatus()` → `PUT /api/Appointments/{id}/status`

### Admin Module (5 screens)

- [x] **Dashboard** — statistics overview (connected to `GET /api/Admin/statistics`)
- [x] **Manage Users** — list, search, toggle status, delete users
- [x] **Manage Doctors** — doctor management interface
- [x] **Reports** — report generation UI (with web download helper)
- [x] **System Settings** — settings management UI

### Faculty Module (1 screen)

- [x] **Dashboard** — faculty-specific dashboard with appointment overview

### Core Services

- [x] **ApiService** — generic Dio wrapper with `get`, `post`, `put`, `delete`, `patch`
- [x] **AuthService** — login, register, OTP verify, logout, getCurrentUser
- [x] **DoctorService** — all doctor panel operations (11 methods)
- [x] **StorageService** — token storage, user caching, onboarding state

### Data Models

- [x] `User` — with role-based getters (`isStudent`, `isFaculty`, `isDoctor`, `isAdmin`)
- [x] `Appointment` — with status helpers (`isPending`, `canCancel`, `canReschedule`)
- [x] `Doctor` — doctor profile with schedule info
- [x] `HealthTip` — health tip model
- [x] `MedicineReminder` — with Hive annotations for local storage
- [x] `ApiResponse<T>` — generic response wrapper

### Navigation (32 active routes)

- [x] Auth: `/`, `/onboarding`, `/register-email`, `/login`
- [x] Student: `/student-dashboard`, `/book-appointment`, `/my-appointments`, `/ai-symptom-checker`, `/medicine-reminders`, `/health-tips`, `/profile`
- [x] Doctor: `/doctor-dashboard`, `/today-appointments`, `/patient-detail`, `/write-prescription`, `/patients`, `/schedule`
- [x] Faculty: `/faculty-dashboard`
- [x] Admin: `/admin-dashboard`, `/manage-users`, `/manage-doctors`, `/system-settings`, `/reports`

---

## In-Progress Tasks

| Task | Details |
| ---- | ------- |
| OTP Verification Screen | Screen file exists but route is **commented out** |
| Set Password Screen | Screen file exists but route is **commented out** |
| Forgot Password Screen | Screen file exists but route is **commented out** |
| Faculty module expansion | Only has a dashboard — no dedicated appointment booking or medical records screens |

---

## Current Blockers / Known Issues

| # | Issue | Severity | Details |
| - | ----- | -------- | ------- |
| 1 | **Logout endpoint missing on backend** | Medium | `AuthService.logout()` calls `POST /api/Auth/logout` which does not exist on the backend. Logout works client-side (clears tokens) but the API call fails silently. |
| 2 | **AI Symptom Checker — no backend** | Medium | The screen exists at `/ai-symptom-checker` but there is no backend API to process symptoms. Currently a placeholder UI. |
| 3 | **MedicineReminder Hive adapter not generated** | Low | Model uses `@HiveType` annotations but the `.g.dart` adapter file import is commented out. Hive local caching won't work until `build_runner` generates it. |
| 4 | **NotificationService is a stub** | Low | Local push notifications are disabled. Service only logs to console. `flutter_local_notifications` dependency is commented out in `pubspec.yaml`. |
| 5 | **Health Tips — no dedicated service** | Low | The `HealthTip` model exists, and a screen is present, but there is no `HealthTipService` to fetch data from the backend. |
| 6 | **Backend duplicate statistics route** | Medium | The backend has two `[HttpGet("statistics")]` in `DoctorsController` which may cause a runtime 500 error when the dashboard loads. |
| 7 | **Profile photo upload** | Low | Backend endpoint exists (`POST /api/Users/upload-photo`) but no frontend UI to trigger the upload. |

---

## Next Milestones

1. **Fix backend duplicate statistics route** — required for doctor dashboard to load reliably.
2. **Implement AI Symptom Checker backend** — create endpoint and connect the existing frontend screen.
3. **Re-enable OTP / Forgot Password flows** — uncomment routes, connect to backend endpoints once they are re-enabled.
4. **Create HealthTipService** — add a service to fetch health tips from the database and display in the Health Tips screen.
5. **Add profile photo upload UI** — add camera/gallery picker on the Profile screen and connect to the upload endpoint.
6. **Generate Hive adapters** — run `dart run build_runner build` to generate `MedicineReminder` Hive adapter for local caching.
7. **Enable push notifications** — uncomment `flutter_local_notifications` dependency, implement `NotificationService`, and connect to backend notification model.
8. **Expand Faculty module** — add appointment booking, medical records, and other faculty-specific features.
9. **Add appointment detail screen** — a dedicated view when tapping an appointment (currently navigates to `/appointment-detail` route which may not be fully implemented).
10. **Production configuration** — switch `baseUrl` to Azure deployment URL, restrict CORS, use HTTPS.
