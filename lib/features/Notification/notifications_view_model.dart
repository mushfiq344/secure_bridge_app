import 'dart:convert';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/constants.dart';

class NotificationsViewModel {
  void getNotifications(_onSuccess, _onError) async {
    try {
      EasyLoading.show(status: kLoading);

      // EasyLoading.show(status: kLoading);
      var res = await Network().getData("${NOTIFICATIONS_URL}");
      var body = json.decode(res.body);

      log("notifications : ${body}");
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        _onSuccess(body);
      } else {
        EasyLoading.dismiss();
        _onError(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _onError(e.toString());
    }
  }
}
