import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secure_bridges_app/Models/User.dart';
import 'package:secure_bridges_app/Models/forum_post.dart';
import 'package:secure_bridges_app/Models/forum_thread.dart';
import 'package:secure_bridges_app/features/forum/forum_view_model.dart';
import 'package:secure_bridges_app/features/forum/post.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:secure_bridges_app/widgets/custom_alert_dialogue.dart';

class ForumPosts extends StatefulWidget {
  final ForumThread forumThread;
  final User currentUser;
  ForumPosts(this.currentUser, this.forumThread);
  @override
  _ForumPostsState createState() => _ForumPostsState();
}

class _ForumPostsState extends State<ForumPosts> {
  ForumViewModel _forumViewModel = ForumViewModel();
  List<ForumPost> forumPosts = [];
  @override
  void initState() {
    getPosts();
    super.initState();
  }

  void getPosts() {
    _forumViewModel.getPosts(widget.forumThread.id,
        (Map<String, dynamic> body) {
      List<ForumPost> _forumPosts =
          List<ForumPost>.from(body['data'].map((i) => ForumPost.fromJson(i)));
      setState(() {
        forumPosts = _forumPosts;
      });
    }, (error) {
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
          "${widget.forumThread.title} Posts",
          style: TextStyle(color: kPurpleColor),
        ),
        backgroundColor: kAppBarBackgroundColor,
        iconTheme: IconThemeData(color: kPurpleColor),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ...forumPosts.map((e) {
              return Column(
                children: [
                  Center(
                    child: Text(e.content),
                  ),
                  widget.currentUser.id == e.authorId
                      ? Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: SizedBox(),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PAButton(
                                  'Update',
                                  true,
                                  () {
                                    Navigator.push(
                                        context,
                                        new MaterialPageRoute(
                                            // builder: (context) => SecureBridgeWebView(
                                            //     widget.currentUser.email, 'forum')
                                            builder: (context) => ForumPostView(
                                                widget.forumThread, e))).then(
                                        (value) {
                                      getPosts();
                                    });
                                  },
                                  fillColor: kPurpleColor,
                                  hMargin: 0,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: PAButton(
                                  'Delete',
                                  true,
                                  () {
                                    _forumViewModel.deletePost(e.id, () {
                                      getPosts();
                                    }, (error) {
                                      showDialog(
                                          context: context,
                                          builder: (_) => CustomAlertDialogue(
                                              "Error!", error));
                                    });
                                  },
                                  fillColor: kPurpleColor,
                                  hMargin: 0,
                                ),
                              ),
                            )
                          ],
                        )
                      : SizedBox()
                ],
              );
            }),
            SizedBox(
              height: 10,
            ),
            PAButton(
              'Create Post',
              true,
              () {
                Navigator.push(
                        context,
                        new MaterialPageRoute(
                            // builder: (context) => SecureBridgeWebView(
                            //     widget.currentUser.email, 'forum')
                            builder: (context) =>
                                ForumPostView(widget.forumThread, null)))
                    .then((value) {
                  getPosts();
                });
              },
              fillColor: kPurpleColor,
            )
          ],
        ),
      ),
    );
  }
}
