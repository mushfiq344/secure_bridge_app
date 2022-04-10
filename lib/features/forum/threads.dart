import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/Models/User.dart';
import 'package:secure_bridges_app/Models/forum_thread.dart';
import 'package:secure_bridges_app/features/forum/forum_view_model.dart';
import 'package:secure_bridges_app/features/forum/posts.dart';
import 'package:secure_bridges_app/features/forum/room.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:secure_bridges_app/widgets/custom_alert_dialogue.dart';

class Threads extends StatefulWidget {
  final User currentUser;
  Threads({this.currentUser});
  @override
  _ThreadsState createState() => _ThreadsState();
}

class _ThreadsState extends State<Threads> {
  List<ForumThread> threads = [];
  ForumViewModel _forumViewModel = ForumViewModel();
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  initState() {
    super.initState();
    getThreads();
  }

  void getThreads() {
    _forumViewModel.getThreads((Map<String, dynamic> body) {
      List<ForumThread> _threads = List<ForumThread>.from(
          body['data'].map((i) => ForumThread.fromJson(i)));
      log("${_threads.length}");
      setState(() {
        threads = _threads;
      });
    }, (String error) {
      showDialog(
          context: context,
          builder: (_) => CustomAlertDialogue("Error!", error));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Threads",
          style: TextStyle(color: kPurpleColor),
        ),
        backgroundColor: kAppBarBackgroundColor,
        iconTheme: IconThemeData(color: kPurpleColor),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          ...threads.map((e) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(flex: 1, child: Center(child: Text(e.title))),
                  e.authorId == widget.currentUser.id
                      ? Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PAButton(
                              'Edit',
                              true,
                              () {
                                Navigator.push(
                                    context,
                                    new MaterialPageRoute(
                                        // builder: (context) => SecureBridgeWebView(
                                        //     widget.currentUser.email, 'forum')
                                        builder: (context) => ForumRoom(
                                              e,
                                            ))).then((value) {
                                  getThreads();
                                });
                              },
                              fillColor: kPurpleColor,
                              hMargin: 0,
                            ),
                          ),
                        )
                      : SizedBox(),
                  e.authorId == widget.currentUser.id
                      ? Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: PAButton(
                              'Delete',
                              true,
                              () {
                                _forumViewModel.deleteThread(e.id, () {
                                  getThreads();
                                }, (error) {
                                  showDialog(
                                      context: context,
                                      builder: (_) =>
                                          CustomAlertDialogue("Error!", error));
                                });
                              },
                              fillColor: kPurpleColor,
                              hMargin: 0,
                            ),
                          ),
                        )
                      : SizedBox(),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PAButton(
                        'Posts',
                        true,
                        () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  // builder: (context) => SecureBridgeWebView(
                                  //     widget.currentUser.email, 'forum')
                                  builder: (context) =>
                                      ForumPosts(widget.currentUser, e))).then(
                              (value) {
                            getThreads();
                          });
                        },
                        fillColor: kPurpleColor,
                        hMargin: 0,
                      ),
                    ),
                  )
                ],
              ),
            );
          }),
          PAButton(
            'Create Thread',
            true,
            () {
              Navigator.push(
                  context,
                  new MaterialPageRoute(
                      // builder: (context) => SecureBridgeWebView(
                      //     widget.currentUser.email, 'forum')
                      builder: (context) => ForumRoom(
                            null,
                          ))).then((value) {
                getThreads();
              });
            },
            fillColor: kPurpleColor,
          )
        ],
      )),
    );
  }
}
