import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/screen/home.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpportunityForm extends StatefulWidget {
  final Opportunity oppotunity;
  final String uploadPath;
  OpportunityForm(this.oppotunity,this.uploadPath);
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
  final TextEditingController durationController =
  TextEditingController();
  final TextEditingController rewardController =
  TextEditingController();
  final TextEditingController typeController =
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
      } }else {
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
  void initState() {
    if(widget.oppotunity!=null){
      titleController.text=widget.oppotunity.title;
      subTitleController.text=widget.oppotunity.subTitle;
      descriptionController.text=widget.oppotunity.description;
      opportunityDateController.text=widget.oppotunity.opportunityDate ;
      durationController.text=widget.oppotunity.duration.toString();
      rewardController.text=widget.oppotunity.reward;
      typeController.text=widget.oppotunity.type;
    }
    super.initState();
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
                                text: '', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: _inputDecoration('Sub Title'),
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
                      FormBuilderTextField(
                        decoration: _inputDecoration('Description'),
                        controller: descriptionController,
                        name: 'description',
                        validator: FormBuilderValidators.compose([
                          /*FormBuilderValidators.required(context),*/
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
                                text: '', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderDateTimePicker(
                        controller: opportunityDateController,
                        name: 'opportunity_date',
                        // onChanged: _onChanged,
                        inputType: InputType.date,
                        decoration: _inputDecoration(!opportunityDateController.text.isEmpty?opportunityDateController.text:'Opportunity Date'),
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
                                text: '', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      FormBuilderTextField(
                        decoration: _inputDecoration('Duration In Days'),
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
                        decoration: _inputDecoration('Reward'),
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
                          text: "Type",
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
                        decoration: _inputDecoration('Type'),
                        controller: typeController,
                        name: 'type',
                        validator: FormBuilderValidators.compose([
                        /*  FormBuilderValidators.required(context),*/
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
                                      child: widget.oppotunity==null?Image(
                                        image: AssetImage(kAvatarIconPath),
                                        width: 100,
                                        height: 100,
                                      ):CachedNetworkImage(
                                        imageUrl: "${BASE_URL}${widget.uploadPath}${widget.oppotunity.coverImage}",
                                        placeholder: (context, url) =>
                                            Image(image: AssetImage(kPlaceholderImagePath)),
                                        errorWidget: (context, url, error) =>
                                            Image(image: AssetImage(kPlaceholderImagePath)),
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
                                      child: widget.oppotunity==null?Image(
                                        image: AssetImage(kAvatarIconPath),
                                        width: 100,
                                        height: 100,
                                      ):CachedNetworkImage(
                                        imageUrl: "${BASE_URL}${widget.uploadPath}${widget.oppotunity.iconImage}",
                                        placeholder: (context, url) =>
                                            Image(image: AssetImage(kPlaceholderImagePath)),
                                        errorWidget: (context, url, error) =>
                                            Image(image: AssetImage(kPlaceholderImagePath)),
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
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: widget.oppotunity==null? PAButton(
                        "Submit",
                        true,
                        () {


                          _formKey.currentState.save();
                          if (_formKey.currentState.validate()) {
                            print(_formKey.currentState.value);

                            _createOpportunity();
                          } else {
                            EasyLoading.showError("validation failed");
                          }
                        },
                        fillColor: kPurpleColor,
                      ):PAButton(
                        "Update",
                        true,
                            () {


                          _formKey.currentState.save();
                          if (_formKey.currentState.validate()) {
                            print(_formKey.currentState.value);

                            _updateOpportunity();
                          } else {
                            EasyLoading.showError("validation failed");
                          }
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

  void _createOpportunity() async {
    try {
      if(_coverImageAreaMap[kImage]==null){
        EasyLoading.showError("please add cover image");
        return;
      }
      if(_iconImageAreaMap[kImage]==null){
        EasyLoading.showError("please add icon image");
        return;
      }
      var data = {
        'cover_image': _coverImageAreaMap[kImage], 'icon_image': _iconImageAreaMap[kImage],
        'title':titleController.text,
        'subtitle':subTitleController.text,
        'description':descriptionController.text,
        'opportunity_date':opportunityDateController.text,
        'duration':durationController.text,
        'reward':rewardController.text,
        'type':typeController.text
      };
      EasyLoading.show(status: kLoading);
      var res = await Network().postData(data, OPPORTUNITIES_URL);
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : ${body}");
      if (res.statusCode == 200) {
        print("success");
        EasyLoading.dismiss();
        EasyLoading.showSuccess(body["message"]);
        Navigator.of(context).pop(true);

      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(body['message']);
      }


    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }

  void _updateOpportunity() async {
    try {

      var data = {
        'id':widget.oppotunity.id,
        'title':titleController.text,
        'subtitle':subTitleController.text,
        'description':descriptionController.text,
        'opportunity_date':opportunityDateController.text,
        'duration':durationController.text,
        'reward':rewardController.text,
        'type':typeController.text
      };
      if(_coverImageAreaMap[kImage]!=null){
        data['cover_image']=_coverImageAreaMap[kImage];
      }
      if(_iconImageAreaMap[kImage]!=null){
        data['icon_image']=_iconImageAreaMap[kImage];
      }
      log("data $data");

      EasyLoading.show(status: kLoading);
      var res = await Network().putData(data, "$OPPORTUNITIES_URL/${widget.oppotunity.id}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : ${body}");
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        EasyLoading.showSuccess(body["message"]);
        Navigator.of(context).pop(true);

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
