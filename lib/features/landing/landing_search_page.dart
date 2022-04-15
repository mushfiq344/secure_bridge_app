import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:flutter_observer/Observer.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/Models/User.dart';
import 'package:secure_bridges_app/features/Notification/notification_list.dart';
import 'package:secure_bridges_app/features/landing/drawer_menu.dart';
import 'package:secure_bridges_app/features/landing/landing_view_model.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_detail.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_form.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_view_model.dart';
import 'package:secure_bridges_app/features/org_admin/org_admin_view_model.dart';
import 'package:secure_bridges_app/widgets/slider.dart';
import 'package:secure_bridges_app/features/user/user_view_model.dart';

import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/network_utils/global_utility.dart';

import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';

import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:secure_bridges_app/widgets/custom_alert_dialogue.dart';

class LandingSearchPage extends StatefulWidget {
  @override
  _LandingSearchPageState createState() => _LandingSearchPageState();
}

class _LandingSearchPageState extends State<LandingSearchPage> with Observer {
  LandingViewModel _landingViewModel = LandingViewModel();
  List<int> userWishes = [];
  List<int> userEnrollments = [];
  List<int> usersEnrollment = [];
  List<Opportunity> opportunities = <Opportunity>[];
  List<Opportunity> allOpportunities = <Opportunity>[];
  static List<Opportunity> searchedOpportunities = [];
  TextEditingController _searchController = TextEditingController();
  OpportunityViewModel _opportunityViewModel = OpportunityViewModel();
  OrgAdminViewModel _orgAdminViewModel = OrgAdminViewModel();
  UserViewModel _userViewModel = UserViewModel();
  String opportunityUploadPath;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool hasUnreadNotification = false;
  User currentUser;
  int opportunityTypeSelected = -1; // -1 means all
  List<String> imgList = [];
  List<Opportunity> featuredOpportunities = [];

