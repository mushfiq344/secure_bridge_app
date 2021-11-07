import 'dart:convert';
import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:secure_bridges_app/Models/Opportunity.dart';
import 'package:secure_bridges_app/features/opportunity/enrolled_user.dart';
import 'package:secure_bridges_app/screen/login.dart';
import 'package:secure_bridges_app/network_utils/api.dart';
import 'package:secure_bridges_app/utility/urls.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/utls/styles.dart';
import 'package:secure_bridges_app/widgets/PAButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';
class OpportunityDetail extends StatefulWidget {
  final Opportunity opportunity;
  final String uploadPath;
  final userId;

  OpportunityDetail(this.opportunity, this.uploadPath,this.userId);
  @override
  _OpportunityDetailState createState() => _OpportunityDetailState();
}

class _OpportunityDetailState extends State<OpportunityDetail> {
  bool userEnrolled=false;
  int userCode;
  final TextEditingController codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String code;
  @override
  void initState() {
    super.initState();
    getOpportunityDetail(widget.opportunity.id);
  }

  void getOpportunityDetail(int oppurtunityId) async{
    try {
      EasyLoading.show(status: kLoading);

      // EasyLoading.show(status: kLoading);
      var res = await Network().getData( "${OPPORTUNITIES_URL}/${oppurtunityId}");
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : ${body}");
      if (res.statusCode == 200) {
       setState(() {
         userEnrolled=body['data']['is_user_enrolled'];
         userCode=body['data']['user_code'];
       });
        EasyLoading.dismiss();

      } else {
        EasyLoading.dismiss();
        EasyLoading.showError(body['message']);
      }


    } catch (e) {
      EasyLoading.dismiss();
      EasyLoading.showError(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kOpportunities),
        backgroundColor: kPurpleColor,
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding:
              EdgeInsets.symmetric(vertical: kMargin12, horizontal: kMargin12),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      child: AspectRatio(
                    aspectRatio: 1 / .5,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(kRadius10),
                      ),
                      child: CachedNetworkImage(
                        imageUrl:
                            "${BASE_URL}${widget.uploadPath}${widget.opportunity.coverImage}",
                        placeholder: (context, url) =>
                            Image(image: AssetImage(kPlaceholderImagePath)),
                        errorWidget: (context, url, error) =>
                            Image(image: AssetImage(kPlaceholderImagePath)),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ))
                ],
              ),
              SizedBox(
                height: kMargin12,
              ),
              Row(
                children: [
                  Expanded(
                      child: Center(
                          child: Text(widget.opportunity.title,
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: kMargin24))))
                ],
              ),
              SizedBox(
                height: kMargin12,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(kIconBackgroundPath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Image(
                                width: 50,
                                height: 50,
                                image: AssetImage(kIconRewardPath),
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: kMargin4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Offered By",
                                  style: TextStyle(
                                      fontSize: kMargin12,
                                      color: kInactiveColor),
                                ),
                                Text("Jet Constellations")
                              ],
                            ),
                          )
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(kIconBackgroundPath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Image(
                                width: 50,
                                height: 50,
                                image: AssetImage(kIconRewardPath),
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: kMargin4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Reward",
                                  style: TextStyle(
                                      fontSize: kMargin12,
                                      color: kInactiveColor),
                                ),
                                Text("${widget.opportunity.reward}\$")
                              ],
                            ),
                          )
                        ],
                      )),
                ],
              ),
              SizedBox(
                height: kMargin12,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(kIconBackgroundPath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Image(
                                width: 50,
                                height: 50,
                                image: AssetImage(kIconRewardPath),
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: kMargin4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Date",
                                  style: TextStyle(
                                      fontSize: kMargin12,
                                      color: kInactiveColor),
                                ),
                                Text("${widget.opportunity.opportunityDate}")
                              ],
                            ),
                          )
                        ],
                      )),
                  Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(kIconBackgroundPath),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              child: Image(
                                width: 50,
                                height: 50,
                                image: AssetImage(kIconLocationPath),
                              )),
                          Padding(
                            padding: EdgeInsets.only(left: kMargin4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Location",
                                  style: TextStyle(
                                      fontSize: kMargin12,
                                      color: kInactiveColor),
                                ),
                                Text("Milwaukee, WI")
                              ],
                            ),
                          )
                        ],
                      )),
                ],
              ),
              SizedBox(
                height: kMargin24,
              ),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: PAButton("habits", true, () {
                        EasyLoading.showToast(kComingSoon);
                      },
                          fillColor: kGreyBackgroundColor,
                          textColor: Colors.orange,
                          capitalText: false),
                    ),
                    Expanded(
                      flex: 1,
                      child: PAButton("productivity", true, () {
                        EasyLoading.showToast(kComingSoon);
                      },
                          fillColor: kGreyBackgroundColor,
                          textColor: Colors.orange,
                          capitalText: false),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: kMargin24,
              ),
              Container(
                child: Row(
                  children: [
                    userEnrolled?Expanded(
                      flex: 1,
                      child: PAButton("View your Code", true, () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Container(
                                  child: Row(
                                    children: [
                                      Expanded(child: Text("Your validation code for this opportunity is $userCode")),
                                      GestureDetector(
                                        child: Icon(Icons.copy),
                                        onTap: (){
                                          Clipboard.setData(ClipboardData(text: "$userCode"));

                                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text("Copied to clipboard!"),
                                          ));

                                        },
                                      )

                                    ],
                                  ),
                                ));

                            });

                      },
                          fillColor: kGreyBackgroundColor,
                          textColor: Colors.orange,
                          capitalText: false),
                    ):SizedBox(),

                  ],
                ),
              ),
              if (widget.userId==widget.opportunity.createdBy) Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: PAButton("View Enrolled User", true, () {
                          Navigator.push(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) =>
                                      EnrolledOpportunityUser(this.widget.opportunity)));
                        },
                            fillColor: kGreyBackgroundColor,
                            textColor: Colors.orange,
                            capitalText: false),
                      ),

                    ],
                  ),
                  SizedBox(height: 10,),
                  Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: PAButton("Test Code", true, () {
                          showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: Form(
                                    key: _formKey,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextFormField(

                                            style: TextStyle(color: Color(0xFF000000)),
                                            cursorColor: Color(0xFF9b9b9b),
                                            keyboardType: TextInputType.text,
                                            decoration: InputDecoration(
                                              prefixIcon: Icon(
                                                Icons.approval,
                                                color: Colors.grey,
                                              ),
                                              hintText: "Code",
                                              hintStyle: TextStyle(
                                                  color: Color(0xFF9b9b9b),
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.normal),
                                            ),
                                            validator: (codeValue) {
                                              if (codeValue.isEmpty) {
                                                return 'Please enter code';
                                              }
                                              code = codeValue;
                                              return null;
                                            },
                                          ),
                                        ),
                                        PAButton('Check', true, (){
                                          if (_formKey.currentState.validate()) {

                                            _confirmUser(widget.opportunity.id,code);
                                          }
                                        },fillColor: kGreyBackgroundColor,textColor: Colors.orange,capitalText: false,)
                                      ],
                                    ),
                                  ),
                                );
                              });
                        },
                            fillColor: kGreyBackgroundColor,
                            textColor: Colors.orange,
                            capitalText: false),
                      ),

                    ],
                  ),
                ],
              ) else SizedBox()
            ],
          ),
        ),
      ),
    );
  }

  _confirmUser(int opportunityId, String code) async{
    try {

      var data = {'opportunity_id': opportunityId, 'code': code};
      EasyLoading.show(status: kLoading);
      var res = await Network().postData(data, 'api/check-enrollment');
      var body = json.decode(res.body);
      // log("res ${res.statusCode}");
      log("body : ${body}");
      if (res.statusCode == 200) {
        EasyLoading.dismiss();
        if(body['data']['user_is_enrolled']){
          EasyLoading.showSuccess("This Code Is Valid");
        }else{
          EasyLoading.showError("This Code Is invalid");
        }
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
