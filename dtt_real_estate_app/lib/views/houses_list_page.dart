import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';
import 'package:intl/intl.dart';
import 'house_detail_page.dart';
import '../models/house.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/build_house_list_widget.dart';
import '../widgets/searchbar_widget.dart';
import '../blocs/house_list_manage_blocs/house_list_manage_bloc.dart';
import '../states/house_list_manage_states/house_list_manage_states.dart';
import '../events/house_list_manage_events/house_list_manage_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HousesListPage extends StatelessWidget {
  final List<House> allHouses;
  final LatLng currentLocation;

  HousesListPage({required this.allHouses, required this.currentLocation});

// this is where we build the context with all the available widgets that we created before
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HouseListManageBloc, HouseListManageState>(
      builder: (context, houseListManageState) {

        // Specify houses that need to be shown. Bloc logic is so that the state always contains list to be shown
        List<House> housesToShow = houseListManageState.houses;

        return Container(
          color: Palette.lightgray,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,  // Set cross-axis alignment to start (left)
            children: [
              SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
                child: Text(
                    "DTT REAL ESTATE",
                    style: CustomTextStyles.title03
                ),
              ),
              Padding( // Using the SearchBar widget here
                padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
                child: CustomSearchBar(
                  onSearchChanged: (searchText) {
                    BlocProvider.of<HouseListManageBloc>(context).add(SearchTextChanged(searchText));
                  },
                ),
              ),
              Padding( // Insert the sorting button here
                padding: EdgeInsets.symmetric(horizontal: 6.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,  // This will push all elements to the edges of the row
                  children: [  // Start of children list
                    GestureDetector(
                      onTap: () {
                        if (houseListManageState.sortAscendingByPrice) {
                          BlocProvider.of<HouseListManageBloc>(context).add(SortHousesByPriceEvent(false));
                        } else {
                          BlocProvider.of<HouseListManageBloc>(context).add(
                              SortHousesByPriceEvent(true));
                        }
                      },
                      child: Container(
                        child: Icon(
                          Icons.sort,
                          size: 5.w,  // Adjust size as needed
                        ),
                      ),
                    )
                  ],  // End of children list
                ),
              ),

              Expanded(
                child: BuildHouseListWidget(houses: housesToShow, currentLocation: currentLocation),
              ),

            ],
          ),
        );
      }
    );
  }
}
