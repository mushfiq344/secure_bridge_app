import 'dart:convert';
import 'dart:developer';

import 'dart:io';
import 'package:flutter_summernote/flutter_summernote.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:material_tag_editor/tag_editor.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/Models/Tag.dart';
import 'package:secure_bridges_app/features/opportunity/opportunity_view_model.dart';
import 'package:secure_bridges_app/features/org_admin/my_opportunity.dart';
import 'package:secure_bridges_app/features/org_admin/org_admin_home.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/network_utils/global_utility.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:secure_bridges_app/widgets/custom_alert_dialogue.dart';
import 'package:secure_bridges_app/widgets/input_decoration.dart';

class OpportunityForm extends StatefulWidget {
  final Opportunity oppotunity;
  final String uploadPath;
  OpportunityForm(this.oppotunity, this.uploadPath);
  @override
  _OpportunityFormState createState() => _OpportunityFormState();
}

class _OpportunityFormState extends State<OpportunityForm> {
  List<String> tagValues = [];
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _textEditingController = TextEditingController();
  OpportunityViewModel _opportunityViewModel = OpportunityViewModel();

  _onDelete(index) {
    setState(() {
      tagValues.removeAt(index);
    });
  }

  /// This is just an example for using `TextEditingController` to manipulate
  /// the the `TextField` just like a normal `TextField`.
  _onPressedModifyTextField() {
    final text = 'Test';
    _textEditingController.text = text;
    _textEditingController.value = _textEditingController.value.copyWith(
      text: text,
      selection: TextSelection(
        baseOffset: text.length,
        extentOffset: text.length,
      ),
    );
  }

  final _formKey = GlobalKey<FormBuilderState>();
  GlobalKey<FlutterSummernoteState> _descriptionKeyEditor =
      GlobalKey<FlutterSummernoteState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController opportunityDateController =
      TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController rewardController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final _opportunityTypeKey = GlobalKey<FormBuilderFieldState>();
  Map<String, dynamic> _coverImageAreaMap = Map();
  Map<String, dynamic> _iconImageAreaMap = Map();
  var _imageNameWithExtension;
  var _coverImageBase64String;
  var _iconImageBase64String;

  PickedFile _coverImage;
  PickedFile _iconImage;
  final ImagePicker _picker = ImagePicker();

  _imgFromCamera(String type) async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      if (type == 'cover') {
        _coverImage = image;
      } else {
        _iconImage = image;
      }

