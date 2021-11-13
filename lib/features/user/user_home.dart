import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/constants.dart';
import 'package:secure_bridges_app/utls/dimens.dart';
import 'package:secure_bridges_app/widgets/input_decoration.dart';

class UserHome extends StatefulWidget {
  @override
  _UserHomeState createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Home"),
        backgroundColor: kPurpleColor,
      ),
      body: Container(
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: kMargin16, vertical: kMargin16),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    color: kPinkBackground,
                    borderRadius: BorderRadius.all(Radius.circular(29))),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: kMargin48, horizontal: kMargin32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "AWARENESS TOGETHER",
                        style: TextStyle(
                            fontSize: 36,
                            color: kPurpleColor,
                            fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "Find what fascinates you as you explore these habit courses.",
                        style: TextStyle(
                            fontSize: 10,
                            color: kPurpleColor,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: kMargin20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: AspectRatio(
                      aspectRatio: 1 / 1,
                      child: Card(
                        color: kPurpleBackGround,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26)),
                        child: Image(
                          image: AssetImage(kHomeWhiteIconPath),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: kPurpleBackGround,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26)),
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Card(
                          color: kPurpleBackGround,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26)),
                          child: Image(
                            image: AssetImage(kMultipleUsersIconPath),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: kPurpleBackGround,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26)),
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Card(
                          color: kPurpleBackGround,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26)),
                          child: Image(
                            image: AssetImage(kAidIconPath),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Card(
                      color: kPurpleBackGround,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26)),
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Card(
                          color: kPurpleBackGround,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(26)),
                          child: Image(
                            image: AssetImage(kPizzaIconPath),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: kMargin20,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: FormBuilderDropdown(
                      name: 'gender',
                      decoration: customInputDecoration("Popular"),
                      // initialValue: 'Male',
                      allowClear: true,

                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required(context)]),
                      items: ["male", "female", "others"]
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text('$gender'),
                              ))
                          .toList(),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FormBuilderDropdown(
                      name: 'gender',
                      decoration: customInputDecoration("Filters"),
                      // initialValue: 'Male',
                      allowClear: true,

                      validator: FormBuilderValidators.compose(
                          [FormBuilderValidators.required(context)]),
                      items: ["male", "female", "others"]
                          .map((gender) => DropdownMenuItem(
                                value: gender,
                                child: Text('$gender'),
                              ))
                          .toList(),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
