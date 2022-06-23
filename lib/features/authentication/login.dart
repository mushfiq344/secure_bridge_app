import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:secure_bridges_app/features/authentication/authentication_view_model.dart';
import 'package:secure_bridges_app/features/authentication/forgot_password.dart';
import 'package:secure_bridges_app/features/authentication/register.dart';
import 'package:secure_bridges_app/features/authentication/select_account_type.dart';
import 'package:secure_bridges_app/features/org_admin/org_admin_home.dart';
import 'package:secure_bridges_app/features/subscriptions/plans_list.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/features/landing/landing_search_page.dart';
import 'package:secure_bridges_app/network_utils/global_utility.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:secure_bridges_app/widgets/custom_alert_dialogue.dart';
import 'package:secure_bridges_app/widgets/input_decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  AuthenticationViewModel _authenticationViewModel = AuthenticationViewModel();
  GoogleSignInAccount _userObj;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;
  String fcmToken;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool hidePassword = false;
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

  @override
  void initState() {
    /*push notification */
    getFirebaseToken();
    super.initState();
  }

  void getFirebaseToken() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print("fcm token: $token");
      setState(() {
        fcmToken = token;
      });
    });
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
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
              SizedBox(
                height: kMargin36,
              ),
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
                      onTap: () async {
                        bool callApi = await shouldMakeApiCall(context);
                        if (!callApi) return;
                        _authenticationViewModel.handleGoogleSignIn(() async {
                          SharedPreferences localStorage =
                              await SharedPreferences.getInstance();
                          var user = jsonDecode(localStorage.getString('user'));
                          print("user here $user");
                          int regCompleted = user['reg_completed'];
                          int userType = user['user_type'];

                          print(
                              "regCompleted $regCompleted, userType $userType");
                          if (regCompleted < 2) {
                            if (regCompleted < 1) {
                              await Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SelectAccountType()),
                                (route) => false,
                              );
                            } else {
                              if (userType == 1) {
                                await Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => PlansList(
                                            isRegistering: true,
                                          )),
                                  (route) => false,
                                );
                              } else {
                                await Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          LandingSearchPage()),
                                  (route) => false,
                                );
                              }
                            }
                          } else {
                            await Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrgAdminHome()),
                              (route) => false,
                            );
                          }
                        }, (error) {
                          EasyLoading.dismiss();
                          // EasyLoading.showError(error);
                          showDialog(
                              context: context,
                              builder: (_) =>
                                  CustomAlertDialogue("Login Failed!", error));
                        });
                      },
                    ),
                    // SizedBox(
                    //   height: kMargin4,
                    // ),
                    // GestureDetector(
                    //   child: Card(
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(kMargin12)),
                    //     child: ListTile(
                    //       leading: Image(
                    //         image: AssetImage(kFacebookIconPath),
                    //       ),
                    //       title: Text("Continue With Facebook",
                    //           style: TextStyle(
                    //               fontSize: kMargin14,
                    //               fontWeight: FontWeight.bold)),
                    //     ),
                    //   ),
                    //   onTap: () {
                    //     EasyLoading.showToast(kComingSoon);
                    //   },
                    // ),
                    // SizedBox(
                    //   height: kMargin4,
                    // ),
                    // GestureDetector(
                    //   child: Card(
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(kMargin12)),
                    //     child: ListTile(
                    //       leading: Image(
                    //         image: AssetImage(kAppleIconPath),
                    //       ),
                    //       title: Text("Continue With Apple ID",
                    //           style: TextStyle(
                    //               fontSize: kMargin14,
                    //               fontWeight: FontWeight.bold)),
                    //     ),
                    //   ),
                    //   onTap: () {
                    //     EasyLoading.showToast(kComingSoon);
                    //   },
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Card(
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
                                style: TextStyle(color: kPurpleColor),
                                cursorColor: kPurpleColor,
                                keyboardType: TextInputType.text,
                                decoration: customInputDecoration('Email',
                                    fillColor: kLightPurpleBackgroundColor,
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
                                style: TextStyle(color: kPurpleColor),
                                cursorColor: kPurpleColor,
                                keyboardType: TextInputType.text,
                                obscureText: hidePassword,
                                decoration: customInputDecoration('Password',
                                    fillColor: kLightPurpleBackgroundColor,
                                    showPrefixIcon: true,
                                    prefixIconPath: kLockIconPath,
                                    showSuffixIcon: true,
                                    suffixIconPath: kTextShowIconPath,
                                    hasSuffixIconCallback: true,
                                    suffixIconCallback: () {
                                  setState(() {
                                    hidePassword = !hidePassword;
                                  });
                                }),
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
                                    () async {
                                      bool callApi =
                                          await shouldMakeApiCall(context);
                                      if (!callApi) return;
                                      _formKey.currentState.save();
                                      if (_formKey.currentState.validate()) {
                                        _authenticationViewModel.login(
                                            email, password, (int regCompleted,
                                                Map<String, dynamic>
                                                    body) async {
                                          int userType =
                                              body['data']['user']['user_type'];
                                          if (regCompleted < 2) {
                                            if (regCompleted < 1) {
                                              await Navigator
                                                  .pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        SelectAccountType()),
                                                (route) => false,
                                              );
                                            } else {
                                              if (userType == 1) {
                                                await Navigator
                                                    .pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          PlansList(
                                                            isRegistering: true,
                                                          )),
                                                  (route) => false,
                                                );
                                              } else {
                                                await Navigator
                                                    .pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LandingSearchPage()),
                                                  (route) => false,
                                                );
                                              }
                                            }
                                          } else {
                                            await Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrgAdminHome()),
                                              (route) => false,
                                            );
                                          }
                                        }, (error) {
                                          EasyLoading.dismiss();
                                          // EasyLoading.showError(error);
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  CustomAlertDialogue(
                                                      "Login Failed!", error));
                                          ;
                                        });
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
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              ForgotPassword()));
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
