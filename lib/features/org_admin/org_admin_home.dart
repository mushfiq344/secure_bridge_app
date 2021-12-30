import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/Models/bar_chart_model.dart';
import 'package:secure_bridges_app/features/Notification/notification_list.dart';
import 'package:secure_bridges_app/features/enrollment/opportunity_happening.dart';
import 'package:secure_bridges_app/features/landing/drawer_menu.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_detail.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_view_model.dart';
import 'package:secure_bridges_app/features/org_admin/bar_chart_graph.dart';
import 'package:secure_bridges_app/features/org_admin/org_admin_view_model.dart';
import 'package:secure_bridges_app/features/user/user_view_model.dart';
import 'package:secure_bridges_app/network_utils/global_utility.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/Models/User.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class OrgAdminHome extends StatefulWidget {
  @override
  _OrgAdminHomeState createState() => _OrgAdminHomeState();
}

class _OrgAdminHomeState extends State<OrgAdminHome> {
  OrgAdminViewModel _orgAdminViewModel = OrgAdminViewModel();
  OpportunityViewModel _opportunityViewModel = OpportunityViewModel();
  List<Opportunity> opportunities = <Opportunity>[];
  String opportunityUploadPath;
  int totalReward = 0;
  int totalEnrolledUser = 0;
  int totalPendingApproval = 0;
  TextEditingController _searchController = TextEditingController();
  UserViewModel _userViewModel = UserViewModel();
  User currentUser;
  bool hasUnreadNotification = false;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  @override
  void initState() {
    getOpportunities();
    _loadUserData();
    firebaseConnection();
    super.initState();
  }

