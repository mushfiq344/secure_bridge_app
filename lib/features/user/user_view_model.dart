import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  loadUserData(_success, _error) async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      var user = jsonDecode(localStorage.getString('user'));
      print("user $user");
      if (user != null) {
        _success(user);
      } else {
        EasyLoading.dismiss();
        _error('Something went wrong!');
      }
    } catch (e) {
      EasyLoading.dismiss();
      _error(e.toString());
    }
  }
}
