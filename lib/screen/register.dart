import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/screen/home.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
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

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
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
                                    style: TextStyle(color: Color(0xFF000000)),
                                    cursorColor: Color(0xFF9b9b9b),
                                    keyboardType: TextInputType.text,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.insert_emoticon,
                                        color: Colors.grey,
                                      ),
                                      hintText: "Name",
                                      hintStyle: TextStyle(
                                          color: Color(0xFF9b9b9b),
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    validator: (nameValue) {
                                      if (nameValue.isEmpty) {
                                        return 'Please enter your first name';
                                      }
                                      name = nameValue;
                                      return null;
                                    },
                                  ),
                                  TextFormField(
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
                                  TextFormField(
                                    style: TextStyle(color: Color(0xFF000000)),
                                    cursorColor: Color(0xFF9b9b9b),
                                    keyboardType: TextInputType.text,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.vpn_key,
                                        color: Colors.grey,
                                      ),
                                      hintText: "Confirm Password",
                                      hintStyle: TextStyle(
                                          color: Color(0xFF9b9b9b),
                                          fontSize: 15,
                                          fontWeight: FontWeight.normal),
                                    ),
                                    validator: (confirmPasswordValue) {
                                      if (confirmPasswordValue.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      confirmPassword = confirmPasswordValue;
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
                                          'Register',
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
                                          _register();
                                        }
                                      },
                                    ),
                                  ),
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
                                  builder: (context) => Login()));
                        },
                        child: Text(
                          'Already Have an Account',
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
}
