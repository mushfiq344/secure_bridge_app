import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/Models/User.dart';
import 'package:secure_bridges_app/Models/UserNotification.dart';
import 'package:secure_bridges_app/features/Notification/notifications_view_model.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_detail.dart';
import 'package:secure_bridges_app/network_utils/global_utility.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:secure_bridges_app/widgets/custom_alert_dialogue.dart';

class Notifications extends StatefulWidget {
  final User currentUser;
  Notifications(this.currentUser);
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  NotificationsViewModel _notificationsViewModel = NotificationsViewModel();
  List<UserNotification> notifications = [];
  @override
  void initState() {
    getNotifications();
    super.initState();
  }

  void getNotifications() {
    _notificationsViewModel.getNotifications((Map<dynamic, dynamic> body) {
      List<UserNotification> _notifications = List<UserNotification>.from(
          body['data']['notifications']
              .map((i) => UserNotification.fromJson(i)));
      setState(() {
        notifications = _notifications;
      });
    }, (error) {
      // EasyLoading.showError(error);
      showDialog(
          context: context,
          builder: (_) => CustomAlertDialogue("Login Failed!", error));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Notifications",
            style: TextStyle(color: kPurpleColor),
          ),
          backgroundColor: kAppBarBackgroundColor,
          iconTheme: IconThemeData(color: kPurpleColor),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                ...notifications.map((e) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: kMargin5),
                    child: GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        color: kLightPurpleBackgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [
                            Image(
                              image: AssetImage(e.status == 1
                                  ? kInactiveNotificationIconPath
                                  : kActiveNotificationIconPath),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.title,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    Text(e.message),
                                  ],
                                ),
                              ),
                            )
                          ]),
                        ),
                      ),
                      onTap: () async {
                        bool callApi = await shouldMakeApiCall(context);
                        if (!callApi) return;
                        _notificationsViewModel.getNotificationDetail(e.id,
                            (Map<dynamic, dynamic> body) {
                          if (e.notifiableType == "opportunity") {
                            String opportunityUploadPath =
                                body['data']['upload_path'];
                            if (body['data']['opportunity'] != null) {
                              Opportunity opportunity = Opportunity.fromJson(
                                  body['data']['opportunity']);
                              Navigator.push(
                                  context,
                                  new MaterialPageRoute(
                                      builder: (context) => OpportunityDetail(
                                          opportunity,
                                          opportunityUploadPath,
                                          widget.currentUser))).then((value) {
                                getNotifications();
                              });
                            } else {
                              showDialog(
                                      context: context,
                                      builder: (_) => CustomAlertDialogue(
                                          "Unavailable",
                                          "The opportunity is not available"))
                                  .then((value) {
                                getNotifications();
                              });
                            }
                          }
                          // EasyLoading.showSuccess(success);
                        }, (error) {
                          // EasyLoading.showError(error);
                          showDialog(
                              context: context,
                              builder: (_) =>
                                  CustomAlertDialogue("Error!", error));
                        });
                      },
                    ),
                  );
                })
              ],
            ),
          ),
        ));
  }
}
