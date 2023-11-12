import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart'; // Ensure this file has the CustomTextStyles and Palette defined
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../blocs/house_list_manage_blocs/house_list_manage_bloc.dart';
import '../events/house_list_manage_events/house_list_manage_events.dart';

/// The path to the search icon asset.
const String _searchIconPath = 'Icons/ic_search.svg';
/// The path to the close icon asset.
const String _closeIconPath = 'Icons/ic_close.svg';
/// The height of the search bar.
const double _searchBarHeight = 5.0;
/// The size for the icons used in the search bar.
const double _iconSize = 2.5;
/// The border radius for the search bar.
const double _searchBarBorderRadius = 10.0;
/// Padding for the search bar content.
const EdgeInsets _searchBarPadding = EdgeInsets.symmetric(horizontal: 8.0, vertical: 0);

/// A custom search bar widget that allows users to filter houses based on search criteria.
class CustomSearchBar extends StatefulWidget {
  /// A callback function that is called with the current search text when it changes.
  final Function(String) onSearchChanged;

  /// Constructs a `CustomSearchBar` widget.
  CustomSearchBar({required this.onSearchChanged});

  @override
  _SearchBarState createState() => _SearchBarState();
}

/// The state for the `CustomSearchBar` StatefulWidget.
class _SearchBarState extends State<CustomSearchBar> {
  /// Controller for the text being edited in the search bar.
  final TextEditingController searchController = TextEditingController();

  /// Focus node for the search bar text field.
  final FocusNode searchFocusNode = FocusNode();

  /// Initializes the state by setting up a listener on the focus node.
  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() {
      // When focus is lost, the onSearchChanged callback is called.
      if (!searchFocusNode.hasFocus) {
        widget.onSearchChanged(searchController.text);
      }
    });
  }

  /// Disposes of the controller and focus node when the widget is removed from the widget tree.
  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  /// Builds the search bar widget with styling and behavior.
  @override
  Widget build(BuildContext context) {
    return Container(
      height: _searchBarHeight.h,
      child: TextField(
        controller: searchController,
        focusNode: searchFocusNode,
        onChanged: widget.onSearchChanged,
        style: CustomTextStyles.body,
        cursorColor: Palette.medium,
        decoration: InputDecoration(
          labelText: "Search for a home",
          labelStyle: CustomTextStyles.hint,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          suffixIcon: FittedBox(
            fit: BoxFit.scaleDown,
            child: searchFocusNode.hasFocus
                ? InkWell(
              onTap: () {
                // Clears the search bar text and triggers a clear search event.
                searchController.clear();
                BlocProvider.of<HouseListManageBloc>(context).add(ClearSearchEvent());
                FocusScope.of(context).unfocus(); // Hides the keyboard.
              },
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Palette.strong,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset(_closeIconPath, width: _iconSize.w, height: _iconSize.h),
              ),
            )
                : ColorFiltered(
              colorFilter: ColorFilter.mode(
                Palette.medium,
                BlendMode.srcIn,
              ),
              child: SvgPicture.asset(_searchIconPath, width: _iconSize.w, height: _iconSize.h),
            ),
          ),
          fillColor: Palette.darkgray,
          filled: true,
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(_searchBarBorderRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(_searchBarBorderRadius),
          ),
          contentPadding: _searchBarPadding,
        ),
      ),
    );
  }
}
