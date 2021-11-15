import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/constants.dart';

class UserViewModel {
  getOpportunities(_success, _error) async {
    try {
      EasyLoading.show(status: kLoading);
      var res = await Network().getData(USER_ADMIN_OPPORTUNITIES_URL);
      var body = json.decode(res.body);
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        _success(body);
      } else {
        EasyLoading.dismiss();
        _error(body["message"]);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _error(e.toString());
    }
  }
}
