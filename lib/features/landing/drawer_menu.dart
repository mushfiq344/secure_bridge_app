import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/features/landing/landing_view_model.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_form.dart';
import 'package:secure_bridges_app/features/authentication/login.dart';
import 'package:secure_bridges_app/features/org_admin/org_admin_home.dart';
import 'package:secure_bridges_app/screen/secure_bridge_web_view.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';

class CustomDrawer extends StatelessWidget {
  final String profilePictureUrl;
  final String name;
  final String email;
  final int userType;
  CustomDrawer(this.profilePictureUrl, this.name, this.email, this.userType);
  LandingViewModel _landingViewModel = LandingViewModel();
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
                          imageUrl: "${BASE_URL}${profilePictureUrl}",
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
                        '${name}',
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
            userType == 1
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
                EasyLoading.showToast(kComingSoon);
                // Here you can give your route to navigate
              },
            ),

            userType == 1
                ? ListTile(
                    leading: Image(
                      height: 25,
                      width: 25,
                      image: AssetImage(kOpportunityIconPath),
                    ),
                    title: Text('Create Opportunity',
                        style: TextStyle(
                            fontSize: kMargin22, fontWeight: FontWeight.w400)),
                    onTap: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) =>
                                  OpportunityForm(null, null)));
                      // Here you can give your route to navigate
                    },
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
                        builder: (context) =>
                            SecureBridgeWebView(email, 'forum')));
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
                _landingViewModel.logout(() async {
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
