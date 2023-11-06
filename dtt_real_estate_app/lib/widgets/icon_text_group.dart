import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';

//Create separate class for the IconTextGroup. Separate file so that we can use it in both the houselistpage and housedetailpage.
class IconTextGroup extends StatelessWidget {
  final String iconPath;
  final String text;

  IconTextGroup({required this.iconPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(Palette.medium, BlendMode.srcIn),
          child: SvgPicture.asset(iconPath, width: 2.w, height: 2.h),
        ),
        SizedBox(width: 1.w),  // spacing between icon and text
        Text(text, style: CustomTextStyles.detail,),
      ],
    );
  }
}