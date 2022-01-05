import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_observer/Observable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:secure_bridges_app/Models/Profile.dart';
import 'package:secure_bridges_app/Models/User.dart';
import 'package:secure_bridges_app/features/landing/landing_search_page.dart';
import 'package:secure_bridges_app/features/org_admin/org_admin_home.dart';
import 'package:secure_bridges_app/features/profile/profile_view_model.dart';
import 'package:secure_bridges_app/features/user/user_view_model.dart';
import 'package:secure_bridges_app/network_utils/global_utility.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:secure_bridges_app/widgets/custom_alert_dialogue.dart';
import 'package:secure_bridges_app/widgets/input_decoration.dart';

class ProfileForm extends StatefulWidget {
  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
  ProfileViewModel _profileViewModel = ProfileViewModel();
  UserViewModel _userViewModel = UserViewModel();
  User currentUser;
  final _formKey = GlobalKey<FormBuilderState>();
  final _genderKey = GlobalKey<FormBuilderFieldState>();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  Profile profile;

  Map<String, dynamic> _profileImageAreaMap = Map();
  var _imageNameWithExtension;
  var _profileImageBase64String;
  PickedFile _profileImage;

  final ImagePicker _picker = ImagePicker();
  _imgFromCamera() async {
    PickedFile image = await _picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50,
        maxWidth: 512,
        maxHeight: 512);
    // image =
    //     (await FlutterExifRotation.rotateImage(path: image.path)) as PickedFile;

