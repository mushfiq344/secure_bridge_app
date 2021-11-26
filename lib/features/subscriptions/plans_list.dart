import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';

class PlansList extends StatefulWidget {
  @override
  _PlansListState createState() => _PlansListState();
}

class _PlansListState extends State<PlansList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscriptions'),
        backgroundColor: kPurpleColor,
      ),
    );
  }
}
