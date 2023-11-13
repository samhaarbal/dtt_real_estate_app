import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';

// Static constants for icon asset paths
const String _homeIconPath = 'Icons/ic_home.svg';
const String _infoIconPath = 'Icons/ic_info.svg';

/// CustomBottomNavigationBar is a widget that creates a bottom navigation bar with a custom design.
///
/// It takes the current index and a callback function to handle index changes.
class CustomBottomNavigationBar extends StatelessWidget {
  /// The current index of the selected item in the navigation bar.
  final int currentIndex;

  /// The callback function to call with a new index when an item is tapped.
  final Function(int) onIndexChanged;

  /// Creates a CustomBottomNavigationBar with the given [currentIndex] and [onIndexChanged] callback.
  CustomBottomNavigationBar({
    required this.currentIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Build a BottomNavigationBar widget with custom styling and behavior.
    return BottomNavigationBar(
      currentIndex: currentIndex, // The current active tab index.
      onTap: onIndexChanged, // Callback when a tab is tapped.
      showSelectedLabels: false, // Do not show labels for the selected item.
      showUnselectedLabels: false, // Do not show labels for the unselected items.
      selectedItemColor: Colors.blue, // Color for the selected item.
      unselectedItemColor: Colors.grey, // Color for the unselected items.
      items: [
        BottomNavigationBarItem(
          // Color filter changes based on the current index for the 'Home' icon.
          icon: ColorFiltered(
              colorFilter: ColorFilter.mode(
                currentIndex == 0 ? Palette.strong : Palette.light,
                BlendMode.srcIn,
              ),
              child: SvgPicture.asset(_homeIconPath, width: 4.w, height: 4.h)),
          label: 'Houses',
        ),
        BottomNavigationBarItem(
          // Color filter changes based on the current index for the 'Info' icon.
          icon: ColorFiltered(
            colorFilter: ColorFilter.mode(
              currentIndex == 1 ? Palette.strong : Palette.light,
              BlendMode.srcIn,
            ),
            child: SvgPicture.asset(_infoIconPath, width: 4.w, height: 4.h),
          ),
          label: 'Info',
        ),
      ],
    );
  }
}
