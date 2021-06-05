import 'package:flutter/painting.dart';
import 'package:foodz_owner/utils/consts/AppConstant.dart';

class Cols {
  static const black = Color(0xff060518);
  static const white = Color(0xffffffff);
  static const blue = Color(0xff0029FF);
  static const gray = Color(0xffAAAABF);
  static const darkGray = Color(0xff9494A3);
  static const darkSlateBlue = Color(0xff493E83);
}

class Fonts {
  static const String AirbnbCereal = /*'AirbnbCereal'*/ MainFont;
}

class TextStyles {
  static const airbnbCerealMedium = TextStyle(
      color: Cols.white,
      fontWeight: FontWeight.w500,
      fontFamily: /*Fonts.AirbnbCereal*/ MainFont);
  static const airbnbCerealBook = TextStyle(
      color: Cols.white,
      fontWeight: FontWeight.w400,
      fontFamily: /*Fonts.AirbnbCereal*/ MainFont);
}
