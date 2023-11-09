import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../blocs/house_list_manage_blocs/house_list_manage_bloc.dart';
import '../events/house_list_manage_events/house_list_manage_events.dart';

class CustomSearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;

  CustomSearchBar({required this.onSearchChanged});

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<CustomSearchBar> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    searchFocusNode.addListener(() {
      if (!searchFocusNode.hasFocus) {
        widget.onSearchChanged(searchController.text);
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.h,
      child: TextField(
        controller: searchController,
        focusNode: searchFocusNode,
        onChanged: widget.onSearchChanged,
        style: CustomTextStyles.body,
        cursorColor: Palette.medium,
        decoration: InputDecoration(
          labelText: ("Search for a home"),
          labelStyle: CustomTextStyles.hint,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          suffixIcon: FittedBox(
            fit: BoxFit.scaleDown,
            child: searchFocusNode.hasFocus
                ? InkWell(
              onTap: () {
                // Clear the text in the search bar when the close icon is tapped
                setState(() {
                  searchController.clear();
                  BlocProvider.of<HouseListManageBloc>(context).add(ClearSearchEvent());
                  FocusScope.of(context).unfocus();// Remove focus from the search bar and hide the keyboard
                });
              },
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Palette.strong,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset('Icons/ic_close.svg', width: 2.5.w, height: 2.5.h),
              ),
            )
                : ColorFiltered(
              colorFilter: ColorFilter.mode(
                Palette.medium,
                BlendMode.srcIn,
              ),
              child: SvgPicture.asset('Icons/ic_search.svg', width: 2.5.w, height: 2.5.h),
            ),
          ),
          fillColor: Palette.darkgray,
          filled: true,
          // Remove the border
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),  // Rounded corners
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),  // Rounded corners
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        ),
        // Rest of your TextField code...
      ),
    );
  }
}
