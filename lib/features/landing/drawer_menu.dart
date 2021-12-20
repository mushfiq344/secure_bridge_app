import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:secure_bridges_app/Models/User.dart';
import 'package:secure_bridges_app/features/authentication/authentication_view_model.dart';
import 'package:secure_bridges_app/features/landing/landing_view_model.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_form.dart';
import 'package:secure_bridges_app/features/authentication/login.dart';
import 'package:secure_bridges_app/features/org_admin/my_opportunity.dart';
import 'package:secure_bridges_app/features/org_admin/org_admin_home.dart';

import 'package:secure_bridges_app/features/payment/payment_home.dart';
import 'package:secure_bridges_app/features/profile/profile_form.dart';
import 'package:secure_bridges_app/features/subscriptions/plans_list.dart';
import 'package:secure_bridges_app/features/user/user_home.dart';
import 'package:secure_bridges_app/features/user/user_view_model.dart';
import 'package:secure_bridges_app/screen/secure_bridge_web_view.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';

class CustomDrawer extends StatefulWidget {
  final User currentUser;

  CustomDrawer(this.currentUser);

  @override
  _CustomDrawerState createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  LandingViewModel _landingViewModel = LandingViewModel();
  AuthenticationViewModel _authenticationViewModel = AuthenticationViewModel();
  UserViewModel _userViewModel = UserViewModel();
  bool hasPermissionToCreate = false;
  int userType;
  int profileImage;

  @override
  void initState() {
    loadUserData();
    super.initState();
  }

  @override
  update(Observable observable, String notifyName, Map map) {
    ///do your work
    loadUserData();
  }

