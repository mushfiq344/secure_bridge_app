import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

Future<bool> shouldMakeApiCall(BuildContext context) async {
  bool isInternet = await Utils.checkInternetAvailability();
  if (!isInternet) {
    EasyLoading.dismiss();
    EasyLoading.showInfo("No Internet");
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
