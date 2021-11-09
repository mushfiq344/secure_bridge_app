import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/features/landing/home.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:secure_bridges_app/features/authentication/register.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool showPassword = false;
  _showMsg(msg) {
    final snackBar = SnackBar(
      content: Text(msg),
      action: SnackBarAction(
        label: 'Close',
        onPressed: () {
          // Some code to undo the change!
        },
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  InputDecoration _inputDecoration(String hintText,
      {bool showPrefixIcon = false,
      showSuffixIcon = false,
      String prefixIconPath,
      String suffixIconPath}) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: kBorderColor),
        fillColor: kLightPurpleBackgroundColor,
        filled: true,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadius10),
          borderSide: BorderSide(
            color: kPurpleColor,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadius10),
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 1.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadius10),
          borderSide: BorderSide(
            color: kBorderColor,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadius10),
          borderSide: BorderSide(
            color: kBorderColor,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(kRadius10),
          borderSide: BorderSide(
            color: kBorderColor,
            width: 1.0,
          ),
        ),
        prefixIcon: showPrefixIcon ? Image.asset(prefixIconPath) : null,
        suffixIcon: showSuffixIcon
            ? GestureDetector(
                child: Image.asset(suffixIconPath),
                onTap: () {
                  setState(() {
                    showPassword = !showPassword;
                  });
                },
              )
            : null);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            stops: [0.3, 0.5, 0.7, .9],
            colors: [
              Color(0xFFDDDCFE),
              Color(0xFFF7F6FF),
              Color(0xFFFFFFFF),
              Color(0xFFDDDCFE),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(kImageBackgroundPath),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Image(
                  height: 200,
                  image: AssetImage(kHelpingHandImagePath),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kMargin32, vertical: kMargin18),
                child: Text(
                  "WELCOME TO SECURE BRIDGES",
                  style: TextStyle(
                      fontSize: kMargin32, fontWeight: FontWeight.w400),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMargin20),
                child: Column(
                  children: [
                    GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kMargin12)),
                        child: ListTile(
                          leading: Image(
                            image: AssetImage(kGoogleIconPath),
                          ),
                          title: Text("Continue With Google",
                              style: TextStyle(
                                  fontSize: kMargin14,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      onTap: () {
                        _handleSignIn();
                      },
                    ),
                    SizedBox(
                      height: kMargin4,
                    ),
                    GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kMargin12)),
                        child: ListTile(
                          leading: Image(
                            image: AssetImage(kFacebookIconPath),
                          ),
                          title: Text("Continue With Facebook",
                              style: TextStyle(
                                  fontSize: kMargin14,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      onTap: () {
                        EasyLoading.showToast(kComingSoon);
                      },
                    ),
                    SizedBox(
                      height: kMargin4,
                    ),
                    GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(kMargin12)),
                        child: ListTile(
                          leading: Image(
                            image: AssetImage(kAppleIconPath),
                          ),
                          title: Text("Continue With Apple ID",
                              style: TextStyle(
                                  fontSize: kMargin14,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ),
                      onTap: () {
                        EasyLoading.showToast(kComingSoon);
                      },
                    ),
                  ],
                ),
              ),
              Card(
                elevation: 4.0,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: kMargin20),
                  child: Column(
                    children: [
                      Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: kMargin12),
                              child: Text(
                                "Log In with email",
                                style: TextStyle(
                                    fontSize: kMargin14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            TextFormField(
                              initialValue: 'user@itsolutionstuff.com',
                              style: TextStyle(color: kPurpleColor),
                              cursorColor: kPurpleColor,
                              keyboardType: TextInputType.text,
                              decoration: _inputDecoration('Email',
                                  showPrefixIcon: true,
                                  prefixIconPath: kEmailIconPath),
                              validator: (emailValue) {
                                if (emailValue.isEmpty) {
                                  return 'Please enter email';
                                }
                                email = emailValue;
                                return null;
                              },
                            ),
                            SizedBox(
                              height: kMargin10,
                            ),
                            TextFormField(
                              initialValue: '123456',
                              style: TextStyle(color: kPurpleColor),
                              cursorColor: kPurpleColor,
                              keyboardType: TextInputType.text,
                              obscureText: showPassword ? false : true,
                              decoration: _inputDecoration('Password',
                                  showPrefixIcon: true,
                                  prefixIconPath: kLockIconPath,
                                  showSuffixIcon: true,
                                  suffixIconPath: kTextShowIconPath),
                              validator: (passwordValue) {
                                if (passwordValue.isEmpty) {
                                  return 'Please enter some text';
                                }
                                password = passwordValue;
                                return null;
                              },
                            ),
                            Container(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: kMargin20),
                                child: PAButton(
                                  "Login",
                                  true,
                                  () {
                                    if (_formKey.currentState.validate()) {
                                      _login();
                                    }
                                  },
                                  fillColor: kPurpleColor,
                                  hMargin: 0,
                                ),
                              ),
                            ),
                            GestureDetector(
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                              onTap: () {
                                EasyLoading.showToast(kComingSoon);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: kMargin28, top: 6),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) => Register()));
                                },
                                child: Text(
                                  'Don’t have an account? Sign up',
                                  style: TextStyle(
                                    color: kPurpleColor,
                                    fontSize: 15.0,
                                    decoration: TextDecoration.none,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleSignIn() async {
    try {
      GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
      if (googleSignInAccount == null) {
        print('Google Signin ERROR! googleAccount: null!');
        return null;
      }
      GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      //this is user access token from google that is retrieved with the plugin
      print("User Access Token: ${googleSignInAuthentication.accessToken}");
      String accessToken = googleSignInAuthentication.accessToken;
      googleAuth(accessToken);
    } catch (error) {
      EasyLoading.showError(error);
    }
  }

  void _login() async {
    try {
      setState(() {
        _isLoading = true;
      });
      var data = {'email': email, 'password': password};
      EasyLoading.show(status: kLoading);
      var res = await Network().authData(data, SIGN_IN_URL);
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : ${body['data']['user']}");
      if (res.statusCode == 200) {
        print("get token : ${body['data']['token']}");
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', body['data']['token']);
        localStorage.setString('user', json.encode(body['data']['user']));
        EasyLoading.dismiss();
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
          (route) => false,
        );
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(body['message']);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }

  void googleAuth(String token) async {
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
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Home()),
          (route) => false,
        );
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }
}
