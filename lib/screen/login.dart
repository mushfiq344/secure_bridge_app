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
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:secure_bridges_app/screen/register.dart';
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
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        color: kPurpleColor,
        child: Stack(
          children: <Widget>[
            Positioned(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Card(
                      elevation: 4.0,
                      color: Colors.white,
                      margin: EdgeInsets.only(left: 20, right: 20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Image(
                              height: 200,
                              image: AssetImage(kAppLogoPath),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(
                              initialValue:
                                        'user@itsolutionstuff.com',
                                    style: TextStyle(color: Color(0xFF000000)),
                                    cursorColor: Color(0xFF9b9b9b),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Colors.grey,
                                      ),
                                      hintText: "Email",
                                      hintStyle: TextStyle(
                                          color: Color(0xFF9b9b9b),
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    validator: (emailValue) {
                                      if (emailValue.isEmpty) {
                                        return 'Please enter email';
                                      }
                                      email = emailValue;
                                      return null;
                                    },
                                  ),
                                  TextFormField(
                                  initialValue: '123456',
                                    style: TextStyle(color: Color(0xFF000000)),
                                    cursorColor: Color(0xFF9b9b9b),
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.vpn_key,
                                        color: Colors.grey,
                                      ),
                                      hintText: "Password",
                                      hintStyle: TextStyle(
                                          color: Color(0xFF9b9b9b),
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    validator: (passwordValue) {
                                      if (passwordValue.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      password = passwordValue;
                                      return null;
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: FlatButton(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: 8,
                                            bottom: 8,
                                            left: 10,
                                            right: 10),
                                        child: Text(
                                          'Login',
                                          textDirection: TextDirection.ltr,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15.0,
                                            decoration: TextDecoration.none,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ),
                                      color: kPurpleColor,
                                      disabledColor: Colors.grey,
                                      shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(20.0)),
                                      onPressed: () {
                                        if (_formKey.currentState.validate()) {
                                          _login();

                                        }
                                      },
                                    ),
                                  ),
                                  SignInButton(
                                    Buttons.Google,
                                    text: "Sign up with Google",
                                    onPressed: () {
                                      _handleSignIn();
                                    },
                                  )

                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => Register()));
                        },
                        child: Text(
                          'Create new Account',
                          style: TextStyle(
                            color: Colors.white,
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
            )
          ],
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

  void googleAuth(String token)async{
    try {
      EasyLoading.show(status: kLoading);
      var data={
        "google_token":token
      };
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
