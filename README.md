

# 🚀 Saoirse App

Saoirse App is a production-ready **Flutter mobile application** with automated **Android and iOS deployments** using **GitHub Actions** and **Fastlane**.

---

## 📱 Platforms

- 🤖 Android — Google Play Store (Internal & Production)
- 🍎 iOS — TestFlight & App Store

---

## 🛠 Tech Stack

- Flutter (Stable)
- GitHub Actions
- Fastlane
- Google Play Console
- Apple App Store Connect
- Firebase
- Razorpay

---

## 📂 Project Structure

```

.
├── android/
│   └── fastlane/
│       └── metadata/android/
├── ios/
│   └── fastlane/
│       └── metadata/en-US/
├── .github/
│   └── workflows/
│       ├── Flutter Android.yml
│       └── Flutter ios.yml
├── lib/
├── assets/
├── pubspec.yaml
└── README.md

```

---

## 🔁 CI/CD Release Flow

Releases are triggered using **Git tags**.

### Create a Release

```

git tag v1.2.3
git push origin v1.2.3

```

This triggers:
- Android build & Play Store deployment
- iOS build & TestFlight upload
- App Store submission (if enabled)

---

## 🤖 Android Deployment

- Workflow: `.github/workflows/Flutter Android.yml`
- Runner: `ubuntu-latest`
- Outputs:
  - APK & AAB build
  - Google Play upload (Internal / Production)

Fastlane location:
```

android/fastlane/

```

---

## 🍎 iOS Deployment

- Workflow: `.github/workflows/Flutter ios.yml`
- Runner: `macos-latest`
- Outputs:
  - IPA build
  - TestFlight upload
  - App Store review submission

Fastlane location:
```

ios/fastlane/

```

---

## 🔐 Secrets Management

All sensitive values are stored in **GitHub Actions Secrets**, including:

- Android keystore
- Google Play service account
- App Store Connect API key
- Firebase configuration
- Razorpay keys

No secrets are committed to the repository.

---

## 🧪 Local Development

### Prerequisites

- Flutter (Stable)
- Android Studio / Xcode
- CocoaPods (macOS)

### Run App

```

flutter pub get
flutter run

```

---

## 🔢 Versioning

Version is managed in `pubspec.yaml`:

```

version: 1.2.3+45

```

- `1.2.3` → App Version
- `45` → Build Number

---

## 📚 References

- https://docs.flutter.dev
- https://docs.fastlane.tools
- https://docs.github.com/actions
- https://play.google.com/console
- https://appstoreconnect.apple.com

---

## 👩‍💻 Maintained By

Saoirse Engineering Team  
Built with clean CI/CD, safety, and scalability in mind.

