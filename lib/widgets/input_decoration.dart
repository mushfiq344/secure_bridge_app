import 'package:flutter/material.dart';
import 'package:secure_bridges_app/utls/color_codes.dart';
import 'package:secure_bridges_app/utls/dimens.dart';

InputDecoration customInputDecoration(String hintText,
    {Color fillColor: Colors.white,
    bool showPrefixIcon = false,
    showSuffixIcon = false,
    String prefixIconPath,
    String suffixIconPath,
    bool hasPrefixIconCallBack = false,
    VoidCallback prefixIconCallBack,
    bool hasSuffixIconCallback = false,
    VoidCallback suffixIconCallback}) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: kBorderColor),
      fillColor: fillColor,
      filled: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadius10),
        borderSide: BorderSide(
          color: fillColor,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(kRadius10),
        borderSide: BorderSide(
          color: Colors.transparent,
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
      prefixIcon: showPrefixIcon
          ? GestureDetector(
              child: Image.asset(prefixIconPath),
              onTap: () {
                if (hasPrefixIconCallBack) {
                  prefixIconCallBack();
                }
              },
            )
          : null,
      suffixIcon: showSuffixIcon
          ? GestureDetector(
              child: Image.asset(suffixIconPath),
              onTap: () {
                if (hasSuffixIconCallback) {
                  suffixIconCallback();
                }
              },
            )
          : null);
}
