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

  void logout(_success, _error) async {
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

  Future<void> forgotPassword(String email, _success, _error) async {
    try {
      var data = {'email': email};
      EasyLoading.show(status: kLoading);
      var res = await Network().postData(data, FORGOT_PASSWORD_URL);
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        _success(body['message']);
      } else {
        EasyLoading.dismiss();
        _error(body['message']);
      }
    } catch (error) {
      EasyLoading.dismiss();
      _error(error.toString());
    }
  }

  void completeRegistration(int SelectedType, _success, _error) async {
    try {
      var data = {
        'selected_type': SelectedType,
      };
      EasyLoading.show(status: kLoading);
      var res = await Network().postData(data, COMPLETE_REGISTRATION_URL);
      var body = json.decode(res.body);
      log("res ${res.body}");

      if (res.statusCode == 200) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('user', json.encode(body['data']['user']));
        EasyLoading.dismiss();
        _success();
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

  void login(String email, String password, _success, _error) async {
    try {
      var data = {'email': email, 'password': password};
      EasyLoading.show(status: kLoading);
      var res = await Network().authData(data, SIGN_IN_URL);
      var body = json.decode(res.body);
      log("res ${res.statusCode}");
      log("body : ${body['data']['user']}");
      if (res.statusCode == 200) {
        print("get token : ${body['data']['token']}");
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', body['data']['token']);
        localStorage.setString('user', json.encode(body['data']['user']));
        EasyLoading.dismiss();
        int regCompleted = body['data']['user']['reg_completed'];
        print("regCompleted $regCompleted");
        _success(regCompleted, body);
      } else {
        EasyLoading.dismiss();
        _error(body['message']);
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      _error(kSomethingWentWrong);
    }
  }
}
