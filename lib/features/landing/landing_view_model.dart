import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LandingViewModel{

  void logout(_success,_error) async {
    try {
      EasyLoading.show(status: kLoading);
      var res = await Network().postData({}, LOGOUT_URL);
      var body = json.decode(res.body);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      EasyLoading.dismiss();
      _success();
    } catch (e) {
      EasyLoading.dismiss();
      _success();
    }
  }

}