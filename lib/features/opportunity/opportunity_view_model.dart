import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';

class OpportunityViewModel {
  void getOpportunityDetail(int oppurtunityId, _onSuccess, _onError) async {
    try {
      EasyLoading.show(status: kLoading);

      // EasyLoading.show(status: kLoading);
      var res =
          await Network().getData("${OPPORTUNITIES_URL}/${oppurtunityId}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : ${body}");
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        _onSuccess(body);
      } else {
        EasyLoading.dismiss();
        _onError(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _onError(e.toString());
    }
  }

  Future<Map<String, dynamic>> getUserOpportunityRelatedDetail(
      int oppurtunityId, int userId) async {
    try {
      EasyLoading.show(status: kLoading);
      var data = {'opportunity_id': oppurtunityId, 'user_id': userId};
      print('data $data');
      // EasyLoading.show(status: kLoading);
      var res = await Network()
          .postData(data, "${USER_OPPORTUNITY_RELATED_INFO_URL}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("bodyssss : ${body}");
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        return Future.value(body);
      } else {
        EasyLoading.dismiss();
      }
    } catch (e) {
      EasyLoading.dismiss();
    }
  }

  void enrollUser(BuildContext context, opportunity, _success, _error) async {
    try {
      EasyLoading.show(status: kLoading);
      var res = await Network()
          .postData({'opportunity_id': opportunity.id}, CHOICE_LIST_URL);
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : ${body}");
      if (res.statusCode == 201) {
        EasyLoading.dismiss();
        // _loadOpportunitiesStats();
        _success();
      } else {
        EasyLoading.dismiss();
        _error(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _error(e.toString());
    }
  }

  void removeFromEnrollments(
      BuildContext context, Opportunity opportunity, _success, _error) async {
    try {
      EasyLoading.show(status: kLoading);
      var res = await Network().deleteData({'opportunity_id': opportunity.id},
          "${CHOICE_LIST_URL}/${opportunity.id}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body remove : ${body}");
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

  void addToWishList(
      BuildContext context, Opportunity opportunity, _success, _error) async {
    try {
      EasyLoading.show(status: kLoading);
      var res = await Network()
          .postData({'opportunity_id': opportunity.id}, WISH_LIST_URL);
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : ${body}");
      if (res.statusCode == 201) {
        EasyLoading.dismiss();
        _success();
      } else {
        EasyLoading.dismiss();
        _error(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _error(e.toString());
    }
  }

  removeFromWithList(
      BuildContext context, Opportunity opportunity, _success, _error) async {
    try {
      EasyLoading.show(status: kLoading);
      var res =
          await Network().deleteData({}, "${WISH_LIST_URL}/${opportunity.id}");
      var body = json.decode(res.body);

      if (res.statusCode == 200) {
        print(body);
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

  updateOpportunity(Map<String, dynamic> data, _success) async {
    try {
      log("data $data");

      EasyLoading.show(status: kLoading);
      var res = await Network()
          .putData(data, "$ORG_ADMIN_OPPORTUNITIES_URL/${data['id']}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : ${body}");
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        _success();
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }
}
