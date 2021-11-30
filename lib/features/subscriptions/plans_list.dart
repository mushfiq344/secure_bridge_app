import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/Models/Plan.dart';
import 'package:secure_bridges_app/Models/User.dart';
import 'package:secure_bridges_app/features/payment/payment_home.dart';
import 'package:secure_bridges_app/features/subscriptions/plans_view_model.dart';
import 'package:secure_bridges_app/features/user/user_view_model.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlansList extends StatefulWidget {
  final User currentUser;
  PlansList({this.currentUser});
  @override
  _PlansListState createState() => _PlansListState();
}

class _PlansListState extends State<PlansList> {
  PlansViewModel _plansViewModel = PlansViewModel();
  UserViewModel _userViewModel = UserViewModel();
  List<Plan> yearlyPlans = [];
  List<int> userSubscribedPlans = [];
  @override
  void initState() {
    getPlans();
    super.initState();
  }

  getPlans() {
    _plansViewModel.getPlans((Map<dynamic, dynamic> body) {
      print(body);
      List<Plan> _yearlyPlans = List<Plan>.from(
          body['data']['yearly_plans'].map((i) => Plan.fromJson(i)));
      List<int> _userSubscribedPlans =
          body['data']['user_subscribed_plans'].cast<int>();

      setState(() {
        yearlyPlans = _yearlyPlans;
        userSubscribedPlans = _userSubscribedPlans;
      });
    }, (error) {
      EasyLoading.showError(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subscriptions'),
        backgroundColor: kPurpleColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kMargin20),
          child: Column(
            children: [
              ...yearlyPlans.map((e) {
                return GestureDetector(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: kMargin20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Card(
                              color: userSubscribedPlans.contains(e.id)
                                  ? kPinkBackground
                                  : Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(kMargin10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(28),
                                child: Column(
                                  children: [
                                    Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(kMargin30),
                                        ),
                                        color: kLightYellow,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: kMargin10,
                                              horizontal: kMargin32),
                                          child: Text(
                                            kPlanModes[e.mode],
                                            style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: kMargin14),
                                          ),
                                        )),
                                    SizedBox(
                                      height: kMargin13,
                                    ),
                                    Text(
                                      e.title,
                                      style: TextStyle(
                                          fontSize: kMargin30,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: kMargin13,
                                    ),
                                    Text(
                                      e.description,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontSize: kMargin16,
                                          fontWeight: FontWeight.w400),
                                    ),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                  onTap: () {
                    if (userSubscribedPlans.contains(e.id)) {
                      EasyLoading.showInfo(
                          'You are already subscribed to this plan');
                      return;
                    }
                    String amount = (e.amount * 100).toString();
                    amount = amount.substring(0, amount.indexOf('.'));

                    Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => PaymentHome(
                                  amount: amount,
                                  userId: widget.currentUser.id,
                                  planId: e.id,
                                ))).then((value) {
                      if (value != null) {
                        if (value) {
                          EasyLoading.showSuccess(
                                  'You Have Subscribed To This Plan!')
                              .then((value) {
                            if (e.id == 2) {
                              _userViewModel.loadUserData(
                                  (Map<String, dynamic> userJson) async {
                                Map<String, dynamic> _userJson = userJson;

                                _userJson['has_create_opportunity_permission'] =
                                    true;
                                SharedPreferences localStorage =
                                    await SharedPreferences.getInstance();

                                localStorage.setString(
                                    'user', json.encode(_userJson));
                                if (e.id == 2) {
                                  Navigator.of(context).pop();
                                } else {
                                  getPlans();
                                }
                              }, (error) {
                                EasyLoading.showError(error);
                              });
                            }
                          });
                        }
                      }
                    });
                  },
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
