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
import 'package:secure_bridges_app/features/user/user_view_model.dart';

import 'package:secure_bridges_app/network_utils/api.dart';

import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';

import 'package:secure_bridges_app/widgets/PAButton.dart';

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
  List<Opportunity> opportunitiesAll = <Opportunity>[];
  static List<Opportunity> searchedOpportunities = [];
  TextEditingController _searchController = TextEditingController();
  OpportunityViewModel _opportunityViewModel = OpportunityViewModel();
  OrgAdminViewModel _orgAdminViewModel = OrgAdminViewModel();
  UserViewModel _userViewModel = UserViewModel();
  String opportunityUploadPath;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool hasUnreadNotification = false;
  User currentUser;
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
    for (Opportunity opportunity in opportunitiesAll) {
      if (opportunity.title != null) {
        if (opportunity.title
            .toLowerCase()
            .contains(_searchController.text.toLowerCase())) {
          _tempSearchedList.add(opportunity);
        }
      }
    }
    setState(() {
      opportunities = _tempSearchedList;
      searchedOpportunities = _tempSearchedList;
    });
  }

  _loadOpportunitiesStats() async {
    _landingViewModel.loadHomeScreenData((Map<dynamic, dynamic> body) {
      List<Opportunity> _opportunities = List<Opportunity>.from(
          body['data']['opportunities'].map((i) => Opportunity.fromJson(i)));
      setState(() {
        opportunities = _opportunities;
        opportunitiesAll = _opportunities;
        searchedOpportunities = _opportunities;
        opportunityUploadPath = body["data"]["upload_path"];
        userWishes = body['data']['user_wishes'].cast<int>();
        userEnrollments = body['data']['user_enrollments'].cast<int>();
        hasUnreadNotification = body['data']['has_active_notifications'];
      });
    }, (error) {
      EasyLoading.showError(error);
    });
  }

  _loadUserData() {
    _userViewModel.loadUserData((Map<dynamic, dynamic> user) {
      setState(() {
        currentUser = User.fromJson(user);
      });
    }, (error) {
      EasyLoading.showError(error);
    });
  }

  @override
  void dispose() {
    Observable.instance.removeObserver(this);
    super.dispose();
  }

  @override
  update(Observable observable, String notifyName, Map map) {
    ///do your work
    _loadOpportunitiesStats();
  }

  _setUpSearchBar() {
    return Container(
      color: kLiteBackgroundColor,
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
                      color: kBorderColor,
                    ),
                    borderRadius: BorderRadius.circular(kRadius10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: kAccentColor,
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

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => OpportunityDetail(
                    item, opportunityUploadPath, currentUser))).then((value) {
          _loadUserData();
          _loadOpportunitiesStats();
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(
            left: kMargin20, right: kMargin20, bottom: kMargin20),
        child: Card(
          elevation: 4.0,
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              Text(item.title,
                  style: TextStyle(
                      fontSize: kMargin18,
                      fontWeight: FontWeight.w400,
                      color: kPurpleColor)),
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
                                      ? Image(
                                          width: 32,
                                          height: 32,
                                          image: AssetImage(kIconLoveWhitePath),
                                        )
                                      : Image(
                                          width: 32,
                                          height: 32,
                                          image: AssetImage(kIconLovePath),
                                        ),
                                ),
                                onTap: () {
                                  if (userWishes.contains(item.id)) {
                                    _opportunityViewModel.removeFromWithList(
                                        context, item, (success) {
                                      _loadOpportunitiesStats();
                                    }, (error) {
                                      EasyLoading.showError(error);
                                    });
                                  } else {
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
                                                              "ADDED TO FAVOURITES",
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
                                                              height: 33,
                                                            ),
                                                            Text(
                                                              "Opportunity has been added to your favourties",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            SizedBox(
                                                              height: 33,
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
                                      EasyLoading.showError(error);
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
                                      ? Image(
                                          width: 32,
                                          height: 32,
                                          image: AssetImage(
                                              kIconAdditionWhitePath),
                                        )
                                      : Image(
                                          width: 32,
                                          height: 32,
                                          image: AssetImage(kIconAdditionPath),
                                        ),
                                ),
                                onTap: () {
                                  if (userEnrollments.contains(item.id)) {
                                    _opportunityViewModel.removeFromEnrollments(
                                        context, item, (success) {
                                      _loadUserData();
                                      _loadOpportunitiesStats();
                                    }, (error) {
                                      EasyLoading.showError(error);
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
                                                              height: 33,
                                                            ),
                                                            Text(
                                                              "Your request to enroll to the oppoertunity is pending for admin review. You’ll get notification once the request is approved",
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                            ),
                                                            SizedBox(
                                                              height: 33,
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
                                      EasyLoading.showError(error);
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
                                        child: Image(
                                          width: 32,
                                          height: 32,
                                          image: AssetImage(kIconWhiteEditPath),
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                                context,
                                                new MaterialPageRoute(
                                                    builder: (context) =>
                                                        OpportunityForm(item,
                                                            opportunityUploadPath)))
                                            .then((value) {
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
                                          child: Image(
                                            width: 32,
                                            height: 32,
                                            image: AssetImage(kTrashIconPath),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(kAppName),
          backgroundColor: kPurpleColor,
          actions: [
            GestureDetector(
              child: Image(
                image: AssetImage(hasUnreadNotification
                    ? kActiveNotificationIconPath
                    : kInactiveNotificationIconPath),
              ),
              onTap: () {
                Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => Notifications(currentUser)))
                    .then((value) {
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
                _setUpSearchBar(),
                SizedBox(height: kMargin12),
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
        _orgAdminViewModel.deleteOpportunity(id, () async {
          _loadOpportunitiesStats();
        }, (error) {
          EasyLoading.showError(error);
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
}
