import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/features/opportunity/enrolled_user.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_view_model.dart';
import 'package:secure_bridges_app/features/authentication/login.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/utls/styles.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class OpportunityDetail extends StatefulWidget {
  final Opportunity opportunity;
  final String uploadPath;
  final userId;
  final int userType;

  OpportunityDetail(
      this.opportunity, this.uploadPath, this.userId, this.userType);
  @override
  _OpportunityDetailState createState() => _OpportunityDetailState();
}

class _OpportunityDetailState extends State<OpportunityDetail> {
  OpportunityViewModel _opportunityViewModel = OpportunityViewModel();
  bool userEnrolled = false;
  bool inUserWithList = false;
  String userEnrollmentStatus;
  int userCode;
  final TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String code;
  @override
  initState() {
    super.initState();
    loadOpportunityDetail();
  }

  void loadOpportunityDetail() {
    _opportunityViewModel.getOpportunityDetail(widget.opportunity.id,
        (Map<String, dynamic> body) {
      log("body model $body");
      setState(() {
        userEnrolled = body['data']['is_user_enrolled'];
        inUserWithList = body['data']['in_user_wish_list'];
        userCode = body['data']['user_code'];
        userEnrollmentStatus = body['data']['enrollment_status'];
      });
    }, (error) {
      EasyLoading.showError(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kOpportunities),
        backgroundColor: kPurpleColor,
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: AspectRatio(
                  aspectRatio: 1 / .5,
                  child: ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl:
                          "${BASE_URL}${widget.uploadPath}${widget.opportunity.coverImage}",
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
              padding: EdgeInsets.symmetric(
                  vertical: kMargin12, horizontal: kMargin12),
              child: Column(
                children: [
                  SizedBox(
                    height: kMargin12,
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Center(
                              child: Text(widget.opportunity.title,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: kMargin24))))
                    ],
                  ),
                  SizedBox(
                    height: kMargin12,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Card(
                            color: kPurpleBackGround,
                            child: Row(
                              children: [
                                Container(
                                    child: Image(
                                  width: 50,
                                  height: 50,
                                  image: AssetImage(kIconRewardPath),
                                )),
                                Padding(
                                  padding: EdgeInsets.only(left: kMargin4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Offered By",
                                        style: TextStyle(
                                            fontSize: kMargin12,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "${widget.opportunity.createdBy.name}",
                                        style: TextStyle(
                                            fontSize: kMargin12,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Card(
                            color: kPurpleBackGround,
                            child: Row(
                              children: [
                                Container(
                                    child: Image(
                                  width: 50,
                                  height: 50,
                                  image: AssetImage(kIconRewardPath),
                                )),
                                Padding(
                                  padding: EdgeInsets.only(left: kMargin4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Reward",
                                        style: TextStyle(
                                            fontSize: kMargin12,
                                            color: Colors.white),
                                      ),
                                      Text("${widget.opportunity.reward}\$",
                                          style: TextStyle(
                                              fontSize: kMargin12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: kMargin12,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: Card(
                            color: kPurpleBackGround,
                            child: Row(
                              children: [
                                Container(
                                    child: Image(
                                  width: 50,
                                  height: 50,
                                  image: AssetImage(kIconCalenderPath),
                                )),
                                Padding(
                                  padding: EdgeInsets.only(left: kMargin4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Date",
                                        style: TextStyle(
                                            fontSize: kMargin12,
                                            color: Colors.white),
                                      ),
                                      Text(
                                          "${widget.opportunity.opportunityDate}",
                                          style: TextStyle(
                                              fontSize: kMargin12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: Card(
                            color: kPurpleBackGround,
                            child: Row(
                              children: [
                                Container(
                                    child: Image(
                                  width: 50,
                                  height: 50,
                                  image: AssetImage(kIconLocationPath),
                                )),
                                Padding(
                                  padding: EdgeInsets.only(left: kMargin4),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Location",
                                        style: TextStyle(
                                            fontSize: kMargin12,
                                            color: Colors.white),
                                      ),
                                      Text(
                                          "${widget.opportunity.location ?? ''}",
                                          style: TextStyle(
                                              fontSize: kMargin12,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold))
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: kMargin12,
                  ),
                  userEnrolled && userEnrollmentStatus == kApproved
                      ? Container(
                          child: Card(
                          color: kOrangeBackgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.all(17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    text: "PARTICIPATION CODE:",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: kMargin14,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: " ${userCode}",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: kMargin14,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  child: Icon(
                                    Icons.copy,
                                    color: Colors.white,
                                  ),
                                  onTap: () {
                                    Clipboard.setData(
                                        ClipboardData(text: "$userCode"));

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content: Text("Copied to clipboard!"),
                                    ));
                                  },
                                )
                              ],
                            ),
                          ),
                        ))
                      : SizedBox(),
                  userEnrolled && userEnrollmentStatus == kParticipated
                      ? Container(
                          child: Card(
                          color: kOrangeBackgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.all(17),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "Event Is Over: Processing Reward",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: kMargin14,
                                      color: Colors.white),
                                )
                              ],
                            ),
                          ),
                        ))
                      : SizedBox(),
                  SizedBox(
                    height: kMargin10,
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: PAButton(
                                  "habits",
                                  true,
                                  () {
                                    EasyLoading.showToast(kComingSoon);
                                  },
                                  fillColor: kGreyBackgroundColor,
                                  textColor: kLabelColor,
                                  capitalText: false,
                                  hMargin: 5,
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: PAButton(
                                  "productivity",
                                  true,
                                  () {
                                    EasyLoading.showToast(kComingSoon);
                                  },
                                  fillColor: kGreyBackgroundColor,
                                  textColor: kLabelColor,
                                  capitalText: false,
                                  hMargin: 5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: SizedBox(),
                          flex: 1,
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: kMargin24,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kMargin22),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Heighlights",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: kMargin14,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: kMargin16,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: kMargin22),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${widget.opportunity.description}",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: kMargin12,
                                fontWeight: FontWeight.w400,
                                color: kInactiveColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: kMargin24,
                  ),
                  widget.userType == 0
                      ? GestureDetector(
                          child: Container(
                              child: Card(
                                  color: inUserWithList
                                      ? kLightPurpleBackgroundColor
                                      : kPurpleBackGround,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: kMargin16),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Image(
                                          image: AssetImage(kIconLoveWhitePath),
                                        ),
                                        SizedBox(
                                          width: kMargin10,
                                        ),
                                        Text(
                                          inUserWithList
                                              ? "remove from favourites"
                                              : "add to favourite",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: kMargin14),
                                        ),
                                      ],
                                    ),
                                  ))),
                          onTap: () {
                            if (!inUserWithList) {
                              _opportunityViewModel.addToWishList(
                                  context, widget.opportunity, () {
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
                                  loadOpportunityDetail();
                                });
                              }, (error) {
                                EasyLoading.showError(error);
                              });
                            } else {
                              _opportunityViewModel.removeFromWithList(
                                  context, widget.opportunity, (success) {
                                loadOpportunityDetail();
                              }, (error) {
                                EasyLoading.showError(error);
                              });
                            }
                          },
                        )
                      : SizedBox(),
                  Container(
                    child: Row(
                      children: [
                        userEnrolled
                            ? Expanded(
                                flex: 1,
                                child: userEnrollmentStatus != kApproved
                                    ? Center(
                                        child: showStatus(
                                            context, userEnrollmentStatus))
                                    : SizedBox(),
                              )
                            : Expanded(
                                flex: 1,
                                child: widget.userType == 0
                                    ? GestureDetector(
                                        child: Card(
                                            color: kPurpleColor,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: kMargin16),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Image(
                                                      image: AssetImage(
                                                          kIconAdditionWhitePath)),
                                                  SizedBox(
                                                    width: kMargin10,
                                                  ),
                                                  Text(
                                                    "Enroll",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: kMargin14),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        onTap: () {
                                          _opportunityViewModel.enrollUser(
                                              context, widget.opportunity, () {
                                            showDialog(
                                                context: context,
                                                builder: (_) => new AlertDialog(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      contentPadding:
                                                          EdgeInsets.zero,
                                                      content: Builder(
                                                        builder: (context) {
                                                          // Get available height and width of the build area of this widget. Make a choice depending on the size.
                                                          var height =
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height;
                                                          var width =
                                                              MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width;

                                                          return Container(
                                                            decoration: BoxDecoration(
                                                                color:
                                                                    kAlertDialogBackgroundColor,
                                                                borderRadius: BorderRadius
                                                                    .all(Radius
                                                                        .circular(
                                                                            20.0))),
                                                            height: height * .5,
                                                            width: width * .75,
                                                            child: Padding(
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  vertical: 50,
                                                                  horizontal:
                                                                      30),
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
                                              loadOpportunityDetail();
                                            });
                                          }, (error) {
                                            EasyLoading.showError(error);
                                          });
                                        },
                                      )
                                    : SizedBox()),
                      ],
                    ),
                  ),
                  if (widget.userId == widget.opportunity.createdBy.id)
                    Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: PAButton("View Enrolled User", true, () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        builder: (context) =>
                                            EnrolledOpportunityUser(
                                                this.widget.opportunity)));
                              },
                                  fillColor: kGreyBackgroundColor,
                                  textColor: Colors.orange,
                                  capitalText: false),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: PAButton("Test Code", true, () {
                                showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: Form(
                                          key: _formKey,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: TextFormField(
                                                  style: TextStyle(
                                                      color: Color(0xFF000000)),
                                                  cursorColor:
                                                      Color(0xFF9b9b9b),
                                                  keyboardType:
                                                      TextInputType.text,
                                                  decoration: InputDecoration(
                                                    prefixIcon: Icon(
                                                      Icons.approval,
                                                      color: Colors.grey,
                                                    ),
                                                    hintText: "Code",
                                                    hintStyle: TextStyle(
                                                        color:
                                                            Color(0xFF9b9b9b),
                                                        fontSize: 15,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                  validator: (codeValue) {
                                                    if (codeValue.isEmpty) {
                                                      return 'Please enter code';
                                                    }
                                                    code = codeValue;
                                                    return null;
                                                  },
                                                ),
                                              ),
                                              PAButton(
                                                'Check',
                                                true,
                                                () {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    _confirmUser(
                                                        widget.opportunity.id,
                                                        code);
                                                  }
                                                },
                                                fillColor: kGreyBackgroundColor,
                                                textColor: Colors.orange,
                                                capitalText: false,
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    });
                              },
                                  fillColor: kGreyBackgroundColor,
                                  textColor: Colors.orange,
                                  capitalText: false),
                            ),
                          ],
                        ),
                      ],
                    )
                  else
                    SizedBox()
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _confirmUser(int opportunityId, String code) async {
    try {
      var data = {'opportunity_id': opportunityId, 'code': code};
      EasyLoading.show(status: kLoading);
      var res = await Network().postData(data, 'api/check-enrollment');
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      // log("body : ${body}");
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        if (body['data']['user_is_enrolled']) {
          EasyLoading.showSuccess("This Code Is Valid");
        } else {
          EasyLoading.showError("This Code Is invalid");
        }
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }

  Widget showStatus(BuildContext context, String status) {
    Widget response = Text(" ");
    if (status == kRequested) {
      response = GestureDetector(
        child: Card(
            color: kInactiveColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: kMargin16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(image: AssetImage(kIconAdditionWhitePath)),
                  SizedBox(
                    width: kMargin10,
                  ),
                  Text(
                    "pending approval",
                    style: TextStyle(color: Colors.white, fontSize: kMargin14),
                  ),
                ],
              ),
            )),
        onTap: () {
          _opportunityViewModel
              .removeFromEnrollments(context, widget.opportunity, (success) {
            loadOpportunityDetail();
          }, (error) {
            EasyLoading.showError(error);
          });
        },
      );
    }
    if (status == kParticipated) {
      return SizedBox();
    }
    if (status == kRewarded) {
      return SizedBox();
    }
    return response;
  }
}
