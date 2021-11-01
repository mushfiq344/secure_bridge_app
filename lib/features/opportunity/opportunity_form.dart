import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:secure_bridges_app/utls/dimens.dart';

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
  var _coverImageNameWithExtension;
  var _coverImageBase64String;

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
        _coverImageNameWithExtension =
            _coverImage.path.substring(_coverImage.path.lastIndexOf("/") + 1);

        var fileContent = File(_coverImage.path).readAsBytesSync();
        _coverImageBase64String = base64Encode(fileContent);

        _coverImageAreaMap[kImageNameWithExtension] =
            _coverImageNameWithExtension;
        _coverImageAreaMap[kImage] =
            IMAGE_URL_PREFIX + base64Encode(fileContent);
      } else {
        if (_iconImage != null) {
          _coverImageNameWithExtension =
              _coverImage.path.substring(_coverImage.path.lastIndexOf("/") + 1);

          var fileContent = File(_iconImage.path).readAsBytesSync();
          _coverImageBase64String = base64Encode(fileContent);

          _coverImageAreaMap[kImageNameWithExtension] =
              _coverImageNameWithExtension;
          _coverImageAreaMap[kImage] =
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
                    children: <Widget>[
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
                      FormBuilderTextField(
                        decoration: _inputDecoration('Sub Title'),
                        controller: subTitleController,
                        name: 'subtitle',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        keyboardType: TextInputType.text,
                      ),
                      FormBuilderTextField(
                        decoration: _inputDecoration('Description'),
                        controller: subTitleController,
                        name: 'description',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                        keyboardType: TextInputType.text,
                      ),
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
                                _showPicker(context);
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
                              kUploadPicture,
                              style: TextStyle(
                                color: kLabelColor,
                                fontSize: kMargin14,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: kMargin16),
                      FormBuilderFilterChip(
                        name: 'filter_chip',
                        decoration: InputDecoration(
                          labelText: 'Select many options',
                        ),
                        options: [
                          FormBuilderFieldOption(
                              value: 'Test', child: Text('Test')),
                          FormBuilderFieldOption(
                              value: 'Test 1', child: Text('Test 1')),
                          FormBuilderFieldOption(
                              value: 'Test 2', child: Text('Test 2')),
                          FormBuilderFieldOption(
                              value: 'Test 3', child: Text('Test 3')),
                          FormBuilderFieldOption(
                              value: 'Test 4', child: Text('Test 4')),
                        ],
                      ),
                      FormBuilderChoiceChip(
                        name: 'choice_chip',
                        decoration: InputDecoration(
                          labelText: 'Select an option',
                        ),
                        options: [
                          FormBuilderFieldOption(
                              value: 'Test', child: Text('Test')),
                          FormBuilderFieldOption(
                              value: 'Test 1', child: Text('Test 1')),
                          FormBuilderFieldOption(
                              value: 'Test 2', child: Text('Test 2')),
                          FormBuilderFieldOption(
                              value: 'Test 3', child: Text('Test 3')),
                          FormBuilderFieldOption(
                              value: 'Test 4', child: Text('Test 4')),
                        ],
                      ),
                      FormBuilderSlider(
                        name: 'slider',
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.min(context, 6),
                        ]),
                        min: 0.0,
                        max: 10.0,
                        initialValue: 7.0,
                        divisions: 20,
                        activeColor: Colors.red,
                        inactiveColor: Colors.pink[100],
                        decoration: InputDecoration(
                          labelText: 'Number of things',
                        ),
                      ),
                      FormBuilderCheckbox(
                        name: 'accept_terms',
                        initialValue: false,
                        title: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'I have read and agree to the ',
                                style: TextStyle(color: Colors.black),
                              ),
                              TextSpan(
                                text: 'Terms and Conditions',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                        validator: FormBuilderValidators.equal(
                          context,
                          true,
                          errorText:
                              'You must accept terms and conditions to continue',
                        ),
                      ),
                      FormBuilderDropdown(
                        name: 'gender',
                        decoration: InputDecoration(
                          labelText: 'Gender',
                        ),
                        // initialValue: 'Male',
                        allowClear: true,
                        hint: Text('Select Gender'),
                        validator: FormBuilderValidators.compose(
                            [FormBuilderValidators.required(context)]),
                        items: ['male', 'female']
                            .map((gender) => DropdownMenuItem(
                                  value: gender,
                                  child: Text('$gender'),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: MaterialButton(
                        color: Theme.of(context).colorScheme.secondary,
                        child: Text(
                          "Submit",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _formKey.currentState.save();
                          if (_formKey.currentState.validate()) {
                            print(_formKey.currentState.value);
                          } else {
                            print("validation failed");
                          }
                        },
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: MaterialButton(
                        color: Theme.of(context).colorScheme.secondary,
                        child: Text(
                          "Reset",
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () {
                          _formKey.currentState.reset();
                        },
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }

  void _showPicker(context) {
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
}
