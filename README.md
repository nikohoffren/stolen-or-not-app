# StolenOrNot? (Flutter app)

## Description

This Flutter application is built to help people keep track of their valuable devices and protect them from theft. It allows users to register their devices, such as computers, cars, musical instruments, and more by entering a name and a unique serial number for each device. If a device gets stolen, users can mark it as such in the app. That way, if someone is selling the device in question, people will be able to check whether the device is already registered to someone in the app.

## Key Features

- **User Authentication:** Users can create accounts and log in using Firebase Authentication. This ensures the privacy and security of their registered devices.
- **Device Registration:** Users can register their devices by entering a name and a unique serial number or IMEI depending on device. The application stores these devices in a Firestore collection. Users cannot register a device if its serial number or IMEI has already been registered.
- **Stolen Devices:** If a device is stolen, users can mark it as such in the Firestore database. This can be useful for tracking purposes, and for alerting the user's friends or the community.

## Getting Started

To get started with the app, clone the repository and then follow these steps:

1. Make sure you have Flutter and Dart installed and set up. If not, follow the guide [here](https://flutter.dev/docs/get-started/install).
2. Run `flutter pub get` in the root of the project to install necessary dependencies.
3. Set up Firebase:
   - Visit the [Firebase Console](https://console.firebase.google.com/), create a new project and follow the setup guides for both Android and iOS.
   - Don't forget to replace the `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) with your own files.
4. Build and run the project:
   - For Android, you can use `flutter run` command or use your IDE run configuration.
   - For iOS, use `flutter run` or `CMD+R` in Xcode.

Please note that this application is a work in progress and more features are expected to be added in the future. Contributions are welcome.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update tests as appropriate.

## License

[MIT](https://choosealicense.com/licenses/mit/)
