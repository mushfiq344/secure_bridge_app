import 'dart:convert';
import 'dart:developer';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/constants.dart';

class ForumViewModel {
  Future<void> getThreads(_onSuccess, _onError) async {
    try {
      EasyLoading.show(status: kLoading);

      // EasyLoading.show(status: kLoading);
      var res = await Network().getData("${FORUM_THREADS_URL}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");

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

  Future<void> getThread(int threadId, _onSuccess, _onError) async {
    try {
      EasyLoading.show(status: kLoading);

      // EasyLoading.show(status: kLoading);
      var res = await Network().getData("${FORUM_THREAD_URL}/${threadId}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");

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

  Future<void> createThread(
      String roomName, String content, _onSuccess, _onError) async {
    try {
      EasyLoading.show(status: kLoading);
      var data = {"title": roomName, 'content': content};
      // EasyLoading.show(status: kLoading);
      var res = await Network().postData(data, "${FORUM_THREADS_URL}");
      var body = json.decode(res.body);

      if (res.statusCode == 201) {
        EasyLoading.dismiss();
        _onSuccess();
      } else {
        EasyLoading.dismiss();
        _onError(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _onError(e.toString());
    }
  }

  Future<void> renameRoom(
      int threadId, String roomName, _onSuccess, _onError) async {
    try {
      EasyLoading.show(status: kLoading);
      var data = {"title": roomName};
      // EasyLoading.show(status: kLoading);
      var res = await Network()
          .postData(data, "${FORUM_THREAD_URL}/${threadId}/rename");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");

      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        _onSuccess();
      } else {
        EasyLoading.dismiss();
        _onError(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _onError(e.toString());
    }
  }

  Future<void> deleteThread(int threadId, _onSuccess, _onError) async {
    try {
      EasyLoading.show(status: kLoading);

      // EasyLoading.show(status: kLoading);
      var res =
          await Network().deleteData({}, "${FORUM_THREAD_URL}/${threadId}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");

      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        _onSuccess();
      } else {
        EasyLoading.dismiss();
        _onError(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _onError(e.toString());
    }
  }

  Future<void> getPosts(int threadId, _onSuccess, _onError) async {
    try {
      EasyLoading.show(status: kLoading);

      // EasyLoading.show(status: kLoading);
      var res =
          await Network().getData("${FORUM_THREAD_URL}/${threadId}/posts");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");

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

  Future<void> getPost(int postId, _onSuccess, _onError) async {
    try {
      EasyLoading.show(status: kLoading);

      // EasyLoading.show(status: kLoading);
      var res = await Network().getData("${FORUM_POST_URL}/${postId}");
      var body = json.decode(res.body);
      log("${res}");

      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        _onSuccess(body);
      } else {
        EasyLoading.dismiss();
        _onError(body['message']);
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      _onError(e.toString());
    }
  }

  Future<void> createPost(
      int threadId, String content, _onSuccess, _onError) async {
    try {
      EasyLoading.show(status: kLoading);
      var data = {"thread_id": threadId, "content": content};
      // EasyLoading.show(status: kLoading);
      var res = await Network()
          .postData(data, "${FORUM_THREAD_URL}/${threadId}/posts");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");

      if (res.statusCode == 201) {
        EasyLoading.dismiss();
        _onSuccess();
      } else {
        EasyLoading.dismiss();
        _onError(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _onError(e.toString());
    }
  }

  Future<void> updatePost(
      int postId, String content, _onSuccess, _onError) async {
    try {
      EasyLoading.show(status: kLoading);
      var data = {"content": content};
      // EasyLoading.show(status: kLoading);
      var res = await Network().patchData(data, "${FORUM_POST_URL}/${postId}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");

      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        _onSuccess();
      } else {
        EasyLoading.dismiss();
        _onError(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _onError(e.toString());
    }
  }

  Future<void> deletePost(int postId, _onSuccess, _onError) async {
    try {
      EasyLoading.show(status: kLoading);

      // EasyLoading.show(status: kLoading);
      var res = await Network().deleteData({}, "${FORUM_POST_URL}/${postId}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");

      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        _onSuccess();
      } else {
        EasyLoading.dismiss();
        _onError(body['message']);
      }
    } catch (e) {
      EasyLoading.dismiss();
      _onError(e.toString());
    }
  }
}
