import 'dart:convert';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/Models/enrolled_user.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/constants.dart';

class EnrollmentViewModel {
  void changeUserOpportunityStatus(int enrollmentId, int userId, opportunityId,
      int updatedStatus, _success, _error) async {
    try {
      EasyLoading.show(status: kLoading);
      var data = {
        'opportunity_id': opportunityId,
        'user_id': userId,
        'updated_status': updatedStatus
      };
      // EasyLoading.show(status: kLoading);
      var res = await Network().putData(
          data, "${USER_OPPORTUNITIES_URL}/${enrollmentId.toString()}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : ${body}");
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        _success(body["messaage"]);
      } else {
        EasyLoading.dismiss();
        _error(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _error(e.toString());
    }
  }

  fetchOpportunityUsers(
      int opportunityId, int enrollmentType, _success, _error) async {
    try {
      EasyLoading.show(status: kLoading);
      var data = {'id': opportunityId, 'status': enrollmentType};

      var res = await Network().postData(data, FETCH_OPPORTUNITY_USERS_URL);
      var body = json.decode(res.body);
      log("res ${body}");

      if (res.statusCode == 200) {
        _success(body);
        EasyLoading.dismiss();
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
