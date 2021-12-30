import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/Models/enrolled_user.dart';
import 'package:secure_bridges_app/features/enrollment/code_check_modal.dart';
import 'package:secure_bridges_app/features/enrollment/enrollment_view_model.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_view_model.dart';
import 'package:secure_bridges_app/features/org_admin/org_admin_home.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:secure_bridges_app/widgets/input_decoration.dart';

class OpportunityHappening extends StatefulWidget {
  final Opportunity opportunity;
  OpportunityHappening(this.opportunity);
  @override
  _OpportunityHappeningState createState() => _OpportunityHappeningState();
}

class _OpportunityHappeningState extends State<OpportunityHappening> {
  int totalRequest = 0;
  int totalConfirm = 0;
  OpportunityViewModel _opportunityViewModel = OpportunityViewModel();
  TextEditingController _searchController = TextEditingController();
  EnrollmentViewModel _enrollmentViewModel = EnrollmentViewModel();
  List<EnrolledUser> enrolledUsers = [];
  List<EnrolledUser> enrolledUsersAll = [];
  List<EnrolledUser> searchedEnrolledUsers = [];
  @override
  void initState() {
    _searchController.addListener(_applySearchOnOpportunityUserList);
    fetchApprovedOpportunityUsers(widget.opportunity.id);
    super.initState();
  }

  fetchApprovedOpportunityUsers(int opportunityId) async {
    _enrollmentViewModel.fetchOpportunityUsers(opportunityId, 1,
        (Map<dynamic, dynamic> body) {
      List<EnrolledUser> _enrolledUsers = List<EnrolledUser>.from(body['data']
              ['opportunity_users']
          .map((i) => EnrolledUser.fromJson(i)));
      int _totalRequest = body['data']['total_request'];
      int _totalConfirm = body['data']['total_confirmed'];
      setState(() {
        _searchController.text = "";
        enrolledUsersAll = _enrolledUsers;
        enrolledUsers = _enrolledUsers;
        totalRequest = _totalRequest;
        totalConfirm = _totalConfirm;
      });
    }, (error) {
      EasyLoading.showError(error);
    });
  }

  void _applySearchOnOpportunityUserList() {
    List<EnrolledUser> _tempSearchedList = [];
    for (EnrolledUser opportunityUser in enrolledUsersAll) {
      if (opportunityUser.profileName != null) {
        if (opportunityUser.profileName
            .toLowerCase()
            .contains(_searchController.text.toLowerCase())) {
          _tempSearchedList.add(opportunityUser);
        }
      } else {
        if (opportunityUser.userName
            .toLowerCase()
            .contains(_searchController.text.toLowerCase())) {
          _tempSearchedList.add(opportunityUser);
        }
      }
    }
    setState(() {
      enrolledUsers = _tempSearchedList;
      searchedEnrolledUsers = _tempSearchedList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kGreyBackgroundColor,
      appBar: AppBar(
        title: Text("Opportunity Happening"),
        backgroundColor: kPurpleColor,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kMargin18),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kMargin10)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kMargin24, vertical: kMargin32),
                  child: Column(
                    children: [
                      Text(
                        "30 Day Activity - Establish a Habit of Daily Journaling",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: kMargin24, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(
                        height: kMargin10,
                      ),
                      Image(image: AssetImage(kQrCodeImagePath)),
                      SizedBox(
                        height: kMargin20,
                      ),
                      PAButton(
                        "enter participant code",
                        true,
                        () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return CodeCheckModal();
                              });
                        },
                        fillColor: kPurpleColor,
                        capitalText: false,
                      ),
                      SizedBox(
                        height: kMargin20,
                      ),
                      Text(
                        "${totalConfirm.toString()}/${totalRequest.toString()} confirmed",
                        style: TextStyle(
                            fontSize: kMargin16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: kMargin24,
              ),
              PAButton(
                "End the Event",
                true,
                () {
                  var data = widget.opportunity.toJson();
                  data['status'] = OPPORTUNITY_STATUS_VALUES['Ended'];
                  _opportunityViewModel.updateOpportunity(data, () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OrgAdminHome()),
                    );
                  });
                },
                fillColor: kPurpleColor,
              ),
              SizedBox(
                height: kMargin24,
              ),
              TextField(
                controller: _searchController,
                decoration: customInputDecoration("search for participant",
                    showPrefixIcon: true, prefixIconPath: kSearchIconPath),
              ),
              SizedBox(
                height: kMargin14,
              ),
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
                              await _enrollmentViewModel
                                  .changeUserOpportunityStatus(e.enrollmentId,
                                      e.userId, e.opportunityId, 3, (success) {
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
                                                        "Participated",
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
                                                        "User participated in the event",
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
                                  fetchApprovedOpportunityUsers(
                                      widget.opportunity.id);
                                });
                              }, (error) {
                                EasyLoading.showError(error);
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
      ),
    );
  }
}
