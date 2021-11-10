import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/features/landing/drawer_menu.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_detail.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_form.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_view_model.dart';
import 'package:secure_bridges_app/screen/secure_bridge_web_view.dart';
import 'package:secure_bridges_app/screen/login.dart';
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

class _HomeState extends State<Home> {
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
  String opportunityUploadPath;
  @override
  void initState() {
    _loadUserData();
    _searchController.addListener(_applySearchOnOpportunityeList);
    _loadOpportunitiesStats();
    super.initState();
  }

  _loadUserData() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var user = jsonDecode(localStorage.getString('user'));
    print("user $user");
    if (user != null) {
      setState(() {
        userId = user['id'];
        name = user['name'];
        email = user['email'];
        profilePictureUrl = user['profile_image'];
        print("user type ${user['user_type']}");
        userType = user['user_type'];
      });
    }
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
                          "Offered By Jet Constellations",
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
                    userId != item.createdBy
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
                                    _removeFromWithList(item);
                                  } else {
                                    _addToWishList(item);
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
                            children: [
                              GestureDetector(
                                child: Container(
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image: AssetImage(kIconBackgroundPath),
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
                                          builder: (context) => OpportunityForm(
                                              item,
                                              opportunityUploadPath))).then(
                                      (value) {
                                    if (value) {
                                      _loadOpportunitiesStats();
                                    }
                                  });
                                },
                              ),
                              GestureDetector(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(kIconBackgroundPath),
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
                            ],
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
        _deleteOpportunity(id);
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

  void _deleteOpportunity(int id) async {
    try {
      EasyLoading.show(status: kLoading);
      var res = await Network().deleteData({}, "$OPPORTUNITIES_URL/$id");
      print("body ${res.body}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : ${body}");
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess(body["message"]);
        _loadOpportunitiesStats();
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }

  _addToWishList(Opportunity opportunity) async {
    try {
      EasyLoading.show(status: kLoading);
      var res = await Network()
          .postData({'opportunity_id': opportunity.id}, WISH_LIST_URL);
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : ${body}");
      if (res.statusCode == 201) {
        EasyLoading.dismiss();
        _loadOpportunitiesStats();
        EasyLoading.showSuccess(body["message"]);
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }

  _removeFromWithList(Opportunity opportunity) async {
    try {
      EasyLoading.show(status: kLoading);
      var res =
          await Network().deleteData({}, "${WISH_LIST_URL}/${opportunity.id}");
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        print(body);
        EasyLoading.dismiss();
        _loadOpportunitiesStats();
        EasyLoading.showSuccess(body["message"]);
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(body['message']);
      }
    } catch (e) {
      print("error here");
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }
}
