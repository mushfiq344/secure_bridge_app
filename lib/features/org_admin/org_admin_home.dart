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
import 'package:secure_bridges_app/features/enrollment/participated_user_list.dart';
import 'package:secure_bridges_app/features/enrollment/pending_approval_list.dart';
import 'package:secure_bridges_app/features/landing/drawer_menu.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_detail.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_form.dart';
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
import 'package:secure_bridges_app/utls/styles.dart';
import 'package:secure_bridges_app/widgets/custom_alert_dialogue.dart';

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
  int totalRewardRequests = 0;
  TextEditingController _searchController = TextEditingController();
  UserViewModel _userViewModel = UserViewModel();
  User currentUser;
  bool hasUnreadNotification = false;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  List<BarChartModel> weekLyEngagements = [];
  String startDate;
  String endDate;

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

  void getOpportunities() async {
    await Utils.checkInternetAvailability().then((value) {
      if (value) {
        _orgAdminViewModel.getOpportunities((Map<dynamic, dynamic> body) {
          log("body in class ${body}");
          List<Opportunity> _opportunities = List<Opportunity>.from(body['data']
                  ['opportunities']
              .map((i) => Opportunity.fromJson(i)));

          List<BarChartModel> _data = body["data"]["engagement_data"]
                  ["weekly_engagements"]
              .map<BarChartModel>((e) {
            return BarChartModel(
              year: e["day"],
              financial: e["count"],
              color: charts.ColorUtil.fromDartColor(Colors.lightBlueAccent),
            );
          }).toList();

          Future.delayed(const Duration(), () {
            setState(() {
              startDate = body["data"]["engagement_data"]["start_date"];
              endDate = body["data"]["engagement_data"]["end_date"];
              weekLyEngagements = _data;
              opportunities = _opportunities
                  .where((element) =>
                      element.status == OPPORTUNITY_STATUS_VALUES['Published'])
                  .toList();
              opportunityUploadPath = body["data"]["upload_path"];
              totalReward = body["data"]["total_reward"];
              totalEnrolledUser = body["data"]["total_enrolled_users"];
              totalPendingApproval = body["data"]["total_pending_approval"];
              totalRewardRequests = body["data"]["total_reward_request"];
            });
          });
        }, (error) {
          // EasyLoading.showError(error);
          showDialog(
              context: context,
              builder: (_) => CustomAlertDialogue("Error!", error));
        });
      } else {
        EasyLoading.dismiss();
        // EasyLoading.showInfo(kNoInternetAvailable);
        showDialog(
            context: context,
            builder: (_) =>
                CustomAlertDialogue("Error!", kNoInternetAvailable));
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
      /*EasyLoading.showError(error);*/
      showDialog(
          context: context,
          builder: (_) => CustomAlertDialogue("Error!", error));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFFE5E5E5),
        appBar: AppBar(
          leading: Builder(
            builder: (context) => GestureDetector(
              child: Container(
                decoration: BoxDecoration(
                  image:
                      DecorationImage(image: AssetImage(kIconBackgroundPath)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image(
                    image: AssetImage(kIconHamBurgerMenu),
                  ),
                ),
              ),
              onTap: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: Text(
            kOpportunities,
            style: TextStyle(color: kPurpleColor),
          ),
          iconTheme: IconThemeData(color: kPurpleColor),
          backgroundColor: kAppBarBackgroundColor,
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
              padding: EdgeInsets.only(bottom: 5),
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: kPurpleColor,
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(35),
                          bottomRight: Radius.circular(35)),
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
                                    color: kLightPurpleBackgroundColor
                                        .withOpacity(.5),
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
                                            "My opportunities",
                                            overflow: TextOverflow.fade,
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
                                    color: kLightPurpleBackgroundColor
                                        .withOpacity(.5),
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
                                    color: kLightPurpleBackgroundColor
                                        .withOpacity(.5),
                                    child: Padding(
                                      padding: const EdgeInsets.all(kMargin10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${totalReward}",
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
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                              "Pending Approvals [${totalPendingApproval}]",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: kInactiveColor),
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
                                            "reward request [10]",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: kInactiveColor),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      // decoration: BoxDecoration(
                      //   shape: BoxShape.rectangle,
                      //   color: Colors.white,
                      //   borderRadius: BorderRadius.circular(kMargin35),
                      // ),
                      // width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                            title: "From ${startDate} To ${endDate}",
                            data: weekLyEngagements,
                          ),
                          SizedBox(
                            height: kMargin8,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: kMargin10,
                  ),
                  Column(
                    children: [
                      ...opportunities.map((opportunity) {
                        String coverUrl =
                            "${BASE_URL}${opportunityUploadPath}${opportunity.iconImage}";
                        return GestureDetector(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: kMargin10, left: 20, right: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(kMargin5),
                              ),
                              width: MediaQuery.of(context).size.width,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        kMargin5),
                                              ),
                                              child: AspectRatio(
                                                aspectRatio: 1 / 1,
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              kMargin5)),
                                                  child: CachedNetworkImage(
                                                    imageUrl: "${coverUrl}",
                                                    placeholder:
                                                        (context, url) => Image(
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
                                            flex: 2,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 13,
                                                      vertical: 9),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "${opportunity.title}",
                                                    style: TextStyle(
                                                        fontSize: kMargin14,
                                                        fontWeight:
                                                            FontWeight.w700,
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
                                                  SizedBox(
                                                    height: kMargin10,
                                                  ),
                                                  Text(
                                                    "Start on ${opportunity.opportunityDate}",
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                        fontSize: kMargin12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: kPurpleColor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Positioned.fill(
                                        child: Row(
                                          children: [
                                            Expanded(
                                                flex: 2, child: SizedBox()),
                                            Expanded(
                                              flex: 1,
                                              child: GestureDetector(
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.rectangle,
                                                    color:
                                                        opportunityColorCodes(
                                                            opportunity.status),
                                                    //here i want to add opacity
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            kMargin5),
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Image(
                                                          image: AssetImage(
                                                              opportunityStatusIcon(
                                                                  opportunity
                                                                      .status))),
                                                      SizedBox(
                                                        height: kMargin10,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Text(
                                                          OPPORTUNITY_STATUS_ACTIONS_TEXT[
                                                              OPPORTUNITY_STATUS[
                                                                  opportunity
                                                                      .status]],
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize:
                                                                  kMargin14),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                onTap: () async {
                                                  bool callApi =
                                                      await shouldMakeApiCall(
                                                          context);
                                                  if (!callApi) return;
                                                  if (opportunity.status ==
                                                      OPPORTUNITY_STATUS_VALUES[
                                                          'Drafted']) {
                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (context) =>
                                                                OpportunityForm(
                                                                    opportunity,
                                                                    opportunityUploadPath,
                                                                    currentUser))).then(
                                                        (value) {
                                                      getOpportunities();
                                                    });
                                                  } else if (opportunity
                                                          .status ==
                                                      OPPORTUNITY_STATUS_VALUES[
                                                          'Published']) {
                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (context) =>
                                                                PendingEnrolledOpportunityUser(
                                                                    opportunity))).then(
                                                        (value) {
                                                      getOpportunities();
                                                    });
                                                  } else if (opportunity
                                                          .status ==
                                                      OPPORTUNITY_STATUS_VALUES[
                                                          'Currently Happening']) {
                                                    var data =
                                                        opportunity.toJson();
                                                    data['status'] =
                                                        OPPORTUNITY_STATUS_VALUES[
                                                            'Ended'];
                                                    _opportunityViewModel
                                                        .updateOpportunity(data,
                                                            () {
                                                      getOpportunities();
                                                    }, (error) {});
                                                  } else if (opportunity
                                                          .status ==
                                                      OPPORTUNITY_STATUS_VALUES[
                                                          'Ended']) {
                                                    var data =
                                                        opportunity.toJson();
                                                    data['status'] =
                                                        OPPORTUNITY_STATUS_VALUES[
                                                            'Rewarding'];
                                                    _opportunityViewModel
                                                        .updateOpportunity(data,
                                                            () {
                                                      getOpportunities();
                                                    }, (error) {
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) =>
                                                              CustomAlertDialogue(
                                                                  "Error!",
                                                                  error));
                                                    });
                                                  } else if (opportunity
                                                          .status ==
                                                      OPPORTUNITY_STATUS_VALUES[
                                                          'Rewarding']) {
                                                    Navigator.push(
                                                        context,
                                                        new MaterialPageRoute(
                                                            builder: (context) =>
                                                                ParticipatedUserList(
                                                                    opportunity))).then(
                                                        (value) {
                                                      getOpportunities();
                                                    });
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            color: opportunityColorCodes(opportunity
                                                .status), //here i want to add opacity
                                            borderRadius:
                                                BorderRadius.circular(kMargin5),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: kMargin5,
                                                horizontal: kMargin16),
                                            child: Text(
                                              OPPORTUNITY_STATUS[
                                                  opportunity.status],
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: kMargin14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () async {
                            bool callApi = await shouldMakeApiCall(context);
                            if (!callApi) return;
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
