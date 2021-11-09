import 'dart:convert';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationViewModel {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  void googleAuth(String token, _success, _error) async {
    try {
      EasyLoading.show(status: kLoading);
      var data = {"google_token": token};
      // EasyLoading.show(status: kLoading);
      var res = await Network().postData(data, GOOGLE_AUTH_URL);
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : ${body}");
      if (res.statusCode == 200) {
        print("get token : ${body['data']['token']}");
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', body['data']['token']);
        localStorage.setString('user', json.encode(body['data']['user']));
        EasyLoading.dismiss();
        _success();
      } else {
        EasyLoading.dismiss();
        _error(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _error(e.toString());
    }
  }

  Future<void> handleGoogleSignIn(_success, _error) async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        _error('Google Signin ERROR! googleAccount: null!');
        return null;
      }
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      //this is user access token from google that is retrieved with the plugin
      print("User Access Token: ${googleSignInAuthentication.accessToken}");
      String accessToken = googleSignInAuthentication.accessToken;
      googleAuth(accessToken, _success, _error);
    } catch (error) {
      EasyLoading.dismiss();
      _error(error.toString());
    }
  }
}
