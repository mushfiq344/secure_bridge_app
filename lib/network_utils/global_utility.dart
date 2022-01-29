import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/widgets/custom_alert_dialogue.dart';

Future<bool> shouldMakeApiCall(BuildContext context) async {
  bool isInternet = await Utils.checkInternetAvailability();
  if (!isInternet) {
    EasyLoading.dismiss();
    // EasyLoading.showInfo("No Internet");
    showDialog(
        context: context,
        builder: (_) => CustomAlertDialogue(
            'No Inernet', 'Please check your internet connection'));
  }
  return isInternet;
}

class Utils {
  static Future<bool> checkInternetAvailability() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        // print('internet connection available');
        return true;
      }
    } on SocketException catch (_) {
      // print('internet connection not available');
      return false;
    }
    return false;
  }
}
