import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/Models/User.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_detail.dart';

import 'package:secure_bridges_app/features/opportunity/opportunity_view_model.dart';
import 'package:secure_bridges_app/features/user/user_view_model.dart';
import 'package:secure_bridges_app/network_utils/global_utility.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:secure_bridges_app/widgets/custom_alert_dialogue.dart';
import 'package:secure_bridges_app/widgets/input_decoration.dart';

class UserHome extends StatefulWidget {
  final User currentUser;
  UserHome(this.currentUser);
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  String name;
  String email;
  int userId;
  String profilePictureUrl;
  int userType = 0;
  UserViewModel _userViewModel = UserViewModel();
  OpportunityViewModel _opportunityViewModel = OpportunityViewModel();
  List<Opportunity> allOpportunities = <Opportunity>[];
  List<Opportunity> opportunities = <Opportunity>[];
  String opportunityUploadPath;
  List<int> userWishes = [];
  List<int> userEnrollments = [];
  @override
  void initState() {
    loadUserData();
    loadUserOpportunitiesData();
    super.initState();
  }

  void loadUserData() {
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
  }

  void loadUserOpportunitiesData() {
    Utils.checkInternetAvailability().then((value) {
      if (value) {
        _userViewModel.getOpportunities((Map<dynamic, dynamic> body) {
          log("body in class ${body}");
          List<Opportunity> _opportunities = List<Opportunity>.from(body['data']
                  ['opportunities']
              .map((i) => Opportunity.fromJson(i)));
          setState(() {
            allOpportunities = _opportunities;
            opportunities = _opportunities;
            opportunityUploadPath = body["data"]["upload_path"];
            userWishes = body['data']['user_wishes'].cast<int>();
            userEnrollments = body['data']['user_enrollments'].cast<int>();
          });
        }, (error) {
          EasyLoading.showError(error);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My Opportunity"),
        backgroundColor: kPurpleColor,
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: kMargin16, vertical: kMargin16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: kPinkBackground,
                      borderRadius: BorderRadius.all(Radius.circular(29))),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: kMargin48, horizontal: kMargin32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "AWARENESS TOGETHER",
                          style: TextStyle(
                              fontSize: 36,
                              color: kPurpleColor,
                              fontWeight: FontWeight.w400),
                        ),
                        Text(
                          "Find what fascinates you as you explore these habit courses.",
                          style: TextStyle(
                              fontSize: 10,
                              color: kPurpleColor,
                              fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: kMargin20,
                ),
                Row(
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
                                  offset: Offset(
                                      1, 3), // changes position of shadow
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
                          setState(() {
                            opportunities = allOpportunities;
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
                                  offset: Offset(
                                      1, 3), // changes position of shadow
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
                          List<Opportunity> filteredOpportunities =
                              allOpportunities.where((element) {
                            return element.type == 0;
                          }).toList();
                          setState(() {
                            opportunities = filteredOpportunities;
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
                                  offset: Offset(
                                      1, 3), // changes position of shadow
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
                          List<Opportunity> filteredOpportunities =
                              allOpportunities.where((element) {
                            return element.type == 1;
                          }).toList();
                          setState(() {
                            opportunities = filteredOpportunities;
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
                                  offset: Offset(
                                      1, 3), // changes position of shadow
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
                          List<Opportunity> filteredOpportunities =
                              allOpportunities.where((element) {
                            return element.type == 2;
                          }).toList();
                          setState(() {
                            opportunities = filteredOpportunities;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: kMargin20,
                ),
                // Row(
                //   children: [
                //     Expanded(
                //       flex: 1,
                //       child: FormBuilderDropdown(
                //         name: 'gender',
                //         decoration: customInputDecoration("Popular"),
                //         // initialValue: 'Male',
                //         allowClear: true,
                //
                //         validator: FormBuilderValidators.compose(
                //             [FormBuilderValidators.required(context)]),
                //         items: ["male", "female", "others"]
                //             .map((gender) => DropdownMenuItem(
                //                   value: gender,
                //                   child: Text('$gender'),
                //                 ))
                //             .toList(),
                //       ),
                //     ),
                //     Expanded(
                //       flex: 1,
                //       child: FormBuilderDropdown(
                //         name: 'gender',
                //         decoration: customInputDecoration("Filters"),
                //         // initialValue: 'Male',
                //         allowClear: true,
                //
                //         validator: FormBuilderValidators.compose(
                //             [FormBuilderValidators.required(context)]),
                //         items: ["male", "female", "others"]
                //             .map((gender) => DropdownMenuItem(
                //                   value: gender,
                //                   child: Text('$gender'),
                //                 ))
                //             .toList(),
                //       ),
                //     )
                //   ],
                // ),
                _buildOpportunityList(context)
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildListItem(Opportunity item) {
    String coverUrl = "${BASE_URL}${opportunityUploadPath}${item.coverImage}";

    return GestureDetector(
      onTap: () async {
        bool callApi = await shouldMakeApiCall(context);
        if (!callApi) return;
        Navigator.push(
                context,
                new MaterialPageRoute(
                    builder: (context) => OpportunityDetail(
                        item, opportunityUploadPath, widget.currentUser)))
            .then((value) {
          loadUserOpportunitiesData();
        });
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: kMargin20),
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
                    Row(
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
                                      image: AssetImage(kIconLoveWhitePath),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image(
                                      width: 16,
                                      height: 16,
                                      image: AssetImage(kIconLovePath),
                                    ),
                                  ),
                          ),
                          onTap: () async {
                            bool callApi = await shouldMakeApiCall(context);
                            if (!callApi) return;
                            if (userWishes.contains(item.id)) {
                              loadUserOpportunitiesData();
                            } else {
                              _opportunityViewModel.addToWishList(context, item,
                                  () {
                                showDialog(
                                    context: context,
                                    builder: (_) => new AlertDialog(
                                          backgroundColor: Colors.transparent,
                                          contentPadding: EdgeInsets.zero,
                                          content: Builder(
                                            builder: (context) {
                                              // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                              var height =
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height;
                                              var width = MediaQuery.of(context)
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
                                                  padding: const EdgeInsets
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
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                            fontSize: kMargin24,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color:
                                                                kPurpleColor),
                                                      ),
                                                      SizedBox(
                                                        height: 33,
                                                      ),
                                                      Text(
                                                        "Opportunity has been added to your favourties",
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                      SizedBox(
                                                        height: 33,
                                                      ),
                                                      PAButton(
                                                        "Ok",
                                                        true,
                                                        () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        fillColor: kPurpleColor,
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )).then((value) {
                                  loadUserOpportunitiesData();
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
                        item.status == OPPORTUNITY_STATUS_VALUES['Published']
                            ? GestureDetector(
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
                                            image: AssetImage(
                                                kIconAdditionWhitePath),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Image(
                                            width: 16,
                                            height: 16,
                                            image:
                                                AssetImage(kIconAdditionPath),
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
                                      loadUserData();
                                      loadUserOpportunitiesData();
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
                                        loadUserData();
                                        loadUserOpportunitiesData();
                                      });
                                    }, (error) {
                                      EasyLoading.showError(error);
                                    });
                                  }
                                },
                              )
                            : SizedBox()
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
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
}
