import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:secure_bridges_app/Models/User.dart';
import 'package:secure_bridges_app/Models/forum_post.dart';
import 'package:secure_bridges_app/Models/forum_thread.dart';
import 'package:secure_bridges_app/features/forum/forum_view_model.dart';
import 'package:secure_bridges_app/network_utils/global_utility.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:secure_bridges_app/widgets/custom_alert_dialogue.dart';
import 'package:secure_bridges_app/widgets/input_decoration.dart';

class ForumPostView extends StatefulWidget {
  final ForumPost forumPost;
  final ForumThread parentThread;
  ForumPostView(this.parentThread, this.forumPost);
  @override
  _ForumPostViewState createState() => _ForumPostViewState();
}

class _ForumPostViewState extends State<ForumPostView> {
  final TextEditingController contentController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  ForumViewModel _forumViewModel = ForumViewModel();
  ForumPost forumPost;
  void initState() {
    if (widget.forumPost != null) {
      // TODO: implement initState
      _forumViewModel.getPost(widget.forumPost.id, (Map<String, dynamic> body) {
        ForumPost _forumPost = ForumPost.fromJson(body['data']);
        setState(() {
          forumPost = _forumPost;
          contentController.text = _forumPost.content;
        });
      }, (error) {
        showDialog(
            context: context,
            builder: (_) => CustomAlertDialogue("Error!", error));
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.forumPost != null ? "Update Post" : "Create Post",
          style: TextStyle(color: kPurpleColor),
        ),
        backgroundColor: kAppBarBackgroundColor,
        iconTheme: IconThemeData(color: kPurpleColor),
      ),
      body: SingleChildScrollView(
          child: FormBuilder(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              FormBuilderTextField(
                decoration: customInputDecoration('Content',
                    fillColor: kLightPurpleBackgroundColor,
                    borderColor: kBorderColor),
                controller: contentController,
                name: 'content',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                  FormBuilderValidators.minLength(context, 3)
                ]),
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Expanded(flex: 1, child: SizedBox()),
                  widget.forumPost == null
                      ? Expanded(
                          flex: 1,
                          child: PAButton(
                            'Create',
                            true,
                            () async {
                              bool callApi = await shouldMakeApiCall(context);
                              if (!callApi) return;

                              _formKey.currentState.save();

                              if (_formKey.currentState.validate()) {
                                _forumViewModel.createPost(
                                    widget.parentThread.id,
                                    _formKey.currentState.value['content'], () {
                                  Navigator.of(context).pop();
                                }, (error) {
                                  showDialog(
                                      context: context,
                                      builder: (_) =>
                                          CustomAlertDialogue("Error!", error));
                                });
                              } else {
                                // EasyLoading.showError(
                                //     "validation failed");
                                showDialog(
                                    context: context,
                                    builder: (_) => CustomAlertDialogue(
                                        "Validation Error!",
                                        "validation failed"));
                              }
                            },
                            fillColor: kPurpleColor,
                            hMargin: 0,
                          ),
                        )
                      : Expanded(
                          flex: 1,
                          child: PAButton(
                            'Update',
                            true,
                            () async {
                              bool callApi = await shouldMakeApiCall(context);
                              if (!callApi) return;

                              _formKey.currentState.save();
                              if (_formKey.currentState.validate()) {
                                _forumViewModel.updatePost(widget.forumPost.id,
                                    _formKey.currentState.value['content'], () {
                                  Navigator.of(context).pop();
                                }, (error) {
                                  showDialog(
                                      context: context,
                                      builder: (_) =>
                                          CustomAlertDialogue("Error!", error));
                                });
                              } else {
                                // EasyLoading.showError(
                                //     "validation failed");
                                showDialog(
                                    context: context,
                                    builder: (_) => CustomAlertDialogue(
                                        "Error!", "validation failed"));
                              }
                            },
                            fillColor: kPurpleColor,
                            hMargin: 0,
                          ),
                        ),
                ],
              )
            ],
          ),
        ),
      )),
    );
  }
}
