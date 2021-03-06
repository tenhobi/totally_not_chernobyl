# Totally Not Chernobyl

[![Actions status](https://github.com/tenhobi/totally_not_chernobyl/workflows/Build/badge.svg)](https://github.com/tenhobi/totally_not_chernobyl/actions)
[![codecov](https://codecov.io/gh/tenhobi/totally_not_chernobyl/branch/master/graph/badge.svg?token=WULJnl23VB)](https://codecov.io/gh/tenhobi/totally_not_chernobyl)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/tenhobi/effective_dart)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## ✨ About

This game is created as part of my [Bachelor's Thesis](https://github.com/tenhobi/bachelors-thesis) in the Czech language.
Due to that, I will not accept any PRs for now.

It uses [Flutter](https://flutter.dev) framework by Google
and [Cloud Firestore](https://firebase.google.com/products/firestore/) for communication.

The code follows the [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).

## 🚀 How to start

### Installation

Following steps will tell you what to install and point you to useful resources:

1. Install [Dart](https://dart.dev/get-dart)—that might not be required, but some external tools may use it.
1. Install [Flutter and other required tools](https://flutter.dev/docs/get-started/install).
1. Install Dart & Flutter packages to your IDE.
1. Install [Android Studio](https://developer.android.com/studio) for Android and [Xcode](https://developer.apple.com/xcode/) for iOS.
1. *If required, set up an Android or iOS emulator.*

### Set Up

Also, before building the app, make sure to:

- Add `android/app/google-services.json` file for Android, provided by Firebase.
- Add `ios/Runner/GoogleService-info.plist` file for iOS, provided by Firebase.

### Running

Run the app using the `flutter run` command.

To learn more, read about building and releasing [an Android app](https://flutter.dev/docs/deployment/android) or [an iOS app](https://flutter.dev/docs/deployment/ios).

### Build

To build an Android apk, run `flutter build apk`.
To create docs, run `dartdoc --exclude 'dart:async,dart:collection,dart:convert,dart:core,dart:developer,dart:io,dart:isolate,dart:math,dart:typed_data,dart,dart:ffi,dart:html,dart:js,dart:ui,dart:js_util'`.

## 🔨 Tools

This section contains some more tools that might help you enhance your development experience.

### [scrcpy](https://github.com/Genymobile/scrcpy)

This tool is useful for providing display and control of Android devices.

After connecting a phone with a USB, run:

```bash
scrcpy --window-title "Totally Not Chernobyl" --always-on-top
```

or for [wireless use](https://github.com/Genymobile/scrcpy#wireless), run:

```bash
adb tcpip 5555
adb connect DEVICE_IP:5555
# then you can unplug
scrcpy --window-title "Totally Not Chernobyl" --always-on-top --bit-rate 2M --max-size 800
```

## 📃 License

Licensed under the [MIT License](LICENSE).
