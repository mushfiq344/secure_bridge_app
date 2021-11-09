import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/features/landing/landing_view_model.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_form.dart';
import 'package:secure_bridges_app/screen/login.dart';
import 'package:secure_bridges_app/screen/secure_bridge_web_view.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';

class CustomDrawer extends StatelessWidget {
  final String profilePictureUrl;
  final String name;
  final String email;
  final int userType;
  CustomDrawer(this.profilePictureUrl,this.name,this.email,this.userType);
  LandingViewModel _landingViewModel=LandingViewModel();
  @override
  Widget build(BuildContext context) {
return Drawer(
  elevation: 10.0,
  child: ListView(
    children: <Widget>[
      DrawerHeader(
        decoration: BoxDecoration(color: Colors.grey.shade500),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              flex:1,
              child: CachedNetworkImage(
                imageUrl: "${BASE_URL}${profilePictureUrl}",
                placeholder: (context, url) =>
                    Image(image: AssetImage(kPlaceholderImagePath)),
                errorWidget: (context, url, error) =>
                    Image(image: AssetImage(kPlaceholderImagePath)),
                fit: BoxFit.fill,
                width: 60,
                height: 60,
              ),
            ),
            Expanded(
              flex:3,
              child: Padding(
                padding: const EdgeInsets.only(left: kMargin8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      '${name}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 25.0),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      '${email}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 14.0),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),

      //Here you place your menu items
      ListTile(
        leading: Icon(Icons.home),
        title: Text('Profile', style: TextStyle(fontSize: 18)),
        onTap: () {
          EasyLoading.showToast("Coming Soon!");
          // Here you can give your route to navigate
        },
      ),
      Divider(height: 3.0),
      userType == 1
          ? ListTile(
        leading: Icon(Icons.home),
        title: Text('Create Opportunity',
            style: TextStyle(fontSize: 18)),
        onTap: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => OpportunityForm(null,null)));
          // Here you can give your route to navigate
        },
      )
          : SizedBox(),

      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Settings', style: TextStyle(fontSize: 18)),
        onTap: () {
          EasyLoading.showToast("Coming Soon!");
        },
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Chatting', style: TextStyle(fontSize: 18)),
        onTap: () {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) =>
                      SecureBridgeWebView(email, 'chatting')));
        },
      ),
      ListTile(
        leading: Icon(Icons.settings),
        title: Text('Forum', style: TextStyle(fontSize: 18)),
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
        leading: Icon(IconData(0xe3b3, fontFamily: 'MaterialIcons')),
        title: Text('Logout', style: TextStyle(fontSize: 18)),
        onTap: () {
          _landingViewModel.logout(()async {
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
);
  }
}
