import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';

class OpportunityForm extends StatefulWidget {
  @override
  _OpportunityFormState createState() => _OpportunityFormState();
}

class _OpportunityFormState extends State<OpportunityForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController subTitleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController opportunityDateController =
      TextEditingController();
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
  }

  InputDecoration _inputDecoration(String hintText, {bool showIcon = false}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: kBorderColor),
      fillColor: Colors.transparent,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadius10),
        borderSide: BorderSide(
          color: kAccentColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadius10),
        borderSide: BorderSide(
          color: kBorderColor,
          width: 1.0,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadius10),
        borderSide: BorderSide(
          color: kBorderColor,
          width: 1.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadius10),
        borderSide: BorderSide(
          color: kBorderColor,
          width: 1.0,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadius10),
        borderSide: BorderSide(
          color: kBorderColor,
          width: 1.0,
        ),
      ),
      suffixIcon: showIcon ? Image.asset(kIconLocationPath) : null,
    );
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
                        decoration: _inputDecoration('Title'),
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
                                text: '*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: _inputDecoration('Sub Title'),
                        controller: subTitleController,
                        name: 'subtitle',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
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
                                text: '*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: _inputDecoration('Description'),
                        controller: subTitleController,
                        name: 'description',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        keyboardType: TextInputType.text,
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          text: "Opportunity Date",
                          style: TextStyle(
                              color: Colors.black, fontSize: kMargin14),
                          children: <TextSpan>[
                            TextSpan(
                                text: '*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderDateTimePicker(
                        controller: opportunityDateController,
                        name: 'opportunity_date',
                        // onChanged: _onChanged,
                        inputType: InputType.date,
                        decoration: _inputDecoration('Opportunity Date'),
                        initialTime: TimeOfDay(hour: 8, minute: 0),
                        // initialValue: DateTime.now(),
                        // enabled: true,
                      ),
                      SizedBox(height: 10),
                      RichText(
                        text: TextSpan(
                          text: "Duration In Days",
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
                        decoration: _inputDecoration('Duration In Days'),
                        controller: subTitleController,
                        name: 'duration',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
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
                                text: '*', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: _inputDecoration('Reward'),
                        controller: subTitleController,
                        name: 'reward',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.integer(context)
                        ]),
                        keyboardType: TextInputType.number,
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
                      FormBuilderTextField(
                        decoration: _inputDecoration('Type'),
                        controller: subTitleController,
                        name: 'type',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        keyboardType: TextInputType.text,
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
                                _showCoverPicker(context);
                              },
                              child: _coverImage != null
                                  ? Image.file(
                                      File(_coverImage.path),
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.fitHeight,
                                    )
                                  : Container(
                                      child: Image(
                                        image: AssetImage(kAvatarIconPath),
                                        width: 100,
                                        height: 100,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(width: kMargin24),
                          Expanded(
                            flex: 1,
                            child: Text(
                              kUploadCover,
                              style: TextStyle(
                                color: kLabelColor,
                                fontSize: kMargin14,
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
                                      child: Image(
                                        image: AssetImage(kAvatarIconPath),
                                        width: 100,
                                        height: 100,
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
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: PAButton(
                        "Submit",
                        true,
                        () {
                          _formKey.currentState.save();
                          if (_formKey.currentState.validate()) {
                            print(_formKey.currentState.value);
                            log("cover : ${_coverImageAreaMap}");
                          } else {
                            print("validation failed");
                          }
                        },
                        fillColor: kPurpleColor,
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: PAButton(
                        "Reset",
                        true,
                        () {
                          _formKey.currentState.reset();
                        },
                        fillColor: kPurpleColor,
                      ),
                    ),
                  ],
                )
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
}
