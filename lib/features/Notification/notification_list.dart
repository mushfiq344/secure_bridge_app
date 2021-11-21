import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/Models/UserNotification.dart';
import 'package:secure_bridges_app/features/Notification/notifications_view_model.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  NotificationsViewModel _notificationsViewModel = NotificationsViewModel();
  List<UserNotification> notifications = [];
  @override
  void initState() {
    _notificationsViewModel.getNotifications((Map<dynamic, dynamic> body) {
      List<UserNotification> _notifications = List<UserNotification>.from(
          body['data']['notifications']
              .map((i) => UserNotification.fromJson(i)));
      setState(() {
        notifications = _notifications;
      });
    }, (error) {
      EasyLoading.showError(error);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Notifications"),
          backgroundColor: kPurpleColor,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              ...notifications.map((e) {
                return Card(
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
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                              Text(e.message),
                            ],
                          ),
                        ),
                      )
                    ]),
                  ),
                );
              })
            ],
          ),
        ));
  }
}
