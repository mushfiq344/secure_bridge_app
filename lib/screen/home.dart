import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_detail.dart';
import 'package:secure_bridges_app/screen/secure_bridge_web_view.dart';
import 'package:secure_bridges_app/screen/login.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/features/opportunity/opportunities.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/utls/styles.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String name;
  String email;
  String profilePictureUrl;
  List<Opportunity> opportunities = <Opportunity>[];
  List<Opportunity> opportunitiesAll = <Opportunity>[];
  static List<Opportunity> searchedOpportunities = [];
  TextEditingController _searchController = TextEditingController();
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
        name = user['name'];
        email = user['email'];
        profilePictureUrl = user['profile_image'];
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
        print(body);
        await fetchOpportunities(
            body["data"]["max_duration"],
            body["data"]["min_duration"],
            body["data"]["max_reward"],
            body["data"]["min_reward"]);
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(body["message"]);
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }

  fetchOpportunities(int maxDuration, int minDuratin, String maxReward,
      String minReward) async {
    try {
      var data = {
        'duration_high': maxDuration,
        'duration_low': minDuratin,
        'reward_low': minReward,
        'reward_high': maxReward
      };

      var res = await Network().postData(data, FETCH_OPPORTUNITIES_URL);
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : $body");
      if (res.statusCode == 200) {
        List<Opportunity> _opportunities = List<Opportunity>.from(
            body['data']['opportunities'].map((i) => Opportunity.fromJson(i)));

        setState(() {
          opportunities = _opportunities;
          opportunitiesAll = _opportunities;
          searchedOpportunities = _opportunities;
          opportunityUploadPath = body["data"]["upload_path"];
        });
        EasyLoading.dismiss();
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }

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
                builder: (context) =>
                    OpportunityDetail(item, opportunityUploadPath)));
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
                            child: Image(
                              width: 32,
                              height: 32,
                              image: AssetImage(kIconLovePath),
                            ),
                          ),
                          onTap: () {
                            EasyLoading.showToast(kComingSoon);
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
                            child: Image(
                              width: 32,
                              height: 32,
                              image: AssetImage(kIconAdditionPath),
                            ),
                          ),
                          onTap: () {
                            EasyLoading.showToast(kComingSoon);
                          },
                        )
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
      drawer: Drawer(
        elevation: 10.0,
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey.shade500),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  CachedNetworkImage(
                    imageUrl: "${BASE_URL}${profilePictureUrl}",
                    placeholder: (context, url) =>
                        Image(image: AssetImage(kPlaceholderImagePath)),
                    errorWidget: (context, url, error) =>
                        Image(image: AssetImage(kPlaceholderImagePath)),
                    fit: BoxFit.fill,
                    width: 60,
                    height: 60,
                  ),
                  Column(
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
            ListTile(
              leading: Icon(Icons.close),
              title: Text('Close Drawer', style: TextStyle(fontSize: 18)),
              onTap: () {
                // to close drawer programatically..
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: Icon(IconData(0xe3b3, fontFamily: 'MaterialIcons')),
              title: Text('Logout', style: TextStyle(fontSize: 18)),
              onTap: () {
                logout();
              },
            ),
          ],
        ),
      ),
    );
  }

  void logout() async {
    try {
      EasyLoading.show(status: kLoading);
      var res = await Network().postData({}, LOGOUT_URL);
      var body = json.decode(res.body);
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      localStorage.remove('user');
      localStorage.remove('token');
      EasyLoading.dismiss();
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
    } catch (e) {
      EasyLoading.dismiss();
      await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Login()),
        (route) => false,
      );
    }
  }
}