  void firebaseConnection() {
    if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        setState(() {
          hasUnreadNotification = true;
        });
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  void getOpportunities() {
    Utils.checkInternetAvailability().then((value) {
      if (value) {
        _orgAdminViewModel.getOpportunities((Map<dynamic, dynamic> body) {
          log("body in class ${body}");
          List<Opportunity> _opportunities = List<Opportunity>.from(body['data']
                  ['opportunities']
              .map((i) => Opportunity.fromJson(i)));
          setState(() {
            opportunities = _opportunities
                .where((element) =>
                    element.status == OPPORTUNITY_STATUS_VALUES['Published'])
                .toList();
            opportunityUploadPath = body["data"]["upload_path"];
            totalReward = body["data"]["total_reward"];
            totalEnrolledUser = body["data"]["total_enrolled_users"];
            totalPendingApproval = body["data"]["total_pending_approval"];
          });
        }, (error) {
          EasyLoading.showError(error);
        });
      } else {
        EasyLoading.dismiss();
        EasyLoading.showInfo(kNoInternetAvailable);
      }
    });
  }

  _loadUserData() {
    _userViewModel.loadUserData((Map<dynamic, dynamic> user) {
      setState(() {
        print('user json 2 $user');
        currentUser = User.fromJson(user);
      });
    }, (error) {
      EasyLoading.showError(error);
    });
  }

  final List<BarChartModel> data = [
    BarChartModel(
      year: "2014",
      financial: 250,
      color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    ),
    BarChartModel(
      year: "2015",
      financial: 300,
      color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    ),
    BarChartModel(
      year: "2016",
      financial: 100,
      color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    ),
    BarChartModel(
      year: "2017",
      financial: 450,
      color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    ),
    BarChartModel(
      year: "2018",
      financial: 630,
      color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    ),
    BarChartModel(
      year: "2019",
      financial: 1000,
      color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    ),
    BarChartModel(
      year: "2020",
      financial: 400,
      color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
    ),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFE5E5E5),
        appBar: AppBar(
          title: Text(kOpportunities),
          backgroundColor: kPurpleColor,
          actions: [
            GestureDetector(
              child: Image(
                image: AssetImage(hasUnreadNotification
                    ? kActiveNotificationIconPath
                    : kInactiveNotificationIconPath),
              ),
              onTap: () async {
                bool callApi = await shouldMakeApiCall(context);
                if (!callApi) return;
                Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => Notifications(currentUser)))
                    .then((value) {
                  getOpportunities();
                });
              },
            )
          ],
        ),
        drawer: CustomDrawer(currentUser),
        body: Container(
          alignment: Alignment.center,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: kMargin32),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: kPurpleColor,
                      borderRadius: BorderRadius.circular(kMargin35),
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: kMargin12, horizontal: kMargin18),
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: kMargin10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(kMargin16),
                                    ),
                                    color: kLightPurpleBackgroundColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(kMargin10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${opportunities.length}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: kMargin30,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "Opportunities",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: kMargin14,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(kMargin16),
                                    ),
                                    color: kLightPurpleBackgroundColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(kMargin10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${totalEnrolledUser}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: kMargin30,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "Users",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: kMargin14,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(kMargin16),
                                    ),
                                    color: kLightPurpleBackgroundColor,
                                    child: Padding(
                                      padding: const EdgeInsets.all(kMargin10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "\$ ${totalReward}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: kMargin30,
                                                fontWeight: FontWeight.w700),
                                          ),
                                          Text(
                                            "Rewards",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: kMargin14,
                                                fontWeight: FontWeight.w400),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(kMargin35),
                          ),
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: kMargin32, vertical: kMargin14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Updates",
                                  style: TextStyle(
                                      fontSize: kMargin14,
                                      fontWeight: FontWeight.bold,
                                      color: kPurpleColor),
                                ),
                                SizedBox(
                                  height: kMargin8,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {},
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                kMargin16),
                                          ),
                                          color: kPinkBackground,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: kMargin8,
                                                horizontal: kMargin24),
                                            child: Text(
                                              "Pending Approvals[${totalPendingApproval}]",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Card(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(kMargin16),
                                        ),
                                        color: kPinkBackground,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: kMargin8,
                                              horizontal: kMargin24),
                                          child: Text(
                                            "reward request[10]",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(kMargin35),
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kMargin32, vertical: kMargin14),
                          child: Text(
                            "Participation Growth",
                            style: TextStyle(
                                fontSize: kMargin14,
                                fontWeight: FontWeight.bold,
                                color: kPurpleColor),
                          ),
                        ),
                        SizedBox(
                          height: kMargin8,
                        ),
                        BarChartGraph(
                          data: data,
                        ),
                        SizedBox(
                          height: kMargin8,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: kMargin10,
                  ),
                  Column(
                    children: [
                      ...opportunities.map((opportunity) {
                        String coverUrl =
                            "${BASE_URL}${opportunityUploadPath}${opportunity.coverImage}";
                        return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: kMargin10),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(kMargin35),
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: kMargin32, vertical: kMargin14),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${opportunity.title}",
                                      style: TextStyle(
                                          fontSize: kMargin14,
                                          fontWeight: FontWeight.bold,
                                          color: kPurpleColor),
                                    ),
                                    SizedBox(
                                      height: kMargin8,
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      kMargin16),
                                            ),
                                            child: AspectRatio(
                                              aspectRatio: 1 / 1,
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(kRadius10)),
                                                child: CachedNetworkImage(
                                                  imageUrl: "${coverUrl}",
                                                  placeholder: (context, url) =>
                                                      Image(
                                                          image: AssetImage(
                                                              kPlaceholderImagePath)),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Image(
                                                          image: AssetImage(
                                                              kPlaceholderImagePath)),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Start on ${opportunity.opportunityDate}",
                                                    style: TextStyle(
                                                        fontSize: kMargin12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: kPurpleColor),
                                                  ),
                                                  SizedBox(
                                                    height: kMargin10,
                                                  ),
                                                  Text(
                                                    "Offered by ${opportunity.createdBy.name}",
                                                    style: TextStyle(
                                                        fontSize: kMargin12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        color: kPurpleColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: AspectRatio(
                                            aspectRatio: 1 / 1,
                                            child: GestureDetector(
                                              child: Card(
                                                color: kBlackBackground,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          kMargin16),
                                                ),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Image(
                                                        image: AssetImage(
                                                            kRightArrowWhiteIconPath)),
                                                    SizedBox(
                                                      height: kMargin10,
                                                    ),
                                                    Text(
                                                      "Run",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          OpportunityHappening(
                                                              opportunity)),
                                                ).then((value) {
                                                  getOpportunities();
                                                });
                                                // var data = opportunity.toJson();
                                                // data['status'] =
                                                //     OPPORTUNITY_STATUS_VALUES[
                                                //         'Currently Happening'];
                                                // _opportunityViewModel
                                                //     .updateOpportunity(data,
                                                //         () {
                                                //   Navigator.push(
                                                //     context,
                                                //     MaterialPageRoute(
                                                //         builder: (context) =>
                                                //             OpportunityHappening(
                                                //                 opportunity)),
                                                //   ).then((value) {
                                                //     getOpportunities();
                                                //   });
                                                // });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => OpportunityDetail(
                                        opportunity,
                                        opportunityUploadPath,
                                        currentUser))).then((value) {
                              getOpportunities();
                            });
                          },
                        );
                      })
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
