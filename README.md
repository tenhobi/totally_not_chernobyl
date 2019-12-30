# Totally Not Chernobyl

[![Actions status](https://github.com/tenhobi/totally-not-chernobyl/workflows/CI/badge.svg)](https://github.com/tenhobi/totally-not-chernobyl/actions)
[![codecov](https://codecov.io/gh/tenhobi/totally-not-chernobyl/branch/master/graph/badge.svg?token=WULJnl23VB)](https://codecov.io/gh/tenhobi/totally-not-chernobyl)
[![style: effective dart](https://img.shields.io/badge/style-effective_dart-40c4ff.svg)](https://github.com/tenhobi/effective_dart)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

## ✨ About

This game is created as part of my [Bachelor's Thesis](https://github.com/tenhobi/bachelors-thesis) in the Czech language. Due to that, I will not accept any PRs for now.

It uses [Flutter](https://flutter.dev) framework by Google, [Cloud Firestore](https://firebase.google.com/products/firestore/) for communication and [Rive](https://rive.app) for some special effects.

The code follows the [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html).

## 🚀 How to start

### Installation

Following steps will tell you what to install and point you to useful resources:

1. Install [Dart](https://dart.dev/get-dart)—that might not be required, but some external tools may use it.
1. Install [Flutter and other required tools](https://flutter.dev/docs/get-started/install).
1. Install Dart & Flutter packages to your IDE.
1. Install [Android Studio](https://developer.android.com/studio) for Android and [Xcode](https://developer.apple.com/xcode/) for iOS.
1. *If required, set up an Android or iOS emulator.*

Also, before building the app, make sure to:

- Add `android/app/google-services.json` file, provided by Firebase.

### Running

Run the app using the `flutter run` command.

To learn more, read about building and releasing [an Android app](https://flutter.dev/docs/deployment/android) or [an iOS app](https://flutter.dev/docs/deployment/ios).

## 🔨 Tools

This section contains some more tools that might help you enhance your development experience.

### [scrcpy](https://github.com/Genymobile/scrcpy)

This tool is useful for providing display and control of Android devices.

After connecting a phone with a USB, run:

```bash
scrcpy --window-title 'Totally Not Chernobyl' --always-on-top
```

or for [wireless use](https://github.com/Genymobile/scrcpy#wireless), run:

```bash
scrcpy --window-title 'Totally Not Chernobyl' --always-on-top --bit-rate 2M --max-size 800
```

In WSL2, run with `cmd.exe /c [command]`.

## 📃 License

Licensed under the [MIT License](LICENSE).
