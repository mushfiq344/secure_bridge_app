import 'package:flutter/material.dart';

import 'color_codes.dart';
import 'constants.dart';
import 'dimens.dart';

const labelStyle = TextStyle(
  fontSize: kMargin16,
  color: kLabelColor,
);
const valueStyle = TextStyle(
  fontSize: kMargin16,
  color: Colors.black,
);
const noValueStyle = TextStyle(
    fontSize: kMargin16, color: kInactiveColor, fontStyle: FontStyle.italic);
const linkStyle = TextStyle(
  color: kAccentColor,
  fontSize: kMargin16,
  //fontWeight: FontWeight.w500,
  decoration: TextDecoration.underline,
);
const attachmentStyle =
    TextStyle(color: kCustomTextFieldInfoColor, fontSize: kMargin16);
const textButtonStyle = TextStyle(
    color: kCustomTextFieldInfoColor,
    fontSize: kMargin16,
    fontWeight: FontWeight.bold);
const titleStyle = TextStyle(
  fontSize: kMargin24,
  color: Colors.black,
  fontWeight: FontWeight.w300,
);

TextStyle statusStyle(String status) {
  Color textColor = kInactiveColor;

  if (status == kDrafted) {
    textColor = kInactiveColor;
  } else if (status == kSubmitted) {
    textColor = kSubmittedColor;
  }
  if (status == kApproved) {
    textColor = kApprovedColor;
  }
  if (status == kRejected) {
    textColor = kRejectedColor;
  }

  return TextStyle(
    fontSize: kMargin16,
    color: textColor,
    fontWeight: FontWeight.w900,
  );
}

TextStyle legendStatusStyle(String status) {
  Color textColor = kInactiveColor;

  if (status == kDrafted) {
    textColor = kInactiveColor;
  } else if (status == kSubmitted) {
    textColor = kSubmittedColor;
  } else if (status == kApproved) {
    textColor = kApprovedColor;
  } else if (status == kRejected) {
    textColor = kRejectedColor;
  }

  return TextStyle(
    fontSize: kMargin16,
    color: textColor,
  );
}

const unselectedTabStyle = TextStyle(
  color: kLabelColor,
  fontSize: kMargin18,
  fontWeight: FontWeight.w400,
);
const selectedTabStyle = TextStyle(
  color: kAccentColor,
  fontSize: kMargin18,
  fontWeight: FontWeight.w400,
);

const actionButtonStyle = TextStyle(
  fontSize: kMargin16,
  color: Colors.white,
  fontWeight: FontWeight.bold,
);
const actionStyle = TextStyle(
  fontSize: kMargin16,
  color: Colors.red,
  fontWeight: FontWeight.bold,
);
const actionStyleGrey = TextStyle(
  fontSize: kMargin16,
  fontWeight: FontWeight.bold,
  color: kBorderColor,
);
const bottomSheetTitleStyle = TextStyle(
  fontSize: kMargin20,
  color: Colors.white,
  fontWeight: FontWeight.w900,
);

const smallLabel = TextStyle(
  fontSize: kMargin14,
  color: Color(0xFF5F5F5F),
  fontWeight: FontWeight.w500,
);

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
