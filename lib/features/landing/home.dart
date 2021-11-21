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
import 'package:secure_bridges_app/features/Notification/notification_list.dart';
import 'package:secure_bridges_app/features/landing/drawer_menu.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_detail.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_form.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_view_model.dart';
import 'package:secure_bridges_app/features/org_admin/org_admin_view_model.dart';
import 'package:secure_bridges_app/features/user/user_view_model.dart';
import 'package:secure_bridges_app/screen/secure_bridge_web_view.dart';
import 'package:secure_bridges_app/features/authentication/login.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/features/opportunity/opportunities.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/utls/styles.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with Observer {
  String name;
  String email;
  int userId;
  String profilePictureUrl;
  int userType;
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
  @override
  void initState() {
    Observable.instance.addObserver(this);
    _userViewModel.loadUserData((Map<dynamic, dynamic> user) {
      setState(() {
        userId = user['id'];
        name = user['name'];
        email = user['email'];
        profilePictureUrl = user['profile_image'];
        print("user type ${user['user_type']}");
        userType = user['user_type'];
      });
    }, (error) {
      EasyLoading.showError(error);
    });
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
    try {
      EasyLoading.show(status: kLoading);
      var res = await Network().getData(OPPORTUNITIES_URL);
      var body = json.decode(res.body);
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        log("$body");
        List<Opportunity> _opportunities = List<Opportunity>.from(
            body['data']['opportunities'].map((i) => Opportunity.fromJson(i)));
        setState(() {
          opportunities = _opportunities;
          opportunitiesAll = _opportunities;
          searchedOpportunities = _opportunities;
          opportunityUploadPath = body["data"]["upload_path"];
          userWishes = body['data']['user_wishes'].cast<int>();
          userEnrollments = body['data']['user_enrollments'].cast<int>();
        });
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(body["message"]);
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
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

  // fetchOpportunities(int maxDuration, int minDuratin, String maxReward,
  //     String minReward) async {
  //   try {
  //     var data = {
  //       'duration_high': maxDuration,
  //       'duration_low': minDuratin,
  //       'reward_low': minReward,
  //       'reward_high': maxReward
  //     };
  //
  //     var res = await Network().postData(data, FETCH_OPPORTUNITIES_URL);
  //     var body = json.decode(res.body);
  //     // log("res ${res.statusCode}");
  //     if (res.statusCode == 200) {
  //       List<Opportunity> _opportunities = List<Opportunity>.from(
  //           body['data']['opportunities'].map((i) => Opportunity.fromJson(i)));
  //
  //       setState(() {
  //         opportunities = _opportunities;
  //         opportunitiesAll = _opportunities;
  //         searchedOpportunities = _opportunities;
  //         opportunityUploadPath = body["data"]["upload_path"];
  //         userWishes=body['data']['user_wishes'].cast<int>();
  //       });
  //       EasyLoading.dismiss();
  //     } else {
  //       EasyLoading.dismiss();
  //       EasyLoading.showError(body['message']);
  //     }
  //   } catch (e) {
  //     EasyLoading.dismiss();
  //     EasyLoading.showError(e.toString());
  //   }
  // }

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
                        item, opportunityUploadPath, userId, userType)))
            .then((value) {
          _userViewModel.loadUserData((Map<dynamic, dynamic> user) {
            setState(() {
              userId = user['id'];
              name = user['name'];
              email = user['email'];
              profilePictureUrl = user['profile_image'];
              print("user type ${user['user_type']}");
              userType = user['user_type'];
            });
          }, (error) {
            EasyLoading.showError(error);
          });
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
                    userId != item.createdBy.id && userType == 0
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
                                      _userViewModel.loadUserData(
                                          (Map<dynamic, dynamic> user) {
                                        setState(() {
                                          userId = user['id'];
                                          name = user['name'];
                                          email = user['email'];
                                          profilePictureUrl =
                                              user['profile_image'];
                                          print(
                                              "user type ${user['user_type']}");
                                          userType = user['user_type'];
                                        });
                                      }, (error) {
                                        EasyLoading.showError(error);
                                      });
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
                                        _userViewModel.loadUserData(
                                            (Map<dynamic, dynamic> user) {
                                          setState(() {
                                            userId = user['id'];
                                            name = user['name'];
                                            email = user['email'];
                                            profilePictureUrl =
                                                user['profile_image'];
                                            print(
                                                "user type ${user['user_type']}");
                                            userType = user['user_type'];
                                          });
                                        }, (error) {
                                          EasyLoading.showError(error);
                                        });
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
                            children: userId == item.createdBy.id
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
                        builder: (context) => Notifications())).then((value) {
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
        drawer: CustomDrawer(profilePictureUrl, name, email, userType));
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
