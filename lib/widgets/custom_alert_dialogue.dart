import 'package:flutter/material.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/dimens.dart';

import 'PAButton.dart';

class CustomAlertDialogue extends StatelessWidget {
  final String title;
  final String descripton;
  CustomAlertDialogue(this.title, this.descripton);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Builder(
        builder: (context) {
          // Get available height and width of the build area of this widget. Make a choice depending on the size.
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;

          return Container(
            decoration: BoxDecoration(
                color: kAlertDialogBackgroundColor,
                borderRadius: BorderRadius.all(Radius.circular(20.0))),
            height: height * .5,
            width: width * .75,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: kMargin24,
                        fontWeight: FontWeight.bold,
                        color: kPurpleColor),
                  ),
                  SizedBox(
                    height: 33,
                  ),
                  Text(
                    descripton,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 33,
                  ),
                  PAButton(
                    "Ok",
                    true,
                    () {
                      Navigator.of(context).pop();
                    },
                    fillColor: kPurpleColor,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
