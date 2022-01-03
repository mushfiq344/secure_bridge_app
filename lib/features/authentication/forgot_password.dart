import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/features/authentication/authentication_view_model.dart';
import 'package:secure_bridges_app/features/authentication/register.dart';
import 'package:secure_bridges_app/network_utils/global_utility.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:secure_bridges_app/widgets/custom_alert_dialogue.dart';
import 'package:secure_bridges_app/widgets/input_decoration.dart';

import 'login.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  var email;
  AuthenticationViewModel _authenticationViewModel = AuthenticationViewModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kLightPurpleBackgroundColor,
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "Forgot your password?",
                style: TextStyle(
                    color: kPurpleColor,
                    fontSize: kMargin24,
                    fontWeight: FontWeight.w400),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: kMargin24),
                child: Image(image: AssetImage(kPadlockImagePath)),
              ),
              SizedBox(
                height: kMargin20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMargin20),
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
                                  "Enter your registered email below to receive password reset instruction",
                                  textAlign: TextAlign.center,
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
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: kMargin20),
                                  child: PAButton(
                                    "Send Reset Link",
                                    true,
                                    () async {
                                      bool callApi =
                                          await shouldMakeApiCall(context);
                                      if (!callApi) return;
                                      if (_formKey.currentState.validate()) {
                                        _authenticationViewModel
                                            .forgotPassword(email, (success) {
                                          EasyLoading.showSuccess(success);
                                        }, (error) {
                                          // EasyLoading.showError(error);
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  CustomAlertDialogue(
                                                      "Error!", error));
                                        });
                                      }
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
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: kMargin36,
              ),
              GestureDetector(
                child: Text(
                  "Remember password? Login",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
                onTap: () {
                  Navigator.push(context,
                      new MaterialPageRoute(builder: (context) => Login()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
