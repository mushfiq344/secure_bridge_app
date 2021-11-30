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
import 'package:secure_bridges_app/features/subscriptions/plans_list.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/features/landing/home.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:secure_bridges_app/widgets/input_decoration.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class SelectAccountType extends StatefulWidget {
  @override
  _SelectAccountTypeState createState() => _SelectAccountTypeState();
}

class _SelectAccountTypeState extends State<SelectAccountType> {
  AuthenticationViewModel _authenticationViewModel = AuthenticationViewModel();

  var email;
  var password;
  String fcmToken;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool hidePassword = false;

  @override
  void initState() {
    /*push notification */

    super.initState();
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
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kMargin20),
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
                    "CREATE YOUR ACCOUNT",
                    style: TextStyle(
                        fontSize: kMargin24,
                        fontWeight: FontWeight.w700,
                        color: kPurpleColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kMargin32, vertical: kMargin18),
                  child: Text(
                    "I AM AN ORGANIZATION",
                    style: TextStyle(
                        fontSize: kMargin24,
                        fontWeight: FontWeight.w400,
                        color: kPurpleColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kMargin12),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    style: TextStyle(
                        fontSize: kMargin14,
                        fontWeight: FontWeight.normal,
                        color: kPurpleColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: kMargin20),
                    child: PAButton(
                      "Help Youth",
                      true,
                      () async {
                        _authenticationViewModel.completeRegistration(1,
                            () async {
                          await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PlansList(
                                      isRegistering: true,
                                    )),
                            (route) => false,
                          );
                        }, (error) {
                          EasyLoading.showError(error);
                        });
                      },
                      fillColor: kPurpleColor,
                      hMargin: 0,
                      capitalText: false,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kMargin32, vertical: kMargin18),
                  child: Text(
                    "I NEED HELP",
                    style: TextStyle(
                        fontSize: kMargin24,
                        fontWeight: FontWeight.w400,
                        color: kPurpleColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: kMargin12),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    style: TextStyle(
                        fontSize: kMargin14,
                        fontWeight: FontWeight.normal,
                        color: kPurpleColor),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: kMargin20),
                    child: PAButton(
                      "Get Help",
                      true,
                      () async {
                        _authenticationViewModel.completeRegistration(0,
                            () async {
                          await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Home()),
                            (route) => false,
                          );
                        }, (error) {
                          EasyLoading.showError(error);
                        });
                      },
                      fillColor: kPurpleColor,
                      hMargin: 0,
                      capitalText: false,
                    ),
                  ),
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: kMargin20),
                    child: PAButton(
                      "Logout",
                      true,
                      () async {
                        _authenticationViewModel.logout(() async {
                          await Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                            (route) => false,
                          );
                        }, () {});
                      },
                      fillColor: kPurpleColor,
                      hMargin: 0,
                      capitalText: false,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
