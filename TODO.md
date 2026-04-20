# Medi-AI — Database Alignment TODO

> Updated: April 16, 2026
> Goal: Align all frontend flows, backend APIs, and SQL schema to a single source of truth (`mediaidb`).

---

## 1) Core Alignment Status

- [x] Doctor registration now includes required doctor table fields (`Specialization`, `LicenseNumber`, `Qualification`) and creates both `users` + `doctors` records.
- [x] Doctor booking settings are persisted in database (`systemsettings`) and used by slot generation + appointment booking validation.
- [ ] Full app-wide schema audit (all roles/modules) completed and signed off.

---

## 2) Authentication & User Data (users table)

### Backend
- [x] Normalize role values to DB enum: `Student`, `Faculty`, `Doctor`, `Admin`.
- [x] Store user profile fields aligned with schema: `Department`, `RegistrationNumber`, `PhoneNumber`, `DateOfBirth`, `Gender`, `Address`.
- [ ] Add server-side validation rules per role:
	- [ ] Student: require `Department` and `RegistrationNumber`.
	- [ ] Faculty: require `Department` and `RegistrationNumber`.
	- [x] Doctor: require doctor profile fields.
	- [ ] Admin: decide whether self-registration is allowed.

### Frontend
- [x] Doctor signup form updated with doctor profile fields.
- [x] Removed non-persistent `Campus` requirement from signup flow.
- [ ] Make role-based required-field hints explicit in UI copy.

---

## 3) Doctor Module Alignment

### Registration/Profile
- [x] Create doctor profile row on doctor registration.
- [ ] Add doctor profile edit UI for all doctor table fields:
	- [ ] `Specialization`, `LicenseNumber`, `Qualification`
	- [ ] `Experience`, `ConsultationFee`, `RoomNumber`, `Bio`

### Scheduling & Booking
- [x] Slot generation uses doctor DB settings (duration + break window).
- [x] Appointment booking enforces schedule window and exact slot boundary.
- [x] Appointment booking enforces max-patients-per-day.
- [ ] Ensure appointment update endpoint uses same slot validation rules as booking endpoint.
- [ ] Add leave-date conflict check (`doctorleaves`) in slot generation and booking/update.

### Monitoring Patients
- [ ] Verify doctor patients list uses only DB-backed fields and supports null-safe rendering.
- [ ] Ensure appointment status transition flow matches DB enum values exactly.

---

## 4) Student/Faculty/Admin Module Alignment

### Student
- [ ] Validate `book appointment` payload and response shapes against backend DTOs.
- [ ] Confirm medicine reminders CRUD maps exactly to `medicinereminders` schema (frequency/custom/times/date).

### Faculty
- [ ] Validate faculty dashboard data sources are backend-driven and schema-consistent.
- [ ] Confirm faculty medicine reminders behavior is intentional vs. student-only reminder table design.

### Admin
- [ ] Align admin dashboard stats with DB views/tables (no mocked rows).
- [ ] Align reports and system settings pages to real backend endpoints + DB keys.

---

## 5) Database Consistency Tasks

- [ ] Standardize on one canonical SQL file for setup (`database/Medi_ai_db.sql` vs `database/mediaidb.sql`), then keep the other generated/synced.
- [ ] Add migration/seed note for doctor booking settings key pattern:
	- `DoctorBookingSettings:{doctorId}` in `systemsettings` with `DataType='JSON'`.
- [ ] Review nullable vs required constraints and mirror in DTO validation.
- [ ] Add unique/index checks in code paths where schema relies on unique keys (`users.Email`, `doctors.LicenseNumber`).

---

## 6) API & Error Contract Alignment

- [ ] Standardize all error responses to one shape for frontend parsing.
- [ ] Ensure all role-sensitive endpoints consistently enforce `[Authorize(Roles=...)]` rules.
- [ ] Add API contract table (endpoint -> request DTO -> response DTO -> DB tables touched).

---

## 7) Testing Checklist (Required for final alignment)

### Backend tests
- [ ] Register Doctor creates both `users` and `doctors` rows.
- [ ] Register Student/Faculty/Admin writes valid `users` row only.
- [ ] Booking rejects off-schedule, break-time, and non-slot-aligned requests.
- [ ] Booking respects max patients/day setting.

### Frontend tests
- [ ] Role-based signup field visibility and validation tests.
- [ ] Doctor settings load/save round-trip against backend.
- [ ] Dashboard screens render with empty/null/live data safely.

---

## 8) Final Sign-off Criteria

- [ ] Every role flow maps to DB schema with no unused required UI fields.
- [ ] Every DB-required field is validated either in frontend or backend (prefer backend authoritative).
- [ ] No feature relies on local-only config when DB persistence exists.
- [ ] Full smoke test passes: register -> login -> role dashboard -> key actions -> logout.
