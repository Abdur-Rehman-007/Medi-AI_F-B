# Backend Status — Medi-AI (.NET 8 / ASP.NET Core)

> Last Updated: February 18, 2026

## Tech Stack

| Component        | Technology                             |
| ---------------- | -------------------------------------- |
| Framework        | ASP.NET Core 8.0                       |
| ORM              | Entity Framework Core 8.0 (Pomelo MySQL) |
| Database         | MySQL 8.0 (`mediaidb`) on localhost:3306 |
| Authentication   | JWT Bearer Tokens (24-hour expiry)     |
| Email            | MailKit via smtp.gmail.com:587 (console mode in dev) |
| API Docs         | Swagger UI at `http://localhost:5280/swagger` |
| CORS             | AllowAll policy (development)          |
| Launch Profile   | `dotnet run --launch-profile http` → port **5280** |

---

## Completed Features

### Authentication (`api/Auth`)

- [x] User registration with OTP email verification
- [x] OTP verification endpoint
- [x] JWT login with email/password
- [x] Get current authenticated user
- [x] Health check endpoint
- [x] BCrypt password hashing
- [x] Role-based tokens (Student, Faculty, Doctor, Admin)

### Doctor Management (`api/Doctors`)

- [x] Get / update doctor profile
- [x] List all doctors (public)
- [x] Get doctor by ID with schedules & reviews (public)
- [x] Filter by specialization (public)
- [x] Search doctors with query, specialization, availability (public)
- [x] List specializations with patient counts (public)
- [x] Available time slots for a given date (public)
- [x] Doctor weekly schedule (public)
- [x] Update doctor availability (doctor/admin)
- [x] **Dashboard statistics** — totalPatients, todayTotal, completedToday, pendingToday
- [x] **Today's appointments** — filtered by logged-in doctor
- [x] **Upcoming appointments** — future appointments for logged-in doctor
- [x] All appointments for logged-in doctor
- [x] Get doctor's unique patients
- [x] Get / update own schedule
- [x] Auto-create doctor profile for Faculty users without one

### Appointments (`api/Appointments`)

- [x] Book new appointment (with conflict detection)
- [x] Get all appointments (admin only)
- [x] Get student upcoming appointments
- [x] Get faculty/doctor appointments
- [x] Get appointment by ID
- [x] **Update appointment status** (Pending → Confirmed → Completed / Cancelled)
- [x] Cancel appointment
- [x] Add prescription to appointment (auto-marks as Completed)

### User Management (`api/Users`)

- [x] Get / update user profile
- [x] Change password
- [x] Upload profile photo (multipart form → `wwwroot/uploads/profiles/`)

### Admin Dashboard (`api/Admin`)

- [x] Dashboard statistics (total users, doctors, appointments, etc.)
- [x] Recent users list (last 5)
- [x] Get all users with role/search filtering
- [x] Delete user
- [x] Toggle user active/suspended status

### Medicine Reminders (`api/MedicineReminders`)

- [x] CRUD operations for reminders
- [x] Toggle active/inactive
- [x] Log medicine intake
- [x] Get today's medicine schedule
- [x] Get active reminders only

### Faculty (`api/Faculty`)

- [x] Get faculty's own appointments
- [x] Faculty appointment statistics

### Database

- [x] Full MySQL schema via `database/mediaidb.sql` (20 tables, 3 views, 2 stored procedures, 4 triggers)
- [x] Seed data (4 test users, 1 doctor profile, 5 schedules, 5 health tips, 10 system settings)

---

## In-Progress Tasks

| Task | Details |
| ---- | ------- |
| Forgot Password / Reset Password | Endpoints exist in `AuthService` but are **commented out** in `AuthController` |
| Resend OTP | Endpoint exists in service but **commented out** in controller |
| Email sending in dev | Currently in **console mode** — logs emails instead of sending them |
| Real OTP flow | Registration auto-sets `IsEmailVerified = true`, bypassing actual OTP verification |

---

## Current Blockers / Known Issues

| # | Issue | Severity | Details |
| - | ----- | -------- | ------- |
| 1 | **Duplicate `statistics` route** | Critical | Two `[HttpGet("statistics")]` methods in `DoctorsController` — causes ambiguous match at runtime. One should be renamed or removed. |
| 2 | **Missing logout endpoint** | Medium | Frontend calls `POST /api/Auth/logout` but this endpoint does **not exist** in `AuthController`. |
| 3 | **Mocked admin data** | Low | `GET /api/Admin/recent-activities` and `GET /api/Admin/notifications` return hardcoded dummy data. |
| 4 | **JWT secret in plaintext** | Low (dev only) | JWT secret key is hardcoded in `appsettings.json` instead of using user secrets or environment variables. |
| 5 | **Unused `JwtService`** | Low | `Services/IJwtService.cs` and `Services/JwtService.cs` in the outer `Backend/Services/` folder are not registered. JWT is handled inline in `AuthService`. |
| 6 | **No EF Core migrations** | Info | Database is managed via raw SQL script; no migration history. |
| 7 | **CORS AllowAll** | Info (dev only) | Acceptable for development but must be restricted before production deployment. |

---

## Next Milestones

1. **Fix duplicate `statistics` route** in `DoctorsController` to resolve runtime route conflict.
2. **Add `POST /api/Auth/logout` endpoint** (blacklist token or simply return success for client-side token removal).
3. **Re-enable Forgot Password / Reset Password / Resend OTP** endpoints and test email delivery.
4. **Replace mocked Admin data** with real database queries for activities and notifications.
5. **Implement AI Symptom Checker endpoint** — frontend has a screen but no backend endpoint exists yet.
6. **Implement Health Tips CRUD endpoints** — data exists in DB but no controller for management.
7. **Add Notification endpoints** — model exists but no controller to push/read notifications.
8. **Secure JWT secret** using .NET User Secrets or environment variables before deployment.
9. **Restrict CORS** to the specific frontend origin for production.
10. **Add EF Core migrations** for proper database versioning and deployment automation.
