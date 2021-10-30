import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:secure_bridges_app/screen/login.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/screen/opportunities.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name;
  String email;
  @override
  void initState() {
    _loadUserData();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    print("user $user");
    if (user != null) {
      setState(() {
        name = user['name'];
        email = user['email'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kAppName),
        backgroundColor: PURPLE_COLOR,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Hi, $name ($email)',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Center(
              child: RaisedButton(
                elevation: 10,
                onPressed: () {
                  logout();
                },
                color: PURPLE_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            Center(
              child: RaisedButton(
                elevation: 10,
                onPressed: () {
                  Navigator.push(
                      context,
                      new MaterialPageRoute(
                          builder: (context) => Opportunities()));
                },
                color: PURPLE_COLOR,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: Text(
                  kOpportunities,
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void logout() async {
    var res = await Network().postData({}, LOGOUT_URL);
    var body = json.decode(res.body);
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.remove('user');
    localStorage.remove('token');
    await Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => Login()),
      (route) => false,
    );
  }
}