      _getImageNameAndString(type);
    });
  }

  _imgFromGallery(String type) async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      if (type == 'cover') {
        _coverImage = image;
      } else {
        _iconImage = image;
      }

      _getImageNameAndString(type);
    });
  }

  _getImageNameAndString(String type) {
    if (type == 'cover') {
      if (_coverImage != null) {
        _imageNameWithExtension =
            _coverImage.path.substring(_coverImage.path.lastIndexOf("/") + 1);

        var fileContent = File(_coverImage.path).readAsBytesSync();
        _coverImageBase64String = base64Encode(fileContent);

        _coverImageAreaMap[kImageNameWithExtension] = _imageNameWithExtension;
        _coverImageAreaMap[kImage] =
            IMAGE_URL_PREFIX + base64Encode(fileContent);
      }
    } else {
      if (_iconImage != null) {
        _imageNameWithExtension =
            _iconImage.path.substring(_iconImage.path.lastIndexOf("/") + 1);

        var fileContent = File(_iconImage.path).readAsBytesSync();
        _iconImageBase64String = base64Encode(fileContent);

        _iconImageAreaMap[kImageNameWithExtension] = _imageNameWithExtension;
        _iconImageAreaMap[kImage] =
            IMAGE_URL_PREFIX + base64Encode(fileContent);
      }
    }
  }

  @override
  void initState() {
    if (widget.oppotunity != null)
      getOpportunityFormDetails(widget.oppotunity.id);

    super.initState();
  }

  void getOpportunityFormDetails(int opportunityId) {
    _opportunityViewModel.getOpportunityFormDetail(opportunityId,
        (Map<String, dynamic> body) {
      print(body);
      Opportunity _opprtunity =
          Opportunity.fromJson(body['data']['opportunity']);
      List<Tag> _tags = List<Tag>.from(
          body['data']['opportunity']['tags'].map((i) => Tag.fromJson(i)));
      if (_opprtunity != null) {
        EasyLoading.show(status: kLoading);
        Future.delayed(const Duration(), () async {
          titleController.text = _opprtunity.title;
          subTitleController.text = _opprtunity.subTitle;
          descriptionController.text = _opprtunity.description;
          opportunityDateController.text = _opprtunity.opportunityDate;
          durationController.text = _opprtunity.duration.toString();
          rewardController.text = _opprtunity.reward;
          _opportunityTypeKey.currentState
              .setValue(OPPORTUNITY_TYPES[_opprtunity.type]);
          locationController.text = _opprtunity.location;

          await Future.delayed(Duration(milliseconds: 500));
          if (_opprtunity.description != null) {
            _descriptionKeyEditor.currentState.setText(_opprtunity.description);
          }

          await Future.delayed(Duration(milliseconds: 500));
          if (_opprtunity.description == null) {
            _descriptionKeyEditor.currentState.setHint(
              "Your text here...",
            );
          } else {
            _descriptionKeyEditor.currentState.setHint("");
          }

          await Future.delayed(Duration(milliseconds: 500));
          EasyLoading.dismiss();
        });
      }
      setState(() {
        tagValues = _tags.map<String>((e) => e.title).toList();
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
          title: Text(kAppName),
          backgroundColor: kPurpleColor,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          text: "Title",
                          style: TextStyle(
                              color: Colors.black, fontSize: kMargin14),
                          children: <TextSpan>[
                            TextSpan(
                                text: '*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: customInputDecoration('Title',
                            fillColor: kLightPurpleBackgroundColor,
                            borderColor: kBorderColor),
                        controller: titleController,
                        name: 'title',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          text: "Sub Title",
                          style: TextStyle(
                              color: Colors.black, fontSize: kMargin14),
                          children: <TextSpan>[
                            TextSpan(
                                text: '', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: customInputDecoration('Sub Title',
                            fillColor: kLightPurpleBackgroundColor,
                            borderColor: kBorderColor),
                        controller: subTitleController,
                        name: 'subtitle',
                        validator: FormBuilderValidators.compose([
                          /* FormBuilderValidators.required(context),*/
                        ]),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          text: "Description",
                          style: TextStyle(
                              color: Colors.black, fontSize: kMargin14),
                          children: <TextSpan>[
                            TextSpan(
                                text: '', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      // FormBuilderTextField(
                      //   decoration: _inputDecoration('Description'),
                      //   controller: descriptionController,
                      //   name: 'description',
                      //   validator: FormBuilderValidators.compose([
                      //     /*FormBuilderValidators.required(context),*/
                      //   ]),
                      //   keyboardType: TextInputType.text,
                      // ),
                      Container(
                        height: 400,
                        child: FlutterSummernote(
                            hasAttachment: false,
                            showBottomToolbar: false,
                            hint: "Your text here...",
                            key: _descriptionKeyEditor),
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          text: "Opportunity Date",
                          style: TextStyle(
                              color: Colors.black, fontSize: kMargin14),
                          children: <TextSpan>[
                            TextSpan(
                                text: '', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        readOnly: true,
                        controller: opportunityDateController,
                        name: 'opportunity_date',
                        decoration: customInputDecoration(
                            !opportunityDateController.text.isEmpty
                                ? opportunityDateController.text
                                : 'Opportunity Date',
                            fillColor: kLightPurpleBackgroundColor,
                            borderColor: kBorderColor),
                        onTap: () async {
                          DateTime date = DateTime(1900);
                          FocusScope.of(context).requestFocus(new FocusNode());

                          date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2100));

                          opportunityDateController.text =
                              DateFormat('yyyy-MM-dd').format(date);
                        },
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          text: "Duration In Days",
                          style: TextStyle(
                              color: Colors.black, fontSize: kMargin14),
                          children: <TextSpan>[
                            TextSpan(
                                text: '', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: customInputDecoration('Duration In Days',
                            fillColor: kLightPurpleBackgroundColor,
                            borderColor: kBorderColor),
                        controller: durationController,
                        name: 'duration',
                        validator: FormBuilderValidators.compose([
                          /*  FormBuilderValidators.required(context),*/
                          FormBuilderValidators.integer(context)
                        ]),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          text: "Reward",
                          style: TextStyle(
                              color: Colors.black, fontSize: kMargin14),
                          children: <TextSpan>[
                            TextSpan(
                                text: '', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: customInputDecoration('Reward',
                            fillColor: kLightPurpleBackgroundColor,
                            borderColor: kBorderColor),
                        controller: rewardController,
                        name: 'reward',
                        validator: FormBuilderValidators.compose([
                          /*FormBuilderValidators.required(context),*/
                          FormBuilderValidators.integer(context)
                        ]),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          text: "Location",
                          style: TextStyle(
                              color: Colors.black, fontSize: kMargin14),
                          children: <TextSpan>[
                            TextSpan(
                                text: '', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: customInputDecoration('Location',
                            fillColor: kLightPurpleBackgroundColor,
                            borderColor: kBorderColor),
                        controller: locationController,
                        name: 'location',
                        validator: FormBuilderValidators.compose([
                          /*  FormBuilderValidators.required(context),*/
                        ]),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          text: "Type",
                          style: TextStyle(
                              color: Colors.black, fontSize: kMargin14),
                          children: <TextSpan>[
                            TextSpan(
                                text: '*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderDropdown(
                        key: _opportunityTypeKey,
                        name: 'type',
                        decoration: customInputDecoration("Type",
                            fillColor: kLightPurpleBackgroundColor,
                            borderColor: kBorderColor),
                        // initialValue: 'Male',
                        allowClear: true,

                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required(context)]),
                        items: OPPORTUNITY_TYPES
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text('$type'),
                                ))
                            .toList(),
                      ),
                      SizedBox(height: 10),
                      SizedBox(height: kMargin16),
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              padding: EdgeInsets.all(kMargin14),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: kBorderColor,
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(kRadius10),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  _showCoverPicker(context);
                                },
                                child: _coverImage != null
                                    ? AspectRatio(
                                        aspectRatio: 16 / 9,
                                        child: Image.file(
                                            File(_coverImage.path),
                                            fit: BoxFit.cover),
                                      )
                                    : Container(
                                        child: widget.oppotunity == null
                                            ? AspectRatio(
                                                aspectRatio: 16 / 9,
                                                child: Image(
                                                  image: AssetImage(
                                                      kAvatarIconPath),
                                                  fit: BoxFit
                                                      .fitHeight, // use this
                                                ),
                                              )
                                            : CachedNetworkImage(
                                                imageUrl:
                                                    "${BASE_URL}${widget.uploadPath}${widget.oppotunity.coverImage}",
                                                placeholder: (context, url) =>
                                                    Image(
                                                        image: AssetImage(
                                                            kPlaceholderImagePath)),
                                                errorWidget: (context, url,
                                                        error) =>
                                                    Image(
                                                        image: AssetImage(
                                                            kPlaceholderImagePath)),
                                                fit: BoxFit.fill,
                                                height: 100,
                                                width: 100,
                                              ),
                                      ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(left: kMargin10),
                              child: Text(
                                kUploadCover,
                                style: TextStyle(
                                  color: kLabelColor,
                                  fontSize: kMargin14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: kMargin16),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(kMargin14),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: kBorderColor,
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(kRadius10),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                _showIconPicker(context);
                              },
                              child: _iconImage != null
                                  ? Image.file(
                                      File(_iconImage.path),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.fitHeight,
                                    )
                                  : Container(
                                      child: widget.oppotunity == null
                                          ? Image(
                                              image:
                                                  AssetImage(kAvatarIconPath),
                                              width: 100,
                                              height: 100,
                                            )
                                          : CachedNetworkImage(
                                              imageUrl:
                                                  "${BASE_URL}${widget.uploadPath}${widget.oppotunity.iconImage}",
                                              placeholder: (context, url) =>
                                                  Image(
                                                      image: AssetImage(
                                                          kPlaceholderImagePath)),
                                              errorWidget: (context, url,
                                                      error) =>
                                                  Image(
                                                      image: AssetImage(
                                                          kPlaceholderImagePath)),
                                              fit: BoxFit.fill,
                                              height: 100,
                                              width: 100,
                                            ),
                                    ),
                            ),
                          ),
                          SizedBox(width: kMargin24),
                          Expanded(
                            flex: 1,
                            child: Text(
                              kUploadIcon,
                              style: TextStyle(
                                color: kLabelColor,
                                fontSize: kMargin14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: kMargin16),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: TagEditor(
                            length: tagValues.length,
                            controller: _textEditingController,
                            focusNode: _focusNode,
                            delimiters: [',', ' '],
                            hasAddButton: true,

                            resetTextOnSubmitted: true,
                            // This is set to grey just to illustrate the `textStyle` prop
                            textStyle: const TextStyle(
                              color: kPurpleColor,
                            ),
                            onSubmitted: (outstandingValue) {
                              setState(() {
                                tagValues.add(outstandingValue);
                              });
                            },
                            inputDecoration: const InputDecoration(
                              fillColor: kPurpleColor,
                              border: InputBorder.none,
                              hintText: 'Add Tag...',
                            ),
                            onTagChanged: (newValue) {
                              setState(() {
                                tagValues.add(newValue);
                              });
                              print("tagValues $tagValues");
                            },
                            tagBuilder: (context, index) => _Chip(
                              index: index,
                              label: tagValues[index],
                              onDeleted: _onDelete,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: widget.oppotunity == null
                          ? Column(
                              children: [
                                PAButton(
                                  "Submit",
                                  true,
                                  () async {
                                    bool callApi =
                                        await shouldMakeApiCall(context);
                                    if (!callApi) return;
                                    _formKey.currentState.save();
                                    if (_formKey.currentState.validate()) {
                                      print(_formKey.currentState.value);

                                      _createOpportunity(
                                          OPPORTUNITY_STATUS_VALUES["Drafted"]);
                                    } else {
                                      EasyLoading.showError(
                                          "validation failed");
                                    }
                                  },
                                  fillColor: kPurpleColor,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                PAButton(
                                  "Submit & Publish",
                                  true,
                                  () async {
                                    bool callApi =
                                        await shouldMakeApiCall(context);
                                    if (!callApi) return;
                                    _formKey.currentState.save();
                                    if (_formKey.currentState.validate()) {
                                      print(_formKey.currentState.value);

                                      _createOpportunity(
                                          OPPORTUNITY_STATUS_VALUES[
                                              "Published"]);
                                    } else {
                                      EasyLoading.showError(
                                          "validation failed");
                                    }
                                  },
                                  fillColor: kPurpleColor,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                PAButton(
                                  "Update",
                                  true,
                                  () {
                                    _formKey.currentState.save();
                                    if (_formKey.currentState.validate()) {
                                      print(_formKey.currentState.value);

                                      _updateOpportunity();
                                    } else {
                                      EasyLoading.showError(
                                          "validation failed");
                                    }
                                  },
                                  fillColor: kPurpleColor,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                PAButton(
                                  "Publish",
                                  true,
                                  () {
                                    _formKey.currentState.save();
                                    if (_formKey.currentState.validate()) {
                                      print(_formKey.currentState.value);

                                      _updateOpportunity(
                                          status: OPPORTUNITY_STATUS_VALUES[
                                              'Published']);
                                    } else {
                                      EasyLoading.showError(
                                          "validation failed");
                                    }
                                  },
                                  fillColor: kPurpleColor,
                                ),
                              ],
                            ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void _showCoverPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _imgFromGallery('cover');
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera('cover');
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showIconPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Gallery'),
                      onTap: () {
                        _imgFromGallery('icon');
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera('icon');
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _createOpportunity(int status) async {
    String description = await _descriptionKeyEditor.currentState?.getText();
    // getText() is buggy and doesn't work first time when it's called
    await Future.delayed(Duration(milliseconds: 500));
    description = await _descriptionKeyEditor.currentState?.getText();
    try {
      if (_coverImageAreaMap[kImage] == null) {
        EasyLoading.showError("please add cover image");
        return;
      }
      if (_iconImageAreaMap[kImage] == null) {
        EasyLoading.showError("please add icon image");
        return;
      }

      var data = {
        'cover_image': _coverImageAreaMap[kImage],
        'icon_image': _iconImageAreaMap[kImage],
        'title': titleController.text,
        'subtitle': subTitleController.text,
        'description': description,
        'opportunity_date': opportunityDateController.text,
        'duration': durationController.text,
        'reward': rewardController.text,
        'type':
            OPPORTUNITY_TYPES_VALUES[_opportunityTypeKey.currentState.value],
        'status': status,
        'location': locationController.text,
        'tag_values': tagValues
      };
      EasyLoading.show(status: kLoading);
      var res = await Network().postData(data, ORG_ADMIN_OPPORTUNITIES_URL);
      var body = json.decode(res.body);
      log("res ${res.statusCode}");
      log("body : ${body}");
      if (res.statusCode == 201) {
        print("success");
        EasyLoading.dismiss();
        EasyLoading.showSuccess(body["message"]);
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => OrgAdminHome()),
          (route) => false,
        );
      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(body['message']);
      }
    } catch (e) {
      print(e);
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }

  void _updateOpportunity({int status = 0}) async {
    String description = await _descriptionKeyEditor.currentState?.getText();
    // getText() is buggy and doesn't work first time when it's called
    await Future.delayed(Duration(milliseconds: 500));
    description = await _descriptionKeyEditor.currentState?.getText();

    try {
      var data = {
        'id': widget.oppotunity.id,
        'title': titleController.text,
        'subtitle': subTitleController.text,
        'description': description,
        'opportunity_date': opportunityDateController.text,
        'duration': durationController.text,
        'reward': rewardController.text,
        'type':
            OPPORTUNITY_TYPES_VALUES[_opportunityTypeKey.currentState.value],
        'status': status,
        'location': locationController.text,
        'tag_values': tagValues
      };
      if (_coverImageAreaMap[kImage] != null) {
        data['cover_image'] = _coverImageAreaMap[kImage];
      }
      if (_iconImageAreaMap[kImage] != null) {
        data['icon_image'] = _iconImageAreaMap[kImage];
      }
      log("data $data");

      EasyLoading.show(status: kLoading);
      var res = await Network().putData(
          data, "$ORG_ADMIN_OPPORTUNITIES_URL/${widget.oppotunity.id}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : ${body}");
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess(body["message"]);
        await Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MyOpportunity()),
          (route) => false,
        );
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

class _Chip extends StatelessWidget {
  const _Chip({
    this.label,
    this.onDeleted,
    this.index,
  });

  final String label;
  final ValueChanged<int> onDeleted;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelPadding: const EdgeInsets.only(left: 8.0),
      label: Text(label),
      deleteIcon: const Icon(
        Icons.close,
        size: 18,
      ),
      onDeleted: () {
        onDeleted(index);
      },
    );
  }
}
