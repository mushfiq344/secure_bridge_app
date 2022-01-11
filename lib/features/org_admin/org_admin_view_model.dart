import 'dart:convert';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/constants.dart';

class OrgAdminViewModel {
  getOpportunities(_success, _error) async {
    try {
      EasyLoading.show(status: kLoading);
      var res = await Network().getData(ORG_ADMIN_OPPORTUNITIES_URL);
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        _success(body);
      } else {
        EasyLoading.dismiss();
        _error(body["message"]);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _error(e.toString());
    }
  }

  void deleteOpportunity(int id, _success, _error) async {
    try {
      EasyLoading.show(status: kLoading);
      var res =
          await Network().deleteData({}, "$ORG_ADMIN_OPPORTUNITIES_URL/$id");
      print("body ${res.body}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : ${body}");
      if (res.statusCode == 200) {
        EasyLoading.dismiss();

        _success(body["message"]);
      } else {
        EasyLoading.dismiss();
        _error(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _error(e.toString());
    }
  }
}
