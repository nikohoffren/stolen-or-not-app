# StolenOrNot? (Flutter app)

[![LICENSE](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
![GitHub version](https://badge.fury.io/gh/nikohoffren%2Fstolen-or-not-app.svg)

<img src="https://github.com/nikohoffren/stolen-or-not-app/blob/main/assets/images/stolen-gear-logo.jpeg?raw=true" alt="StolenOrNot?" width="300">

[Download in Google Play Store](https://play.google.com/store/apps/details?id=com.nikohoffren.stolen_gear_app)

## Table of Contents

-   [Technologies Used](#technologies-used)
-   [Description](#description)
-   [Key Features](#key-features)
-   [Contributing](#contributing)
-   [Questions](#questions)
-   [License](#license)

## Technologies Used

- [Flutter](https://flutter.dev/)
- [Firebase ](https://firebase.google.com/)
- [Google Sign-In](https://developers.google.com/identity/)

## Description

This Flutter application is built to help people keep track of their valuable devices and protect them from theft. It allows users to register their devices, such as computers, cars, musical instruments, and more by entering a name and a unique serial number for each device. If a device gets stolen, users can mark it as such in the app. That way, if someone is selling the device in question, people will be able to check whether the device is already registered to someone in the app.

## Key Features

- **User Authentication:** Users can create accounts and log in using Firebase Authentication. This ensures the privacy and security of their registered devices.
- **Device Registration:** Users can register their devices by entering a name and a unique serial number or IMEI depending on device. The application stores these devices in a Firestore collection. Users cannot register a device if its serial number or IMEI has already been registered.
- **Stolen Devices:** If a device is stolen, users can mark it as such in the Firestore database. This can be useful for tracking purposes, and for alerting the user's friends or the community.

## Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Clone the repository to your local machine `git clone https://github.com/nikohoffren/stolen-or-not-app.git`
3. Change directory to the project directory `cd stolen-or-not-app`
4. Run `flutter pub get` in the root of the project to install necessary dependencies.
5. Build and run the project:
   - For Android, you can use `flutter run` command or use your IDE run configuration.
6. When the app is running on your emulator, you can use testing credentials to log in with email and password:
   - Email: stolen-or-not-test@gmail.com
   - Password: 123456
7. Create your Feature Branch `git switch -c feature` (Replace the feature placeholder with your new feature)
8. Make your changes in code
9 Add your changes `git add name-of-the-changed-file`
10. Commit your Changes `git commit -m 'Add new feature'`
11. Push to the Branch `git push -u origin feature`
12. Open a Pull Request

Please note that global installation may require administrator permissions on your system. If you face any permission issues, you can use a package manager like yarn or use a version manager like nvm for node.js. Also remember to replace `name-of-the-changed-file` and `feature` with your specific file names and feature names.

For major changes, please open an issue first to discuss what you would like to change. Please make sure to update tests as appropriate.

Also, please read our [Contributing Guidelines](CONTRIBUTING.md) for more information.

## Questions

If you have any questions about the repo, open an issue or contact me directly at niko.hoffren@gmail.com.

## License

[MIT](https://choosealicense.com/licenses/mit/)
