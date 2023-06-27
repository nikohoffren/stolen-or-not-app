import 'package:flutter/material.dart';

class Info extends StatelessWidget {
  const Info({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Text(
      '''
      Welcome to StolenOrNot!

      This app is designed to help you with checking the status of your devices and connecting with the owners if they are reported stolen. Here's a brief overview of the different pages and their functionalities:

      - Register Device:
        On this page, you can register your devices by providing their IMEI or Serial Number. This helps you keep track of your devices and easily check their status later.

      - Check Device:
        Use this page to check if a device you found somewhere or encountered for sale is reported stolen. Enter the IMEI or Serial Number of the device, and the app will provide you with its status. If the device is reported stolen, you can send a message to the owner through the app.

      - Settings:
        In the Settings page, you can view all the devices you have registered. You can mark a device as stolen or unstolen, update its information, or even delete a device from your list.

      We hope this app provides you with valuable information and helps prevent the circulation of stolen devices. If you have any questions or need assistance, feel free to reach out to our support team.

      Thank you for using StolenOrNot!
      ''',
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
    );
  }
}
