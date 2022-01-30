import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:secure_bridges_app/Models/Plan.dart';
import 'package:secure_bridges_app/Models/User.dart';
import 'package:secure_bridges_app/features/authentication/authentication_view_model.dart';
import 'package:secure_bridges_app/features/authentication/login.dart';
import 'package:secure_bridges_app/features/landing/landing_search_page.dart';
import 'package:secure_bridges_app/features/org_admin/org_admin_home.dart';
import 'package:secure_bridges_app/features/payment/payment_home.dart';
import 'package:secure_bridges_app/features/subscriptions/plans_view_model.dart';
import 'package:secure_bridges_app/features/user/user_view_model.dart';
import 'package:secure_bridges_app/network_utils/global_utility.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:secure_bridges_app/widgets/custom_alert_dialogue.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PlansList extends StatefulWidget {
  final User currentUser;
  bool isRegistering;
  PlansList({this.currentUser, this.isRegistering = false});
  @override
  _PlansListState createState() => _PlansListState();
}

class _PlansListState extends State<PlansList> {
  PlansViewModel _plansViewModel = PlansViewModel();
  UserViewModel _userViewModel = UserViewModel();
  AuthenticationViewModel _authenticationViewModel = AuthenticationViewModel();
  List<Plan> yearlyPlans = [];
  List<Plan> monthlyPlans = [];
  List<int> userSubscribedPlans = [];
  User currentUser;
  bool isYear = true;
  @override
  void initState() {
    getPlans();
    loadUsersData();
    super.initState();
  }

  loadUsersData() {
    _userViewModel.loadUserData((var user) {
      setState(() {
        currentUser = User.fromJson(user);
      });
    }, (error) {
      showDialog(
          context: context,
          builder: (_) => CustomAlertDialogue("Error!", error));
      // EasyLoading.showError(error);
    });
  }

  getPlans() {
    _plansViewModel.getPlans((Map<dynamic, dynamic> body) {
      print(body);
      List<Plan> _yearlyPlans = List<Plan>.from(
          body['data']['yearly_plans'].map((i) => Plan.fromJson(i)));
      List<Plan> _monthyPlans = List<Plan>.from(
          body['data']['monthly_plans'].map((i) => Plan.fromJson(i)));
      List<int> _userSubscribedPlans =
          body['data']['user_subscribed_plans'].cast<int>();

      setState(() {
        yearlyPlans = _yearlyPlans;
        monthlyPlans = _monthyPlans;
        userSubscribedPlans = _userSubscribedPlans;
      });
    }, (error) {
      // EasyLoading.showError(error);
      showDialog(
          context: context,
          builder: (_) => CustomAlertDialogue("Error!", error));
    });
  }

  void toggleSwitch(bool value) {
    if (isYear == false) {
      setState(() {
        isYear = true;
      });
      print('Switch Button is ON');
    } else {
      setState(() {
        isYear = false;
      });
      print('Switch Button is OFF');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subscriptions',
          style: TextStyle(color: kPurpleColor),
        ),
        backgroundColor: kAppBarBackgroundColor,
        iconTheme: IconThemeData(color: kPurpleColor),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(kMargin20),
          child: Column(
            children: [
              Text(
                "Choose plan",
                style:
                    TextStyle(fontWeight: FontWeight.bold, fontSize: kMargin30),
              ),
              SizedBox(
                height: kMargin30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Monthly",
                    style: TextStyle(
                        fontSize: kMargin16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black38),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kMargin10),
                    child: FlutterSwitch(
                      width: 70.0,
                      height: 40.0,
                      toggleSize: 30.0,
                      value: isYear,
                      borderRadius: 33.1,
                      padding: 4.0,
                      toggleColor: Color.fromRGBO(225, 225, 225, 1),
                      activeColor: kLightBlack,
                      inactiveColor: Colors.black38,
                      onToggle: (val) {
                        setState(() {
                          isYear = val;
                        });
                      },
                    ),
                  ),
                  Text(
                    "Yearly",
                    style: TextStyle(
                        fontSize: kMargin16,
                        fontWeight: FontWeight.bold,
                        color: kLightBlack),
                  ),
                ],
              ),
              SizedBox(
                height: kMargin30,
              ),
              isYear
                  ? buildList(context, yearlyPlans)
                  : buildList(context, monthlyPlans),
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
    );
  }

  Widget buildList(BuildContext context, List<Plan> plans) {
    return Column(
      children: [
        ...plans.map((e) {
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
            onTap: () async {
              if (userSubscribedPlans.contains(e.id)) {
                EasyLoading.dismiss();
                // EasyLoading.showInfo('You are already subscribed to this plan');
                showDialog(
                    context: context,
                    builder: (_) =>
                        CustomAlertDialogue("Error!", kSubscriptionExists));
                return;
              }
              String amount = (e.amount * 100).toString();
              amount = amount.substring(0, amount.indexOf('.'));
              if (e.mode == 0 || e.amount == 0) {
                bool callApi = await shouldMakeApiCall(context);
                if (!callApi) return;
                _authenticationViewModel.completeRegistration(1, () async {
                  await Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => OrgAdminHome()),
                    (route) => false,
                  );
                }, (error) {
                  // EasyLoading.showError(error);
                  showDialog(
                      context: context,
                      builder: (_) => CustomAlertDialogue("Error!", error));
                });
              } else {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => PaymentHome(
                              amount: amount,
                              userId: currentUser.id,
                              planId: e.id,
                            ))).then((value) {
                  if (value != null) {
                    if (value) {
                      showDialog(
                              context: context,
                              builder: (_) => CustomAlertDialogue("Success!",
                                  'You Have Subscribed To This Plan!'))
                          .then((value) {
                        if (widget.isRegistering) {
                          _authenticationViewModel.completeRegistration(1,
                              () async {
                            await Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrgAdminHome()),
                              (route) => false,
                            );
                          }, (error) {
                            showDialog(
                                context: context,
                                builder: (_) =>
                                    CustomAlertDialogue("Error!", error));
                            /* EasyLoading.showError(error);*/
                          });
                        } else {
                          _userViewModel.loadUserData(
                              (Map<String, dynamic> userJson) async {
                            Map<String, dynamic> _userJson = userJson;
                            _userJson['has_create_opportunity_permission'] =
                                true;
                            SharedPreferences localStorage =
                                await SharedPreferences.getInstance();
                            localStorage.setString(
                                'user', json.encode(_userJson));
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrgAdminHome()),
                              (route) => false,
                            );
                          }, (error) {
                            showDialog(
                                context: context,
                                builder: (_) =>
                                    CustomAlertDialogue("Error!", error));
                            // EasyLoading.showError(error);
                          });
                        }
                      });
                    }
                  }
                });
              }
            },
          );
        })
      ],
    );
  }
}
