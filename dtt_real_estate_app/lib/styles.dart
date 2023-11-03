import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTextStyles {
  static final title01 = TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w900, color: Palette.strong);
  static final title02 = TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w900, color: Palette.strong);
  static final title03 = TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500, color: Palette.strong);
  static final body = TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w300, color: Palette.medium, height: 1.2);
  static final bodystrong = TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w300, color: Palette.strong);
  static final input = TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w200, color: Palette.strong);
  static final hint = TextStyle(fontSize: 9.sp, fontWeight: FontWeight.w300, color: Palette.medium);
  static final subtitle = TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w400, color: Palette.medium);
  static final detail = TextStyle(fontSize: 7.sp, fontWeight: FontWeight.w400, color: Palette.medium);
  static final search = TextStyle(fontSize: 11.sp, fontWeight: FontWeight.w300, color: Palette.light);
}

class Palette {
  static const Color red = Color(0xFFe65541);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightgray = Color(0xFFF7F7F7);
  static const Color darkgray = Color(0xFFEBEBEB);
  static const Color strong = Color(0xCC000000);
  static const Color medium = Color(0x66000000);
  static const Color light = Color(0x33000000);
}
