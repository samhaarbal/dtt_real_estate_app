import 'package:flutter/material.dart';
import '../utils/styles.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.red, // same as your native splash
      body: Center(
        child: SvgPicture.asset(
          'Icons/ic_dtt.svg',
          width: 60.sp, // Sizer package is used for responsive sizing
          height: 60.sp,
        ),
      ),
    );
  }
}
