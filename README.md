# Medi-AI Medical Center Management System

A comprehensive medical center management system built with Flutter for BUITMS (Balochistan University of Information Technology, Engineering and Management Sciences). This system manages appointments, medical records, medicine reminders, and administrative tasks for students, faculty, and doctors.

## 🎯 Project Overview

Medi-AI is a full-stack medical management application designed to streamline healthcare operations at educational institutions. The system provides role-based access for Students, Faculty, Doctors, and Administrators, each with specific functionalities tailored to their needs.

## ✨ Current Features (Working)

### Authentication System
- ✅ User registration with email verification
- ✅ OTP-based verification (10-minute expiry)
- ✅ JWT-based authentication (7-day token expiry)
- ✅ Secure password hashing with BCrypt
- ✅ Role-based access control (Student, Faculty, Doctor, Admin)

### Patient Features (Student/Faculty)
- ✅ **Medicine Reminders/Alarms** - Set medication reminders with custom schedules
  - Data saves to MySQL database
  - Real-time notifications
  - Track medication history
- ✅ **Appointment Booking** - Book appointments with doctors
  - Data saves to MySQL database
  - View booking history
  - Appointment status tracking

### Doctor Features
- ✅ **Dashboard** - View real-time statistics (Total Patients, Today's Appointments, Pending, Completed)
- ✅ **Today's Appointments** - Manage daily schedule
  - View patient details and specifications
  - **Actions**: Confirm, Cancel, and Mark as Checked
  - Status updates reflect immediately on dashboard
- 🔄 Patient management (UI ready, needs backend integration)
- 🔄 Schedule management (UI ready, needs backend integration)
- 🔄 Availability settings (UI ready, needs backend integration) 

### Admin Features
- 🔄 User management (UI ready, needs backend)
- 🔄 Reports generation (UI ready, needs backend)
- 🔄 System statistics (UI ready, needs backend)

### Faculty Features
- 🔄 Faculty-specific dashboard (UI ready, needs backend)
- 🔄 Medical records access (UI ready, needs backend)

## 🛠️ Tech Stack

### Frontend
- **Framework**: Flutter 3.24+
- **Language**: Dart 3.5+
- **State Management**: GetX
- **HTTP Client**: Dio
- **UI**: Material Design 3

### Backend (Implemented & Connected)
- **Framework**: ASP.NET Core 8.0
- **Port**: Running on `http://localhost:5280`
- **ORM**: Entity Framework Core 8.0
- **Database**: MySQL 8.0+
- **Authentication**: JWT Bearer Tokens
- **Swagger UI**: Available at `http://localhost:5280/swagger`

### Required NuGet Packages
```bash
dotnet add package Microsoft.EntityFrameworkCore --version 8.0.0
dotnet add package Pomelo.EntityFrameworkCore.MySql --version 8.0.0
dotnet add package Microsoft.AspNetCore.Authentication.JwtBearer --version 8.0.0
dotnet add package BCrypt.Net-Next --version 4.0.3
dotnet add package MailKit --version 4.3.0
dotnet add package Swashbuckle.AspNetCore --version 6.5.0
```

## 📁 Project Structure

```
lib/
├── app/
│   ├── modules/          # Feature modules
│   │   ├── auth/         # Authentication (login, register, OTP)
│   │   ├── student/      # Student dashboard & features
│   │   ├── faculty/      # Faculty dashboard & features
│   │   ├── doctor/       # Doctor dashboard & features
│   │   ├── admin/        # Admin dashboard & features
│   │   └── common/       # Shared widgets
│   ├── services/         # API services
│   │   ├── api_service.dart
│   │   └── auth_service.dart
│   ├── routes/           # App navigation
│   └── data/             # Models & repositories
├── config/               # App configuration
└── main.dart            # App entry point
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.24 or higher
- Dart SDK 3.5 or higher
- Visual Studio Code or Android Studio
- Chrome (for web development)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/medi-ai.git
   ```

2. **Start the Backend Server**
   **Crucial Step:** The frontend requires the backend to be running on port **5280**.
   ```bash
   cd "Backend/Medi-AI_backend-main/Backend-APIs"
   dotnet restore
   dotnet run --launch-profile http
   ```
   *Verify it's running by visiting: [http://localhost:5280/swagger](http://localhost:5280/swagger)*

3. **Configure Frontend**
   - Check `lib/config/app_config.dart`
   - Ensure `baseUrl` is set to: `http://localhost:5280/api`

4. **Run the Flutter App**
   ```bash
   flutter pub get
   flutter run -d chrome  # For Web
   # OR
   flutter run -d windows # For Desktop
   ```
```bash
git clone <repository-url>
cd "Medi-AI Frontend"
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Update API configuration**
Edit `lib/config/app_config.dart`:
```dart
static const String baseUrl = 'https://localhost:7228/api';
```

4. **Run the application**
```bash
# For web
flutter run -d chrome

# For Android
flutter run

# For iOS
flutter run
```

## 🗄️ Database Schema

### Users Table
```sql
CREATE TABLE Users (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(255) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    FullName VARCHAR(255) NOT NULL,
    PhoneNumber VARCHAR(20),
    Role VARCHAR(50) NOT NULL,
    CmsId VARCHAR(50),
    IsEmailVerified BOOLEAN DEFAULT FALSE,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### OTPVerifications Table
```sql
CREATE TABLE OTPVerifications (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    Email VARCHAR(255) NOT NULL,
    Otp VARCHAR(6) NOT NULL,
    ExpiresAt DATETIME NOT NULL,
    IsUsed BOOLEAN DEFAULT FALSE,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);
```

### Appointments Table
```sql
CREATE TABLE Appointments (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    PatientId INT NOT NULL,
    DoctorId INT NOT NULL,
    AppointmentDate DATE NOT NULL,
    AppointmentTime TIME NOT NULL,
    Status VARCHAR(50) DEFAULT 'Pending',
    Reason TEXT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientId) REFERENCES Users(Id),
    FOREIGN KEY (DoctorId) REFERENCES Users(Id)
);
```

### MedicineReminders Table
```sql
CREATE TABLE MedicineReminders (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    UserId INT NOT NULL,
    MedicineName VARCHAR(255) NOT NULL,
    Dosage VARCHAR(100),
    Frequency VARCHAR(50),
    StartDate DATE NOT NULL,
    EndDate DATE,
    ReminderTime TIME NOT NULL,
    IsActive BOOLEAN DEFAULT TRUE,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserId) REFERENCES Users(Id)
);
```

### DoctorAvailability Table
```sql
CREATE TABLE DoctorAvailability (
    Id INT AUTO_INCREMENT PRIMARY KEY,
    DoctorId INT NOT NULL,
    DayOfWeek VARCHAR(20) NOT NULL,
    IsAvailable BOOLEAN DEFAULT TRUE,
    StartTime TIME,
    EndTime TIME,
    BreakStartTime TIME,
    BreakEndTime TIME,
    SlotDuration INT DEFAULT 30,
    MaxPatientsPerDay INT DEFAULT 16,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (DoctorId) REFERENCES Users(Id),
    UNIQUE KEY unique_doctor_day (DoctorId, DayOfWeek)
);
```

## 🔌 Required API Endpoints

### Authentication Endpoints (✅ Working)
```
POST /api/Auth/register          - Register new user
POST /api/Auth/verify-otp        - Verify OTP code
POST /api/Auth/login             - User login
POST /api/Auth/send-otp          - Resend OTP
```

### Doctor Endpoints (🔴 Need Implementation)
```
GET  /api/Doctor/appointments/today      - Get today's appointments
GET  /api/Doctor/appointments/upcoming   - Get upcoming appointments
GET  /api/Doctor/statistics              - Get doctor statistics
GET  /api/Doctor/patients                - Get all patients
GET  /api/Doctor/schedule                - Get weekly schedule
PUT  /api/Doctor/appointments/{id}/status - Update appointment status
GET  /api/Doctor/availability            - Get availability settings
POST /api/Doctor/availability            - Update availability settings
```

### Patient Endpoints (🔴 Need Implementation)
```
GET  /api/Patient/appointments           - Get patient appointments
POST /api/Patient/appointments           - Book new appointment
GET  /api/Patient/medical-records        - Get medical records
POST /api/Patient/medicine-reminders     - Create medicine reminder
GET  /api/Patient/medicine-reminders     - Get all reminders
PUT  /api/Patient/medicine-reminders/{id} - Update reminder
DELETE /api/Patient/medicine-reminders/{id} - Delete reminder
```

### Admin Endpoints (🔴 Need Implementation)
```
GET  /api/Admin/users                    - Get all users
GET  /api/Admin/statistics               - Get system statistics
GET  /api/Admin/reports/{type}           - Generate reports
POST /api/Admin/users                    - Create new user
PUT  /api/Admin/users/{id}               - Update user
DELETE /api/Admin/users/{id}             - Delete user
```

## 📊 Current Status

### ✅ Completed
- Frontend UI for all modules (Student, Faculty, Doctor, Admin)
- Authentication flow (Register → OTP → Login)
- Medicine reminders with database integration
- Appointment booking with database integration
- Responsive design for web and mobile
- Role-based routing and access control
- API service layer with error handling
- GetX state management setup

### 🔄 In Progress / Pending
- Backend API implementation (ASP.NET Core)
- Doctor dashboard endpoints
- Doctor availability management
- Patient records management
- Admin statistics and reports
- Faculty-specific features
- Real-time notifications
- File upload for medical records

### 🔴 Known Issues
- 404 errors for doctor endpoints (backend not implemented)
- Empty states shown for patient list, schedule (no backend data)

## 🔐 Security Features

- ✅ Password hashing with BCrypt (cost factor: 11)
- ✅ JWT token authentication (7-day expiry)
- ✅ OTP verification (10-minute expiry)
- ✅ Role-based access control
- ✅ HTTPS enforcement
- ✅ CORS configuration for secure API calls

## 🧪 Testing

### Test Accounts (After Backend Setup)
```
Doctor:
Email: doctor@buitms.edu.pk
Password: Doctor123!

Student:
Email: student@buitms.edu.pk
Password: Student123!

Admin:
Email: admin@buitms.edu.pk
Password: Admin123!
```

## 📝 API Configuration

The app uses the following configuration:

**Base URL**: `https://localhost:7228/api`

**Request Format**: JSON with Pascal case
```json
{
  "Email": "user@example.com",
  "Password": "password123",
  "FullName": "John Doe"
}
```

**Authentication**: Bearer token in headers
```
Authorization: Bearer <jwt-token>
```

## 🎨 Color Scheme

```dart
Primary Color: #2E7D32 (Green)
Secondary Color: #1976D2 (Blue)
Background: #F5F5F5 (Light Gray)
Surface: #FFFFFF (White)
Error: #D32F2F (Red)
Success: #4CAF50 (Green)
```

## 📱 Supported Platforms

- ✅ Web (Chrome, Firefox, Safari, Edge)
- ✅ Android (API 21+)
- ✅ iOS (iOS 12+)
- ✅ Windows (Desktop)
- ✅ macOS (Desktop)
- ✅ Linux (Desktop)

## 🤝 Contributing

1. Create a feature branch
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## 📄 License

This project is developed for BUITMS Medical Center.

## 👥 Roles & Permissions

### Student
- Book appointments
- Set medicine reminders
- View medical records
- View appointment history

### Faculty
- All student features
- Priority appointment booking
- Access to extended medical records

### Doctor
- View patient list
- Manage appointments
- Update appointment status
- Set availability schedule
- View patient medical history

### Admin
- User management (CRUD)
- System statistics
- Generate reports
- Manage all appointments
- System configuration

## 🚨 Important Notes

1. **Backend Required**: Most features require backend API implementation
2. **Database Setup**: MySQL 8.0+ database must be created and configured
3. **JWT Secret**: Generate a secure 32+ character secret for JWT tokens
4. **Email Configuration**: Configure SMTP settings for OTP delivery
5. **CORS**: Ensure backend allows requests from Flutter app origin

## 🔧 Configuration Files

### appsettings.json (Backend)
```json
{
  "ConnectionStrings": {
    "DefaultConnection": "server=localhost;database=mediai;user=root;password=yourpassword"
  },
  "Jwt": {
    "Secret": "your-32-character-secret-key-here",
    "Issuer": "MediAI",
    "Audience": "MediAI-Users",
    "ExpiryInDays": 7
  },
  "Email": {
    "SmtpServer": "smtp.gmail.com",
    "SmtpPort": 587,
    "SenderEmail": "noreply@mediai.com",
    "SenderName": "Medi-AI System"
  }
}
```

## 📞 Support

For issues or questions, please create an issue in the repository.

---

**Status**: Active Development
**Last Updated**: December 13, 2025
**Version**: 1.0.0
