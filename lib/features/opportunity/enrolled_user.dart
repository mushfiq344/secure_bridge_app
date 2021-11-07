import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/Models/User.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';

class EnrolledOpportunityUser extends StatefulWidget {

  final Opportunity opportunity;
  EnrolledOpportunityUser(this.opportunity);
  @override
  _EnrolledOpportunityUserState createState() => _EnrolledOpportunityUserState();
}

class _EnrolledOpportunityUserState extends State<EnrolledOpportunityUser> {
  List<User> enrolledUsers=[];
  @override
  void initState() {
    super.initState();
    fetchOpportunityUsers(widget.opportunity.id);
  }


  fetchOpportunityUsers(int opportunityId)  async {
    try {
      EasyLoading.show( status: kLoading );
      var data = {
       'id':opportunityId
      };

      var res = await Network().postData(data, FETCH_OPPORTUNITY_USERS_URL);
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : $body");
      if (res.statusCode == 200) {
        List<User> _enrolledUsers = List<User>.from(
            body['data']['opportunity_users'].map((i) => User.fromJson(i)));
        setState(() {
          enrolledUsers=_enrolledUsers;
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kEnrolledUsers),
        backgroundColor: kPurpleColor,

      ),
        body:SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                ...enrolledUsers.map((e){
                  return Card(
                    child: ListTile(
                      title: Text("${e.name} (${e.email}) "),
                      trailing: GestureDetector(
                        child: Icon(Icons.remove_red_eye),
                        onTap: (){

                        },
                      ),
                    ),
                  );
                })
              ],
            ),
          ),
        )
    );
  }
}
