import 'dart:convert';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileViewModel {
  void getProfile(_success, _error) async {
    try {
      EasyLoading.show(status: kLoading);

      // EasyLoading.show(status: kLoading);
      var res = await Network().getData("${PROFILE_URL}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("bodyssss : ${body}");
      if (res.statusCode == 200) {
        _success(body['data']['profile']);
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        _error(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      _error(e.toString());
    }
  }

  createProfile(Map<String, dynamic> data, _success, _error) async {
    try {
      EasyLoading.show(status: kLoading);

      // EasyLoading.show(status: kLoading);
      var res = await Network().postData(data, "${PROFILE_URL}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("bodyssss : ${body}");
      if (res.statusCode == 201) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('user', json.encode(body['data']['user']));
        _success(body['message']);
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        _error(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      _error(e.toString());
    }
  }

  updateProfile(Map<String, dynamic> data, _success, _error) async {
    try {
      EasyLoading.show(status: kLoading);
      // print("data $data");
      // EasyLoading.show(status: kLoading);
      var res = await Network().putData(data, "${PROFILE_URL}/${data["id"]}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("bodyssss : ${body} ${res.statusCode}");
      if (res.statusCode == 200) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('user', json.encode(body['data']['user']));
        _success(body['message']);
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        _error(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      print(e);
      _error(e.toString());
    }
  }
}
