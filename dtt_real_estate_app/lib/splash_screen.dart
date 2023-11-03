import 'package:flutter/material.dart';
import 'styles.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.red, // same as your native splash
      body: Center(
        child: Image.asset('Images/launcher_icon.png', width: 100, height: 100,), // same image as native splash
      ),
    );
  }
}
