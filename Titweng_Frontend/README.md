# Titweng - Cattle Verification System

A biometric cattle verification system for South Sudan that helps prevent cattle theft and ensures authentic trading.

## Features

### Admin Features
- Register new cattle with 10-15 nose print images
- Enter complete cattle and owner details
- Automatic email receipt generation with PDF
- View all registered cattle
- Dashboard with statistics

### User Features
- Verify cattle by uploading nose print images
- Get instant verification results
- View detailed cattle information if registered
- Report suspicious/unregistered cattle to authorities

## Architecture Changes

### From COVA to Titweng
- Renamed from COVA (Cattle Ownership Verification & Authentication) to Titweng
- Removed blockchain dependency
- Switched to PostgreSQL database
- Simplified to admin/user role system

### Database
- PostgreSQL instead of blockchain
- Tables: users, cows
- Stores nose print image paths and embeddings
- Owner details and registration information

### Authentication
- Simple email/password authentication
- Admin role: admin@titweng.com / admin123
- User role: any valid email / password (6+ chars)

### Email System
- Automatic registration receipt emails
- PDF generation with cattle details
- Sent to cow owner's email address

## Technical Stack

- **Frontend**: Flutter
- **Database**: PostgreSQL
- **Email**: SMTP (configurable)
- **PDF Generation**: pdf package
- **Image Processing**: Ready for Siamese CNN + YOLOv8 integration

## Setup

1. Install dependencies:
```bash
flutter pub get
```

2. Configure PostgreSQL:
   - Update database credentials in `lib/services/database_service.dart`
   - Create database: `titweng_db`

3. Configure email:
   - Update SMTP settings in `lib/services/email_service.dart`
   - Use app-specific password for Gmail

4. Run the app:
```bash
flutter run
```

## Demo Credentials

**Admin Access:**
- Email: admin@titweng.com
- Password: admin123

**User Access:**
- Email: any valid email
- Password: minimum 6 characters

## Future Enhancements

- Siamese CNN model integration for nose print matching
- YOLOv8 for cattle detection and nose region extraction
- Real-time verification accuracy improvements
- Mobile-optimized UI/UX enhancements
- Multi-language support (Arabic, local languages)

## File Structure

```
lib/
├── models/
│   ├── cow_model.dart          # Cattle data model
│   └── user_model.dart         # User data model
├── screens/
│   ├── splash_screen.dart      # App splash screen
│   ├── onboarding_screen.dart  # App introduction
│   ├── login_screen.dart       # Authentication
│   ├── admin_dashboard.dart    # Admin main screen
│   ├── user_dashboard.dart     # User main screen
│   ├── admin_register_cattle_screen.dart  # Cattle registration
│   ├── verification_screen.dart           # Cattle verification
│   ├── report_screen.dart      # Report suspicious activity
│   └── cattle_details_screen.dart        # Cattle information
├── services/
│   ├── database_service.dart   # PostgreSQL operations
│   └── email_service.dart      # Email and PDF generation
├── utils/
│   └── app_theme.dart         # App styling and colors
└── main.dart                  # App entry point
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

This project is licensed under the MIT License.