    setState(() {
      _profileImage = image;

      _getImageNameAndString();
    });
  }

  _imgFromGallery(String type) async {
    PickedFile image =
        await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    // image =
    //     (await FlutterExifRotation.rotateImage(path: image.path)) as PickedFile;

    setState(() {
      _profileImage = image;

      _getImageNameAndString();
    });
  }

  _getImageNameAndString() {
    if (_profileImage != null) {
      _imageNameWithExtension =
          _profileImage.path.substring(_profileImage.path.lastIndexOf("/") + 1);

      var fileContent = File(_profileImage.path).readAsBytesSync();
      _profileImageBase64String = base64Encode(fileContent);

      _profileImageAreaMap[kImageNameWithExtension] = _imageNameWithExtension;
      _profileImageAreaMap[kImage] =
          IMAGE_URL_PREFIX + base64Encode(fileContent);
    }
  }

  _loadUserData() {
    _userViewModel.loadUserData((Map<dynamic, dynamic> user) {
      setState(() {
        currentUser = User.fromJson(user);
      });
    }, (error) {
      // EasyLoading.showError(error);
      showDialog(
          context: context,
          builder: (_) => CustomAlertDialogue("Error!", error));
    });
  }

  @override
  void initState() {
    _loadUserData();
    loadProfileData();

    super.initState();
  }

  void loadProfileData() {
    _profileViewModel.getProfile((Map<dynamic, dynamic> profileJson) {
      if (profileJson != null) {
        setProfileData(profileJson);
      } else {
        setState(() {
          fullNameController.text = currentUser.name;
        });
      }
    }, (error) {
      showDialog(
          context: context,
          builder: (_) => CustomAlertDialogue("Error!", error));
      // EasyLoading.showError(error);
    });
  }

  void setProfileData(Map<dynamic, dynamic> profileJson) {
    Future.delayed(const Duration(), () {
      setState(() {
        fullNameController.text = profileJson['full_name'];
        _genderKey.currentState.setValue(GENDER_OPTIONS[profileJson['gender']]);
        addressController.text = profileJson['address'];
        profile = Profile.fromJson(profileJson);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(color: kPurpleColor),
          ),
          backgroundColor: kAppBarBackgroundColor,
          iconTheme: IconThemeData(color: kPurpleColor)),
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
                child: Center(
              child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5), BlendMode.dstATop),
                  child: _profileImage != null
                      ? Image.file(
                          File(_profileImage.path),
                          fit: BoxFit.fitHeight,
                          height: MediaQuery.of(context).size.height / 2,
                          width: MediaQuery.of(context).size.width,
                        )
                      : Container(
                          child: profile == null
                              ? Image(
                                  image: AssetImage(kAddUserImagePath),
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  width: MediaQuery.of(context).size.width,
                                )
                              : CachedNetworkImage(
                                  imageUrl:
                                      "${BASE_URL}${userProfileImagePath}${profile.photo}",
                                  placeholder: (context, url) => Image(
                                      image: AssetImage(kPlaceholderImagePath)),
                                  errorWidget: (context, url, error) => Image(
                                      image: AssetImage(kPlaceholderImagePath)),
                                  fit: BoxFit.fill,
                                  height:
                                      MediaQuery.of(context).size.height / 2,
                                  width: MediaQuery.of(context).size.width,
                                ),
                        )),
            )),
            Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height / 3,
                ),
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kMargin12)),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            FormBuilder(
                                key: _formKey,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          text: "Full Name",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: kMargin14),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: customInputDecoration(
                                            'Full Name',
                                            fillColor:
                                                kLightPurpleBackgroundColor,
                                            borderColor: kBorderColor),
                                        controller: fullNameController,
                                        name: 'full_name',
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              context),
                                        ]),
                                        keyboardType: TextInputType.text,
                                      ),
                                      SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          text: "Address",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: kMargin14),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      FormBuilderTextField(
                                        decoration: customInputDecoration(
                                            'Address',
                                            fillColor:
                                                kLightPurpleBackgroundColor,
                                            borderColor: kBorderColor),
                                        controller: addressController,
                                        name: 'address',
                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              context),
                                        ]),
                                        keyboardType: TextInputType.text,
                                      ),
                                      SizedBox(height: 10),
                                      RichText(
                                        text: TextSpan(
                                          text: "Gender",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: kMargin14),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: '*',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10),
                                      FormBuilderDropdown(
                                        key: _genderKey,
                                        name: 'gender',
                                        decoration: customInputDecoration(
                                          "Gender",
                                          borderColor: kBorderColor,
                                          fillColor:
                                              kLightPurpleBackgroundColor,
                                        ),
                                        // initialValue: 'Male',
                                        allowClear: true,

                                        validator:
                                            FormBuilderValidators.compose([
                                          FormBuilderValidators.required(
                                              context)
                                        ]),
                                        items: GENDER_OPTIONS
                                            .map((gender) => DropdownMenuItem(
                                                  value: gender,
                                                  child: Text('$gender'),
                                                ))
                                            .toList(),
                                      ),
                                      SizedBox(height: 20),
                                    ])),
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: PAButton(
                                  profile == null
                                      ? "Create Profile"
                                      : "Update Profile",
                                  true,
                                  () async {
                                    bool callApi =
                                        await shouldMakeApiCall(context);
                                    if (!callApi) return;
                                    _formKey.currentState.save();
                                    if (_formKey.currentState.validate()) {
                                      print(_formKey.currentState.value);
                                      var data = {
                                        'full_name': fullNameController.text,
                                        'address': addressController.text,
                                        'gender': GENDER_VALUES[_formKey
                                            .currentState.value['gender']],
                                      };
                                      if (profile == null) {
                                        if (_profileImageAreaMap[kImage] ==
                                            null) {
                                          // EasyLoading.showError(
                                          //     "please add profile image");
                                          showDialog(
                                              context: context,
                                              builder: (_) => CustomAlertDialogue(
                                                  "Error!",
                                                  "please add profile image"));
                                          return;
                                        } else {
                                          data['profile_image'] =
                                              _profileImageAreaMap[kImage];

                                          _profileViewModel.createProfile(data,
                                              (success) async {
                                            // await EasyLoading.showSuccess(
                                            //     success);
                                            showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    CustomAlertDialogue(
                                                        "Success!", success));
                                            if (currentUser.userType == 0) {
                                              await Navigator
                                                  .pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LandingSearchPage()),
                                                (route) => false,
                                              );
                                            } else if (currentUser.userType ==
                                                1) {
                                              await Navigator
                                                  .pushAndRemoveUntil(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrgAdminHome()),
                                                (route) => false,
                                              );
                                            }
                                          }, (error) {
                                            // EasyLoading.showError(error);
                                            showDialog(
                                                context: context,
                                                builder: (_) =>
                                                    CustomAlertDialogue(
                                                        "Error!", error));
                                          });
                                        }
                                      } else {
                                        data['id'] = profile.id;
                                        data['user_id'] = currentUser.id;
                                        if (_profileImageAreaMap[kImage] !=
                                            null) {
                                          data['profile_image'] =
                                              _profileImageAreaMap[kImage];
                                        }

                                        _profileViewModel.updateProfile(data,
                                            (success) async {
                                          // await EasyLoading.showSuccess(
                                          //     success);
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  CustomAlertDialogue(
                                                      "Success!", success));
                                          if (currentUser.userType == 0) {
                                            await Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LandingSearchPage()),
                                              (route) => false,
                                            );
                                          } else if (currentUser.userType ==
                                              1) {
                                            await Navigator.pushAndRemoveUntil(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrgAdminHome()),
                                              (route) => false,
                                            );
                                          }
                                        }, (error) {
                                          // EasyLoading.showError(error);
                                          showDialog(
                                              context: context,
                                              builder: (_) =>
                                                  CustomAlertDialogue(
                                                      "Error!", error));
                                        });
                                      }
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (_) => CustomAlertDialogue(
                                              "Error!", "validation failed"));
                                      // EasyLoading.showError(
                                      //     "validation failed");
                                    }
                                  },
                                  fillColor: kPurpleColor,
                                )),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              child: Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height / 12,
                  ),
                  Center(
                    child: Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kMargin12)),
                      child: GestureDetector(
                        onTap: () {
                          _showCoverPicker(context);
                        },
                        child: _profileImage != null
                            ? Image.file(
                                File(_profileImage.path),
                                fit: BoxFit.fitHeight,
                                height: MediaQuery.of(context).size.height / 6,
                                width: MediaQuery.of(context).size.width / 3,
                              )
                            : Container(
                                child: profile == null
                                    ? Image(
                                        image: AssetImage(kAddUserImagePath),
                                        height:
                                            MediaQuery.of(context).size.height /
                                                6,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                      )
                                    : ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(kMargin12),
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${BASE_URL}${userProfileImagePath}${profile.photo}",
                                          placeholder: (context, url) => Image(
                                              image: AssetImage(
                                                  kPlaceholderImagePath)),
                                          errorWidget: (context, url, error) =>
                                              Image(
                                                  image: AssetImage(
                                                      kPlaceholderImagePath)),
                                          fit: BoxFit.fill,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              6,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              3,
                                        ),
                                      ),
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                      _imgFromCamera();
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
