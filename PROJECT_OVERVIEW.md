# MediAI: Mobile-Based Healthcare Guidance and Reminder System

![Project Banner](https://img.shields.io/badge/Status-Development-blue) ![Language](https://img.shields.io/badge/Flutter-Dart-00B4AB) ![Backend](https://img.shields.io/badge/.NET-8.0-512BD4)

**MediAI** is a comprehensive Campus Health Management System developed for **BUITEMS** (Balochistan University of Information Technology, Engineering and Management Sciences). It is designed to bridge the gap between Students/Faculty and University Medical Staff through a modern mobile application.

---

## 🎓 Project Information (FYP)

**Title**: MediAI: Mobile-Based Healthcare Guidance and Reminder System for BUITEMS  
**Department**: Computer Engineering  
**Supervisor**: Dr. Muhammad Aadil Siddiqui  

### 👥 Team Members

| Name | CMS ID | Contribution |
| :--- | :--- | :--- |
| **ABDUREHMAN** | 59858 | Full Stack Developer|
| **ZOHA SHAHID** | 60953 | Team Member |
| **ATTQA KHAN** | 61965 | Team Member |

---

## 🏗️ Project Architecture

**Medi-AI** features role-based access control, appointment booking, AI-driven symptom checking, and medicine reminders.

### Tech Stack

| Layer | Technology | Key Libraries/Features |
| :--- | :--- | :--- |
| **Frontend** | **Flutter (Dart)** | GetX (State Management), Dio (Networking), Clean Architecture |
| **Backend** | **ASP.NET Core 8.0** | Web API, Entity Framework Core, Swagger (OpenAPI) |
| **Database** | **MySQL** | Relational Schema, Stored Procedures (optional), Indexes |
| **AI Services** | Integration | External AI APIs for Symptom Checking |

---

## 📱 Frontend (Flutter Application)

The frontend is built with **Flutter** and follows a **Clean Architecture** pattern organized by modules.

### Project Structure

```text
Medi-AI_frontend--main/
├── lib/
│   ├── main.dart
│   ├── config/
│   └── app/
│       ├── data/
│       ├── routes/
│       ├── services/
│       └── modules/
│           ├── auth/
│           ├── admin/
│           ├── doctor/
│           ├── faculty/
│           └── student/
├── assets/
│   ├── animations/
│   ├── icons/
│   └── images/
├── Backend/
│   └── Medi-AI_backend-main/
│       ├── Backend-APIs/
│       │   ├── Controllers/
│       │   ├── DTOs/
│       │   ├── Models/
│       │   ├── Services/
│       │   ├── Properties/
│       │   └── wwwroot/
│       ├── DTOs/
│       └── Services/
├── database/
│   └── mediaidb.sql
├── android/
├── web/
├── windows/
├── test/
└── pubspec.yaml
```

### Frontend Directory Details (`lib/app/`)

- **routes/**: Defines navigation paths (`app_pages.dart`, `app_routes.dart`).
- **data/**: Shared models, repositories, providers, and services.
- **services/**: API helpers and reusable service classes.
- **modules/**: Contains the UI and logic for each feature.
  - **auth/**: Login, registration, OTP verification, set password, forgot password.
  - **student/**: Dashboard, booking, medicine reminders, AI symptom checker, health tips, profile.
  - **faculty/**: Faculty dashboard and related medical features.
  - **doctor/**: Dashboard, today appointments, prescription writing, schedule.
  - **admin/**: Dashboard, user management, reports.

### Key Workflows

1. **Authentication**:
   - **Registration**: User registers -> OTP sent -> User enters OTP -> Set Password -> Login.
   - **Login**: Email/Password -> Receive Bearer Token.
   - **Forgot Password**: Request Reset -> Verify OTP -> Set New Password.
2. **Student/Faculty Flow**:
   - **Dashboard**: Shows stats, upcoming appointments, recent history (Last 30 Days), and quick actions.
   - **Book Appointment**: Select Specialization -> Select Doctor -> Select Date -> Select Slot -> Confirm.
   - **Medicine Reminders**: CRUD operations for daily medication reminders.
3. **Doctor Flow**:
   - View "Today's Appointments".
   - Start consultation -> Write Prescription (Diagnosis + Medicines) -> Complete Appointment.

---

## 🔙 Backend (.NET Web API)

The backend is a **RESTful API** built with local .NET 8.0.

### Project Structure (`Backend/Medi-AI_backend-main/Backend-APIs/`)

- **Controllers/**: API Endpoints.
  - `AuthController`: Registration, Login, OTP, Password Reset.
  - `AppointmentsController`: Booking, Listing, Status Updates.
  - `DoctorsController`: Profile management, Availability slots.
  - `MedicineRemindersController`: Student reminder management.
  - `AdminController`: System oversight.
- **DTOs/**: Data Transfer Objects to validate requests/responses.
  - `RegisterDto`, `CreateAppointmentDto`, `PrescriptionDto`.
- **Services/**: Business logic layer (e.g., `AuthService` handles hashing and token generation).
- **Data/**: `MediaidbContext` (EF Core DbContext).

---

## 🗄️ Database (MySQL)

The database schema (`mediaidb.sql`) is designed to support 4 distinct user roles and their interactions.

### Key Tables & Relationships

#### 1. User Management

- **`Users`**: Central table for ALL roles.
  - Columns: `Id`, `Email`, `PasswordHash`, `Role` ('Student', 'Faculty', 'Doctor', 'Admin'), `IsVerified`.
- **`EmailVerificationOTPs`**: Stores OTPs for registration.
- **`PasswordResetTokens`**: Handles secure password reset flows.

#### 2. Doctor Specifics

- **`Doctors`**: 1-to-1 relationship with `Users`.
  - Columns: `Specialization`, `LicenseNumber`, `ConsultationFee`, `Rating`.
- **`DoctorSchedule`**: Stores availability (Day of Week, Start Time, End Time).
- **`DoctorLeaves`**: Tracks unavailable dates.

#### 3. Appointments & Medical

- **`Appointments`**: The core transaction table.
  - Links `PatientId` (Users) and `DoctorId` (Doctors).
  - Status: `Pending` -> `Confirmed` -> `Completed` / `Cancelled`.
- **`Prescriptions`**: Linked to `Appointments`.
- **`PrescriptionMedicines`**: Items within a prescription.

#### 4. Student Utilities

- **`MedicineReminders`**: Personal reminders for students.
- **`MedicineReminderLogs`**: History of taken/missed doses.
- **`SymptomChecks`**: History of AI interactions.

#### 5. Content

- **`HealthTips`**: Articles/Tips managed by Admins/Doctors.
- **`Notifications`**: System alerts for users.

---

## 🔄 Application Execution Flow

1. **Startup**:
    - Frontend checks for stored Auth Token.
    - If valid -> Redirect to Role-specific Dashboard (Student/Faculty/Doctor).
    - If invalid -> Redirect to `SplashScreen` -> `LoginScreen`.
2. **Booking Encounter**:
    - Student selects "Book Appointment".
    - App calls `GET /Doctors/available`.
    - Student selects a Doctor & Date.
    - App calls `GET /Doctors/{id}/available-slots`.
    - Student confirms.
    - App calls `POST /Appointments`.
    - Backend validates slot, creates record, sets status to `Pending` (or `Confirmed` based on logic).
3. **Real-time Updates**:
    - Dashboards allow "Refresh" to pull the latest `GET /Appointments` data.
    - (Future) Push notifications via `Notifications` table.
