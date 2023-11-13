import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';

/// A widget that displays an icon next to some text.
///
/// This widget is used to create a row with an SVG icon and a text label.
/// It's typically used in lists or detail pages where an icon needs to be
/// accompanied by some descriptive text.
class IconTextGroup extends StatelessWidget {
  /// Path to the icon's SVG asset.
  final String iconPath;

  /// The text to display next to the icon.
  final String text;

  /// Creates an IconTextGroup.
  ///
  /// Requires [iconPath] to be the path of the icon's SVG asset and
  /// [text] as the description to display next to the icon.
  IconTextGroup({required this.iconPath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(Palette.medium, BlendMode.srcIn),
          child: SvgPicture.asset(iconPath, width: 2.w, height: 2.h),
        ),
        SizedBox(width: 1.w), // Spacing between icon and text
        Text(text, style: CustomTextStyles.detail),
      ],
    );
  }
}
