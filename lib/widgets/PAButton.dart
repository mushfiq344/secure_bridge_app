import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/dimens.dart';

class PAButton extends StatelessWidget {
  PAButton(this.buttonText, this.isFilled, this.buttonAction,
      {this.hMargin = kMargin24,
      this.fillColor = kAccentColor,
      this.textColor = Colors.white,
      this.capitalText = true});

  final String buttonText;
  final bool isFilled;
  final Function buttonAction;
  double hMargin;
  Color fillColor;
  Color textColor;
  bool capitalText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: hMargin),
      child: _buildButton(context),
    );
  }

  Widget _buildButton(BuildContext context) {
    return RawMaterialButton(
      elevation: 0.0,
      child: Center(
          child: Text(
        capitalText ? buttonText.toUpperCase() : buttonText,
        style: TextStyle(color: textColor),
      )),
      textStyle: TextStyle(
        fontSize: kMargin16,
        color: isFilled ? Colors.white : fillColor,
        fontWeight: FontWeight.bold,
      ),
      fillColor: isFilled ? fillColor : Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(kRadius10)),
        side: BorderSide(color: fillColor),
      ),
      padding: EdgeInsets.symmetric(vertical: kMargin18, horizontal: 5),
      onPressed: () {
        FocusScope.of(context).requestFocus(FocusNode());
        buttonAction();
      },
    );
  }
}