  @override
  void initState() {
    Observable.instance.addObserver(this);
    _loadUserData();
    _searchController.addListener(_applySearchOnOpportunityeList);
    _loadOpportunitiesStats();
    /*push notification */
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

  void _applySearchOnOpportunityeList() {
    List<Opportunity> _tempSearchedList = [];
    for (Opportunity opportunity in allOpportunities) {
      if (opportunity.title != null) {
        if (opportunityTypeSelected != -1) {
          if (opportunity.title
                  .toLowerCase()
                  .contains(_searchController.text.toLowerCase()) &&
              opportunity.type == opportunityTypeSelected) {
            _tempSearchedList.add(opportunity);
          }
        } else {
          if (opportunity.title
              .toLowerCase()
              .contains(_searchController.text.toLowerCase())) {
            _tempSearchedList.add(opportunity);
          }
        }
      }
    }
    setState(() {
      opportunities = _tempSearchedList;
      searchedOpportunities = _tempSearchedList;
    });
  }

  _loadOpportunitiesStats() async {
    Utils.checkInternetAvailability().then((value) {
      if (value) {
        _landingViewModel.loadHomeScreenData((Map<dynamic, dynamic> body) {
          List<Opportunity> _opportunities = List<Opportunity>.from(body['data']
                  ['opportunities']
              .map((i) => Opportunity.fromJson(i)));
          List<Opportunity> _featuredOpportunities = _opportunities
              .where((element) => element.isFeatured == 1)
              .toList();
          setState(() {
            // imgList = _featuredOpportunities
            //     .map<String>((e) =>
            //         "${BASE_URL}${body["data"]["upload_path"]}${e.coverImage}")
            //     .toList();
            featuredOpportunities = _featuredOpportunities;

            opportunities = _opportunities;
            allOpportunities = _opportunities;
            searchedOpportunities = _opportunities;
            opportunityUploadPath = body["data"]["upload_path"];
            userWishes = body['data']['user_wishes'].cast<int>();
            userEnrollments = body['data']['user_enrollments'].cast<int>();
            hasUnreadNotification = body['data']['has_active_notifications'];
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
        currentUser = User.fromJson(user);
      });
    }, (error) {
      // EasyLoading.showError(error);
      showDialog(
          context: context,
          builder: (_) => CustomAlertDialogue("Error!", error));
    });
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  @override
  update(Observable observable, String notifyName, Map map) async {
    _loadOpportunitiesStats();
  }

  _setUpSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: kLightPurpleBackgroundColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: kMargin18, horizontal: kMargin18),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(kRadius10),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(kRadius10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(kRadius10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildOpportunityList(BuildContext context) {
    return opportunities.length > 0
        ? ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: opportunities.length,
            itemBuilder: (_, index) {
              final item = opportunities[index];
              return _buildListItem(item);
            },
          )
        : Center(child: Text("No Item Found"));
  }

  _buildListItem(Opportunity item) {
    String coverUrl = "${BASE_URL}${opportunityUploadPath}${item.coverImage}";
    print("cover url $coverUrl");

    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
        bool callApi = await shouldMakeApiCall(context);
        if (!callApi) return;
        Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => OpportunityDetail(
                        item, opportunityUploadPath, currentUser)))
            .then((value) async {
          _loadUserData();
          _loadOpportunitiesStats();
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(
            left: kMargin5, right: kMargin5, bottom: kMargin5),
        child: Card(
          elevation: 4.0,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                      child: AspectRatio(
                    aspectRatio: 1 / .5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(kRadius10),
                        topRight: Radius.circular(kRadius10),
                      ),
                      child: CachedNetworkImage(
                        imageUrl: coverUrl,
                        placeholder: (context, url) =>
                            Image(image: AssetImage(kPlaceholderImagePath)),
                        errorWidget: (context, url, error) =>
                            Image(image: AssetImage(kPlaceholderImagePath)),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ))
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, top: 10),
                child: Text(item.title,
                    style: TextStyle(
                        fontSize: kMargin18,
                        fontWeight: FontWeight.w400,
                        color: kPurpleColor)),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Offered By ${item.createdBy.name}",
                          style: TextStyle(
                              color: kPurpleColor,
                              fontWeight: FontWeight.w400,
                              fontSize: kMargin12),
                        ),
                        Text("Start on ${item.opportunityDate}",
                            style: TextStyle(
                                color: kInactiveColor,
                                fontWeight: FontWeight.w400,
                                fontSize: kMargin12))
                      ],
                    ),
                    currentUser.id != item.createdBy.id &&
                            currentUser.userType == 0
                        ? Row(
                            children: [
                              GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(kIconBackgroundPath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: userWishes.contains(item.id)
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image(
                                            width: 16,
                                            height: 16,
                                            image: AssetImage(kIconLovePath),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image(
                                            width: 16,
                                            height: 16,
                                            image:
                                                AssetImage(kIconLoveWhitePath),
                                          ),
                                        ),
                                ),
                                onTap: () async {
                                  bool callApi =
                                      await shouldMakeApiCall(context);
                                  if (!callApi) return;
                                  if (userWishes.contains(item.id)) {
                                    _opportunityViewModel.removeFromWithList(
                                        context, item, (success) {
                                      _loadOpportunitiesStats();
                                    }, (error) {
                                      // EasyLoading.showError(error);
                                      showDialog(
                                          context: context,
                                          builder: (_) => CustomAlertDialogue(
                                              "Error!", error));
                                    });
                                  } else {
                                    bool callApi =
                                        await shouldMakeApiCall(context);
                                    if (!callApi) return;
                                    _opportunityViewModel
                                        .addToWishList(context, item, () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => new AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                contentPadding: EdgeInsets.zero,
                                                content: Builder(
                                                  builder: (context) {
                                                    // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                    var height =
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height;
                                                    var width =
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width;

                                                    return Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              kAlertDialogBackgroundColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      20.0))),
                                                      height: height * .5,
                                                      width: width * .75,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 50,
                                                                horizontal: 30),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "ADDED TO FAVORITE",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      kMargin24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      kPurpleColor),
                                                            ),
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  33,
                                                            ),
                                                            Text(
                                                              "Opportunity has been added to your favourties",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  33,
                                                            ),
                                                            PAButton(
                                                              "Ok",
                                                              true,
                                                              () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              fillColor:
                                                                  kPurpleColor,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )).then((value) {
                                        _loadOpportunitiesStats();
                                      });
                                    }, (error) {
                                      // EasyLoading.showError(error);
                                      showDialog(
                                          context: context,
                                          builder: (_) => CustomAlertDialogue(
                                              "Error!", error));
                                    });
                                  }
                                },
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(kIconBackgroundPath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  child: userEnrollments.contains(item.id)
                                      ? Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image(
                                            width: 16,
                                            height: 16,
                                            image:
                                                AssetImage(kIconAdditionPath),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image(
                                            width: 16,
                                            height: 16,
                                            image: AssetImage(
                                                kIconAdditionWhitePath),
                                          ),
                                        ),
                                ),
                                onTap: () async {
                                  bool callApi =
                                      await shouldMakeApiCall(context);
                                  if (!callApi) return;
                                  if (userEnrollments.contains(item.id)) {
                                    _opportunityViewModel.removeFromEnrollments(
                                        context, item, (success) {
                                      _loadUserData();
                                      _loadOpportunitiesStats();
                                    }, (error) {
                                      // EasyLoading.showError(error);
                                      showDialog(
                                          context: context,
                                          builder: (_) => CustomAlertDialogue(
                                              "Error!", error));
                                    });
                                  } else {
                                    _opportunityViewModel
                                        .enrollUser(context, item, () {
                                      showDialog(
                                          context: context,
                                          builder: (_) => new AlertDialog(
                                                backgroundColor:
                                                    Colors.transparent,
                                                contentPadding: EdgeInsets.zero,
                                                content: Builder(
                                                  builder: (context) {
                                                    // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                    var height =
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height;
                                                    var width =
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width;

                                                    return Container(
                                                      decoration: BoxDecoration(
                                                          color:
                                                              kAlertDialogBackgroundColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius.circular(
                                                                      20.0))),
                                                      height: height * .5,
                                                      width: width * .75,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 50,
                                                                horizontal: 30),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "ENROLLMENT CONFIRMATION",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      kMargin24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color:
                                                                      kPurpleColor),
                                                            ),
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  33,
                                                            ),
                                                            Text(
                                                              "Your request to enroll to the oppoertunity is pending for admin review. You’ll get notification once the request is approved",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            SizedBox(
                                                              height: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .height /
                                                                  33,
                                                            ),
                                                            PAButton(
                                                              "Ok",
                                                              true,
                                                              () {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                              },
                                                              fillColor:
                                                                  kPurpleColor,
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              )).then((value) {
                                        _loadUserData();
                                        _loadOpportunitiesStats();
                                      });
                                    }, (error) {
                                      // EasyLoading.showError(error);
                                      showDialog(
                                          context: context,
                                          builder: (_) => CustomAlertDialogue(
                                              "Error!", error));
                                    });
                                  }
                                },
                              )
                            ],
                          )
                        : Row(
                            children: currentUser.id == item.createdBy.id
                                ? [
                                    GestureDetector(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                            image:
                                                AssetImage(kIconBackgroundPath),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image(
                                            width: 16,
                                            height: 16,
                                            image:
                                                AssetImage(kIconWhiteEditPath),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            new MaterialPageRoute(
                                                builder: (context) =>
                                                    OpportunityForm(
                                                        item,
                                                        opportunityUploadPath,
                                                        currentUser))).then(
                                            (value) {
                                          if (value) {
                                            _loadOpportunitiesStats();
                                          }
                                        });
                                      },
                                    ),
                                    GestureDetector(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: AssetImage(
                                                  kIconBackgroundPath),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image(
                                              width: 16,
                                              height: 16,
                                              image: AssetImage(kTrashIconPath),
                                            ),
                                          ),
                                        ),
                                      ),
                                      onTap: () {
                                        showAlertDialog(context, item.id);
                                      },
                                    ),
                                  ]
                                : [],
                          ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            kAppName,
            style: TextStyle(color: kPurpleColor),
          ),
          backgroundColor: kAppBarBackgroundColor,
          iconTheme: IconThemeData(color: kPurpleColor),
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
                    .then((value) async {
                  _loadOpportunitiesStats();
                });
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).requestFocus(new FocusNode());
            },
            child: Column(
              children: [
                Container(
                  child: OpportunitySlider(
                    featuredOpportunities: featuredOpportunities,
                    uploadPath: opportunityUploadPath,
                    currentUser: currentUser,
                    loadUserData: _loadUserData,
                    loadOpportunitiesStats: _loadOpportunitiesStats,
                  ),
                ),
                _setUpSearchBar(),
                setUpFilterArea(),
                _buildOpportunityList(context),
                SizedBox(height: kMargin300),
              ],
            ),
          ),
        ),
        drawer: CustomDrawer(currentUser));
  }

  showAlertDialog(BuildContext context, id) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed: () {
        Navigator.of(context).pop();
        _orgAdminViewModel.deleteOpportunity(id, (success) async {
          showDialog(
              context: context,
              builder: (_) => CustomAlertDialogue("Success!", success));
          _loadOpportunitiesStats();
        }, (error) {
          // EasyLoading.showError(error);
          showDialog(
              context: context,
              builder: (_) => CustomAlertDialogue("Error!", error));
        });
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("AlertDialog"),
      content: Text("Do you want to delete it?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget setUpFilterArea() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                        bottomLeft: Radius.circular(26),
                        bottomRight: Radius.circular(26)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(1),
                        spreadRadius: -3,
                        blurRadius: 5,
                        offset: Offset(1, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Card(
                    color: kPurpleBackGround,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26)),
                    child: Image(
                      image: AssetImage(kStarconPath),
                    ),
                  ),
                ),
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                List<Opportunity> filteredOpportunities =
                    allOpportunities.where((element) {
                  return element.title
                      .toLowerCase()
                      .contains(_searchController.text.toLowerCase());
                }).toList();
                setState(() {
                  opportunities = filteredOpportunities;
                  opportunityTypeSelected = -1;
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                        bottomLeft: Radius.circular(26),
                        bottomRight: Radius.circular(26)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(1),
                        spreadRadius: -3,
                        blurRadius: 5,
                        offset: Offset(1, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Card(
                    color: kPurpleBackGround,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26)),
                    child: Image(
                      image: AssetImage(kHomeWhiteIconPath),
                    ),
                  ),
                ),
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                List<Opportunity> filteredOpportunities =
                    allOpportunities.where((element) {
                  return element.type == 0 &&
                      element.title
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase());
                }).toList();
                setState(() {
                  opportunities = filteredOpportunities;
                  opportunityTypeSelected = 0;
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                        bottomLeft: Radius.circular(26),
                        bottomRight: Radius.circular(26)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(1),
                        spreadRadius: -3,
                        blurRadius: 5,
                        offset: Offset(1, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Card(
                    color: kPurpleBackGround,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26)),
                    child: Image(
                      image: AssetImage(kMultipleUsersIconPath),
                    ),
                  ),
                ),
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                List<Opportunity> filteredOpportunities =
                    allOpportunities.where((element) {
                  return element.type == 1 &&
                      element.title
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase());
                }).toList();
                setState(() {
                  opportunities = filteredOpportunities;
                  opportunityTypeSelected = 1;
                });
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: GestureDetector(
              child: AspectRatio(
                aspectRatio: 1 / 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(26),
                        topRight: Radius.circular(26),
                        bottomLeft: Radius.circular(26),
                        bottomRight: Radius.circular(26)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(1),
                        spreadRadius: -3,
                        blurRadius: 5,
                        offset: Offset(1, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Card(
                    color: kPurpleBackGround,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26)),
                    child: Image(
                      image: AssetImage(kPizzaIconPath),
                    ),
                  ),
                ),
              ),
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
                List<Opportunity> filteredOpportunities =
                    allOpportunities.where((element) {
                  return element.type == 2 &&
                      element.title
                          .toLowerCase()
                          .contains(_searchController.text.toLowerCase());
                }).toList();
                setState(() {
                  opportunities = filteredOpportunities;
                  opportunityTypeSelected = 2;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
