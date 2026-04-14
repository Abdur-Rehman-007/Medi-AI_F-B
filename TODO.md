# Medi-AI — Current Project TODO

> Updated: April 6, 2026  
> Status: Core features are implemented; the top evaluation risks are live admin data, dashboard consistency, and backend error standardization.

---

## What is already in place

- Authentication flow: register, OTP, login, forgot password, reset password, logout.
- Medicine reminders with local notification support.
- AI symptom checker backend and frontend screen.
- Health tips backend and frontend screen.
- Doctor, student, faculty, and admin dashboards.
- Profile photo upload support in backend.
- Project structure documentation.

---

## Evaluation-critical fixes

- [x] 🔴 Remove any remaining mock admin data from dashboard screens and API responses.
- [x] 🔴 Ensure student, doctor, and admin dashboards all use live counts and handle 0/1/many records safely.
- [x] 🔴 Standardize backend errors to the format: `{ "success": false, "message": "...", "errors": null }`.

---

## Phase 1 — Current gaps to finish first

### Backend / Data

- [ ] 🔴 Replace mocked admin notifications with real database-backed notifications.
- [ ] 🔴 Replace mocked admin recent activities with real audit/activity data.
- [ ] 🔴 Verify all dashboard statistics endpoints return live data consistently.
- [ ] 🔴 Review notification-related backend flows for production readiness.

### Frontend / Integration

- [ ] 🔴 Connect admin dashboard and reports screens to live backend data where mock data is still used.
- [ ] 🔴 Verify medicine reminder scheduling on all target platforms.
- [ ] 🔴 Confirm health tips and symptom checker screens handle backend failures cleanly.

---

## Phase 2 — Feature polish

### Backend / API quality

- [ ] 🟠 Add or improve appointment audit/history tracking.
- [ ] 🟠 Add stronger DTO validation and consistent API error responses.
- [ ] 🟠 Improve structured logging for key flows such as auth, reminders, and appointments.

### Frontend / UX

- [ ] 🟠 Add better loading and empty states on data-heavy screens.
- [ ] 🟠 Improve network error handling and retry behavior.
- [ ] 🟠 Review any screens still calling APIs directly and refactor into reusable service classes if needed.

---

## Phase 3 — Testing and release prep

### Testing

- [ ] 🟡 Add backend unit tests for services.
- [ ] 🟡 Add controller integration tests for critical endpoints.
- [ ] 🟡 Add Flutter widget tests for login, dashboard, reminders, and health tips.

### Deployment

- [ ] 🟡 Prepare production configuration for API base URL and secrets.
- [ ] 🟡 Verify CORS and HTTPS settings for deployment.
- [ ] 🟡 Build and validate release packages for web and Android.

---

## Phase 4 — Documentation cleanup

- [ ] 🟢 Clean markdown formatting in `README.md`.
- [ ] 🟢 Keep `PROJECT_OVERVIEW.md` and `PROJECT_STRUCTURE.md` in sync with the codebase.
- [ ] 🟢 Remove any stale or duplicate checklist items as features change.

---

## Notes

- The old TODO list contained several items that are already implemented, so it is no longer aligned with the current project state.
- Use this list as the active checklist going forward.
