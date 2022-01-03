import 'dart:convert';
import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/Models/User.dart';
import 'package:secure_bridges_app/Models/enrolled_user.dart';
import 'package:secure_bridges_app/features/enrollment/enrollment_view_model.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/network_utils/global_utility.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:secure_bridges_app/widgets/custom_alert_dialogue.dart';

import '../opportunity/opportunity_view_model.dart';

class PendingEnrolledOpportunityUser extends StatefulWidget {
  final Opportunity opportunity;
  PendingEnrolledOpportunityUser(this.opportunity);
  @override
  _PendingEnrolledOpportunityUserState createState() =>
      _PendingEnrolledOpportunityUserState();
}

class _PendingEnrolledOpportunityUserState
    extends State<PendingEnrolledOpportunityUser> {
  List<EnrolledUser> enrolledUsers = [];
  EnrollmentViewModel _enrollmentViewModel = EnrollmentViewModel();

  bool userEnrolled = false;
  String userEnrollmentStatus;

  @override
  void initState() {
    super.initState();
    fetchPendingOpportunityUsers(widget.opportunity.id);
  }

  fetchPendingOpportunityUsers(int opportunityId) async {
    Utils.checkInternetAvailability().then((value) {
      if (value) {
        _enrollmentViewModel.fetchOpportunityUsers(opportunityId, 0,
            (Map<dynamic, dynamic> body) {
          List<EnrolledUser> _enrolledUsers = List<EnrolledUser>.from(
              body['data']['opportunity_users']
                  .map((i) => EnrolledUser.fromJson(i)));
          setState(() {
            enrolledUsers = _enrolledUsers;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('pending Requests'),
          backgroundColor: kPurpleColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ...enrolledUsers.map((e) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(kMargin10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            flex: 1,
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "${BASE_URL}uploads/images/profiles/${e.userPhoto}",
                                  placeholder: (context, url) => Image(
                                      image: AssetImage(kPlaceholderImagePath)),
                                  errorWidget: (context, url, error) => Image(
                                      image: AssetImage(kPlaceholderImagePath)),
                                  fit: BoxFit.fill,
                                  height: 70,
                                  width: 70,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Padding(
                              padding: const EdgeInsets.only(left: kMargin32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${e.profileName ?? e.userName}",
                                    style: TextStyle(
                                        fontSize: kMargin16,
                                        fontWeight: FontWeight.bold,
                                        color: kPurpleColor),
                                  ),
                                  Text(
                                    "${e.userAddress ?? ""}",
                                    style: TextStyle(
                                        fontSize: kMargin12,
                                        fontWeight: FontWeight.bold,
                                        color: kLightPurpleBackgroundColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              child: Image(
                                image: AssetImage(kEnrollmentIconPath),
                              ),
                              onTap: () async {
                                bool callApi = await shouldMakeApiCall(context);
                                if (!callApi) return;
                                await _enrollmentViewModel
                                    .changeUserOpportunityStatus(
                                        e.enrollmentId,
                                        e.userId,
                                        e.opportunityId,
                                        1, (success) {
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
                                                          "Approved",
                                                          textAlign:
                                                              TextAlign.center,
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
                                                          "User has been approved",
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
                                    fetchPendingOpportunityUsers(
                                        widget.opportunity.id);
                                  });
                                }, (error) {
                                  showDialog(
                                      context: context,
                                      builder: (_) =>
                                          CustomAlertDialogue("Error!", error));
                                  // EasyLoading.showError(error);
                                });
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
        ));
  }
}
