import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:secure_bridges_app/Models/forum_thread.dart';
import 'package:secure_bridges_app/features/forum/forum_view_model.dart';
import 'package:secure_bridges_app/network_utils/global_utility.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:secure_bridges_app/widgets/custom_alert_dialogue.dart';
import 'package:secure_bridges_app/widgets/input_decoration.dart';

class ForumRoom extends StatefulWidget {
  final ForumThread forumThread;
  ForumRoom(this.forumThread);
  @override
  _ForumRoomState createState() => _ForumRoomState();
}

class _ForumRoomState extends State<ForumRoom> {
  ForumViewModel _forumViewModel = ForumViewModel();
  ForumThread forumThread;
  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();
  final _formKey = GlobalKey<FormBuilderState>();
  @override
  void initState() {
    if (widget.forumThread != null) {
      // TODO: implement initState
      _forumViewModel.getThread(widget.forumThread.id,
          (Map<String, dynamic> body) {
        ForumThread _forumThread = ForumThread.fromJson(body['data']);
        setState(() {
          forumThread = _forumThread;
          titleController.text = _forumThread.title;
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
          widget.forumThread != null ? "Update Thread" : "Create Thread",
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
                decoration: customInputDecoration('Title',
                    fillColor: kLightPurpleBackgroundColor,
                    borderColor: kBorderColor),
                controller: titleController,
                name: 'title',
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(context),
                  FormBuilderValidators.minLength(context, 3)
                ]),
                keyboardType: TextInputType.text,
              ),
              widget.forumThread == null
                  ? Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
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
                        )
                      ],
                    )
                  : SizedBox(
                      height: 10,
                    ),
              Row(
                children: [
                  Expanded(flex: 1, child: SizedBox()),
                  widget.forumThread == null
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
                                _forumViewModel.createThread(
                                    _formKey.currentState.value['title'],
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
                            'Rename',
                            true,
                            () async {
                              bool callApi = await shouldMakeApiCall(context);
                              if (!callApi) return;

                              _formKey.currentState.save();
                              if (_formKey.currentState.validate()) {
                                _forumViewModel.renameRoom(
                                    widget.forumThread.id,
                                    _formKey.currentState.value['title'], () {
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
