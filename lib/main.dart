import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/features/authentication/login.dart';
import 'package:secure_bridges_app/features/authentication/select_account_type.dart';
import 'package:secure_bridges_app/features/landing/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Test App',
      debugShowCheckedModeBanner: false,
      home: CheckAuth(),
      builder: EasyLoading.init(),
    );
  }
}

class CheckAuth extends StatefulWidget {
  @override
  _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
  bool isAuth = false;
  int regCompleted = 0;
  @override
  void initState() {
    configLoading();
    _checkIfLoggedIn();
    super.initState();
  }

  void configLoading() {
    EasyLoading.instance
      ..displayDuration = const Duration(milliseconds: 2000)
      ..indicatorType = EasyLoadingIndicatorType.fadingCircle
      ..maskType = EasyLoadingMaskType.black
      ..loadingStyle = EasyLoadingStyle.dark
      ..indicatorSize = 45.0
      ..radius = 10.0
      ..progressColor = Colors.yellow
      ..backgroundColor = Colors.green
      ..indicatorColor = Colors.yellow
      ..textColor = Colors.yellow
      ..maskColor = Colors.blue.withOpacity(0.5)
      ..userInteractions = false;
    //..customAnimation = CustomAnimation();
  }

  void _checkIfLoggedIn() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');

    if (token != null) {
      Map<String, dynamic> user = jsonDecode(localStorage.getString('user'));
      setState(() {
        regCompleted = user['reg_completed'];
        isAuth = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (isAuth) {
      if (regCompleted == 0) {
        child = SelectAccountType();
      } else {
        child = Home();
      }
      // child = SelectAccountType();
    } else {
      child = Login();
    }
    return Scaffold(
      body: child,
    );
  }
}
