# FCM Push Notification Lab

A production-ready Flutter application demonstrating Firebase Cloud Messaging (FCM) push notifications. This app is designed for school laboratory activities and includes complete implementation of push notification handling for both foreground and background states.

## Features

- Firebase Cloud Messaging (FCM) integration
- FCM token generation and display
- Push notifications in foreground (with local notification popup)
- Push notifications in background (system tray)
- Notification permission handling (Android 13+)
- Token refresh monitoring
- Clean, minimal UI for testing
- Copy token functionality
- Comprehensive logging for debugging

## Tech Stack

- **Flutter**: Latest stable version
- **Firebase Core**: ^3.6.0
- **Firebase Messaging**: ^15.1.3
- **Flutter Local Notifications**: ^17.2.3

## Prerequisites

Before running this app, ensure you have:

1. **Flutter SDK** installed (latest stable version)
2. **Android Studio** or VS Code with Flutter extensions
3. **Firebase project** created in Firebase Console
4. **google-services.json** placed in `android/app/google-services.json`
5. **Physical Android device** (recommended) or emulator with Google Play Services

## Setup Instructions

### 1. Firebase Console Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing one
3. Add an Android app with package name: `com.example.push_notification_lab`
4. Download `google-services.json` and place it in `android/app/`
5. Enable Cloud Messaging in Firebase Console

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
# For Android
flutter run

# Or specify device
flutter devices
flutter run -d <device-id>
```

## App Structure

```
lib/
├── main.dart                          # Main app entry point
└── services/
    └── notification_service.dart      # FCM service class
```

## How It Works

### Initialization Flow

1. App starts → Firebase initializes
2. Notification permission requested (Android 13+)
3. FCM token generated and displayed
4. Message handlers set up for foreground/background

### Notification Handling

- **Foreground**: Messages trigger local notification popup
- **Background**: Messages appear in system tray
- **Terminated**: Messages appear in system tray (when app opened)

### Key Components

#### NotificationService

The `NotificationService` class handles:
- Firebase initialization
- Permission requests
- Token generation and refresh
- Message listeners (foreground, background, opened)
- Local notification display

## Testing Push Notifications

### From Firebase Console

1. Open Firebase Console → Cloud Messaging
2. Click "Send your first message"
3. Enter title and body
4. Select target: Use your FCM token (copy from app)
5. Click "Send"
6. Check device for notification

### Expected Behavior

- **App Open**: Notification appears as popup + in logs
- **App Background**: Notification appears in system tray
- **App Terminated**: Notification appears in system tray when app opened

### Log Output

Watch the console for detailed logs:

```
Firebase initialized
NotificationService initialized successfully
Notification permission status: authorized
FCM Token obtained
  Token: <your-token-here>
Foreground message received
  Title: <notification-title>
  Body: <notification-body>
```

## Code Quality

- Clean, structured Flutter code
- Service class pattern for separation of concerns
- Comprehensive error handling
- Detailed logging for debugging
- Well-commented critical sections
- Production-ready implementation

## Troubleshooting

### No Token Generated

- Check `google-services.json` is correctly placed
- Verify Firebase project configuration
- Ensure device has internet connection
- Check Android manifest permissions

### Notifications Not Received

- Verify notification permission granted
- Check Firebase Console message target (use correct token)
- Ensure app is not in Doze mode
- Check device notification settings

### Build Errors

- Run `flutter clean` then `flutter pub get`
- Verify Android SDK version compatibility
- Check Gradle dependencies

## Android Configuration

### Permissions Added

- `INTERNET` - Firebase connectivity
- `POST_NOTIFICATIONS` - Android 13+ notifications
- `WAKE_LOCK` - Background processing
- `VIBRATE` - Notification vibration

### Gradle Configuration

- Google Services plugin applied
- Firebase dependencies configured
- Min SDK set to support notifications

## Project Files

- `pubspec.yaml` - Dependencies configuration
- `android/app/build.gradle.kts` - Android build configuration
- `android/app/src/main/AndroidManifest.xml` - Android permissions
- `lib/main.dart` - Main app UI and initialization
- `lib/services/notification_service.dart` - FCM service

## License

This project is created for educational purposes (school laboratory activity).

## Support

For issues or questions:
1. Check Firebase Console logs
2. Review app console output
3. Verify Firebase project configuration
4. Ensure device compatibility
