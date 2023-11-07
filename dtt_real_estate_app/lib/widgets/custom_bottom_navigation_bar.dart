import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onIndexChanged;

  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onIndexChanged,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      selectedItemColor: Colors.blue, // Example color, replace with your own
      unselectedItemColor: Colors.grey, // Example color, replace with your own
      items: [
        BottomNavigationBarItem(
          icon: ColorFiltered(
              colorFilter: ColorFilter.mode(
                currentIndex == 0 ? Palette.strong : Palette.light,
                BlendMode.srcIn,
              ),
              child: SvgPicture.asset('Icons/ic_home.svg', width: 4.w, height: 4.h)),
          label: 'Houses',
        ),
        BottomNavigationBarItem(
          icon: ColorFiltered(
            colorFilter: ColorFilter.mode(
              currentIndex == 1 ? Palette.strong : Palette.light,
              BlendMode.srcIn,
            ),
            child: SvgPicture.asset('Icons/ic_info.svg', width: 4.w, height: 4.h),
          ),
          label: 'Info',
        ),
      ],
    );
  }
}
