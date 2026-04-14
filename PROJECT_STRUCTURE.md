# Project Structure

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
├── build/
└── pubspec.yaml
```

## Notes

- `lib/` contains the Flutter application code.
- `Backend/` contains the ASP.NET Core backend.
- `database/` contains the SQL schema.
- `build/` is generated output and should not be edited manually.
