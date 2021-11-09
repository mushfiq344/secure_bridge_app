import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/features/authentication/authentication_view_model.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/features/landing/home.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:secure_bridges_app/screen/login.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  var email;
  var password;
  var name;
  var confirmPassword;
  AuthenticationViewModel _authenticationViewModel = AuthenticationViewModel();
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: kLightPurpleBackgroundColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Image(
                      height: 200,
                      image: AssetImage(kAddUserImagePath),
                    ),
                    Text(
                      "CREATE YOUR ACCOUNT",
                      style: TextStyle(
                          fontSize: kMargin24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            style: TextStyle(color: Color(0xFF000000)),
                            cursorColor: Color(0xFF9b9b9b),
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
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(color: Color(0xFF000000)),
                            cursorColor: Color(0xFF9b9b9b),
                            keyboardType: TextInputType.text,
                            decoration: _inputDecoration('Name',
                                showPrefixIcon: true,
                                prefixIconPath: kEmailIconPath),
                            validator: (nameValue) {
                              if (nameValue.isEmpty) {
                                return 'Please enter your first name';
                              }
                              name = nameValue;
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(color: Color(0xFF000000)),
                            cursorColor: Color(0xFF9b9b9b),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: _inputDecoration('Password',
                                showPrefixIcon: true,
                                prefixIconPath: kLockIconPath),
                            validator: (passwordValue) {
                              if (passwordValue.isEmpty) {
                                return 'Please enter some text';
                              }
                              password = passwordValue;
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            style: TextStyle(color: Color(0xFF000000)),
                            cursorColor: Color(0xFF9b9b9b),
                            keyboardType: TextInputType.text,
                            obscureText: true,
                            decoration: _inputDecoration(
                              'Confirm Password',
                              showPrefixIcon: true,
                              prefixIconPath: kLockIconPath,
                            ),
                            validator: (confirmPasswordValue) {
                              if (confirmPasswordValue.isEmpty) {
                                return 'Please enter some text';
                              }
                              confirmPassword = confirmPasswordValue;
                              return null;
                            },
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          PAButton(
                            "Create Account",
                            true,
                            () {
                              if (_formKey.currentState.validate()) {
                                _register();
                              }
                            },
                            fillColor: kPurpleColor,
                            hMargin: 0,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 1, child: Divider(color: Colors.black)),
                  Expanded(
                      flex: 1,
                      child: Text(
                        "Or Sign In with",
                        textAlign: TextAlign.center,
                      )),
                  Expanded(flex: 1, child: Divider(color: Colors.black))
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kMargin10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(kMargin12)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Image(
                                  height: 40,
                                  width: 40,
                                  image: AssetImage(kGoogleIconPath),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text("Google",
                                    style: TextStyle(
                                        fontSize: kMargin14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          _authenticationViewModel.handleGoogleSignIn(() async {
                            await Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                              (route) => false,
                            );
                          }, (error) {
                            EasyLoading.showError(error);
                          });
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(kMargin12)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Image(
                                  height: 40,
                                  width: 40,
                                  image: AssetImage(kFacebookIconPath),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text("Facebook",
                                    style: TextStyle(
                                        fontSize: kMargin14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          EasyLoading.showToast(kComingSoon);
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(kMargin12)),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Image(
                                  height: 40,
                                  width: 40,
                                  image: AssetImage(kAppleIconPath),
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text("Apple",
                                    style: TextStyle(
                                        fontSize: kMargin14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          EasyLoading.showToast(kComingSoon);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        new MaterialPageRoute(builder: (context) => Login()));
                  },
                  child: Text(
                    'Already have an account? Sign In',
                    style: TextStyle(
                      color: kPurpleColor,
                      fontSize: kMargin14,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w400,
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

  void _register() async {
    try {
      EasyLoading.show(status: kLoading);
      setState(() {
        _isLoading = true;
      });
      var data = {
        'email': email,
        'password': password,
        'c_password': confirmPassword,
        'name': name,
      };
      print("data $data");

      var res = await Network().authData(data, REGISTER_URL);
      var body = json.decode(res.body);

      if (res.statusCode == 201) {
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
        EasyLoading.showError(body["message"]);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }

  InputDecoration _inputDecoration(String hintText,
      {bool showPrefixIcon = false,
      showSuffixIcon = false,
      String prefixIconPath,
      String suffixIconPath}) {
    return InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: kBorderColor),
        fillColor: Colors.white,
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
}
