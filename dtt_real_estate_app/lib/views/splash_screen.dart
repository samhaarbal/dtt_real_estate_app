import 'package:flutter/material.dart';
import '../utils/styles.dart';
import 'package:sizer/sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Static constant for the SVG asset path.
const String _logoPath = 'Icons/ic_dtt.svg';

/// A widget that displays the splash screen with the application logo.
class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    // Scaffold provides the structure for the splash screen.
    return Scaffold(
      // Background color for the splash screen.
      backgroundColor: Palette.red,
      body: Center(
        // Centering the logo in the middle of the screen.
        child: SvgPicture.asset(
          _logoPath,
          width: 60.sp,
          height: 60.sp,
        ),
      ),
    );
  }
}