  void loadUserData() {
    _userViewModel.loadUserData((Map<String, dynamic> userJson) {
      if (userJson['has_create_opportunity_permission'] == true) {
        setState(() {
          hasPermissionToCreate = true;
        });
      } else {
        hasPermissionToCreate = false;
      }
    }, (error) {
      EasyLoading.showError(error);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 10.0,
      child: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: CachedNetworkImage(
                          imageUrl:
                              "${BASE_URL}${widget.currentUser.profileImage}",
                          placeholder: (context, url) =>
                              Image(image: AssetImage(kPlaceholderImagePath)),
                          errorWidget: (context, url, error) =>
                              Image(image: AssetImage(kPlaceholderImagePath)),
                          fit: BoxFit.fill,
                          width: 88,
                          height: 88,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding: const EdgeInsets.only(left: kMargin8),
                      child: Text(
                        '${widget.currentUser.name}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: kMargin18),
                      ),
                    ),
                  ),
                  Image(
                      width: 19,
                      height: 27,
                      image: AssetImage(kRightArrowIconPath))
                ],
              ),
            ),
            widget.currentUser.userType == 1
                ? ListTile(
                    leading: Image(
                      height: 25,
                      width: 25,
                      image: AssetImage(kHomeIconPath),
                    ),
                    title: Text('Home',
                        style: TextStyle(
                            fontSize: kMargin22, fontWeight: FontWeight.w400)),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => OrgAdminHome()));
                      // Here you can give your route to navigate
                    },
                  )
                : SizedBox(),

            //Here you place your menu items
            ListTile(
              leading: Image(
                height: 25,
                width: 25,
                image: AssetImage(kProfileIconPath),
              ),
              title: Text('Profile',
                  style: TextStyle(
                      fontSize: kMargin22, fontWeight: FontWeight.w400)),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => ProfileForm()));
                // Here you can give your route to navigate
              },
            ),
            widget.currentUser.userType == 0
                ? ListTile(
                    leading: Image(
                      height: 25,
                      width: 25,
                      image: AssetImage(kHomeIconPath),
                    ),
                    title: Text('Home',
                        style: TextStyle(
                            fontSize: kMargin22, fontWeight: FontWeight.w400)),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  UserHome(widget.currentUser))).then((value) {
                        Observable.instance.notifyObservers([
                          "_HomeState",
                        ], notifyName: "可以通过notifyName判断通知");
                      });
                      // Here you can give your route to navigate
                    },
                  )
                : SizedBox(),

            widget.currentUser.userType == 1
                ? Column(
                    children: [
                      hasPermissionToCreate == true
                          ? ListTile(
                              leading: Image(
                                height: 25,
                                width: 25,
                                image: AssetImage(kOpportunityIconPath),
                              ),
                              title: Text('Create Opportunity',
                                  style: TextStyle(
                                      fontSize: kMargin22,
                                      fontWeight: FontWeight.w400)),
                              onTap: () {
                                Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            builder: (context) =>
                                                OpportunityForm(null, null)))
                                    .then((value) {
                                  if (value != null) {
                                    if (value) {
                                      Observable.instance.notifyObservers([
                                        "_HomeState",
                                      ], notifyName: "可以通过notifyName判断通知");
                                    }
                                  }
                                });
                                // Here you can give your route to navigate
                              },
                            )
                          : ListTile(
                              leading: Image(
                                height: 25,
                                width: 25,
                                image: AssetImage(kOpportunityIconPath),
                              ),
                              title: Text('Subscriptions',
                                  style: TextStyle(
                                      fontSize: kMargin22,
                                      fontWeight: FontWeight.w400)),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        //builder: (context) => PaymentHome()
                                        builder: (context) => PlansList(
                                              currentUser: widget.currentUser,
                                              isRegistering: false,
                                            ))).then((value) {
                                  loadUserData();
                                });
                                // Here you can give your route to navigate
                              },
                            ),
                      ListTile(
                        leading: Image(
                          height: 25,
                          width: 25,
                          image: AssetImage(kOpportunityIconPath),
                        ),
                        title: Text('My Opportunity',
                            style: TextStyle(
                                fontSize: kMargin22,
                                fontWeight: FontWeight.w400)),
                        onTap: () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  //builder: (context) => PaymentHome()
                                  builder: (context) => MyOpportunity()));
                          // Here you can give your route to navigate
                        },
                      )
                    ],
                  )
                : SizedBox(),

            ListTile(
              leading: Image(
                height: kMargin25,
                width: kMargin25,
                image: AssetImage(kSettingsIconPath),
              ),
              title: Text('Settings',
                  style: TextStyle(
                      fontSize: kMargin22, fontWeight: FontWeight.w400)),
              onTap: () {
                EasyLoading.showToast("Coming Soon!");
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.settings),
            //   title: Text('Chatting', style: TextStyle(fontSize: 18)),
            //   onTap: () {
            //     Navigator.push(
            //         context,
            //         new MaterialPageRoute(
            //             builder: (context) =>
            //                 SecureBridgeWebView(email, 'chatting')));
            //   },
            // ),
            ListTile(
              leading: Image(image: AssetImage(kCommunityIconPath)),
              title: Text('Forum',
                  style: TextStyle(
                      fontSize: kMargin22, fontWeight: FontWeight.w400)),
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (context) => SecureBridgeWebView(
                            widget.currentUser.email, 'forum')));
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.close),
            //   title: Text('Close Drawer', style: TextStyle(fontSize: 18)),
            //   onTap: () {
            //     // to close drawer programatically..
            //     Navigator.of(context).pop();
            //   },
            // ),
            ListTile(
              leading: Icon(
                IconData(0xe3b3, fontFamily: 'MaterialIcons'),
                color: Colors.black,
                size: kMargin25,
              ),
              title: Text('Logout',
                  style: TextStyle(
                      fontSize: kMargin22, fontWeight: FontWeight.w400)),
              onTap: () {
                _authenticationViewModel.logout(() async {
                  await Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                    (route) => false,
                  );
                }, () {});
              },
            ),
          ],
        ),
      ),
    );
  }
}
