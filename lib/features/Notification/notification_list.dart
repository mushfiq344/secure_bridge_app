import 'package:flutter/material.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notifications"),
        backgroundColor: kPurpleColor,
      ),
    );
  }
}
