import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';
import '../models/house.dart';
import 'package:latlong2/latlong.dart';
import '../widgets/build_house_list_widget.dart';
import '../widgets/searchbar_widget.dart';
import '../blocs/house_list_manage_blocs/house_list_manage_bloc.dart';
import '../states/house_list_manage_states/house_list_manage_states.dart';
import '../events/house_list_manage_events/house_list_manage_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/house_list_manage_blocs/image_load_bloc.dart';
import '../events/house_list_manage_events/image_load_event.dart';

/// HousesListPage is a StatelessWidget that presents a list of houses,
/// a search bar, and an option to sort houses by price.
class HousesListPage extends StatelessWidget {
  /// A list containing all house data.
  final List<House> allHouses;

  /// The current user's location.
  final LatLng currentLocation;

  /// A flag indicating if a failure message should be displayed.
  final bool failureMessage;

  /// Constructor for HousesListPage which takes a list of all houses,
  /// the current location, and a failure message flag.
  HousesListPage({
    required this.allHouses,
    required this.currentLocation,
    required this.failureMessage,
  });

  /// A method that creates a list of image filenames from the list of houses.
  List<String> _createFilenamesList() {
    return allHouses.map((house) => 'house_${house.id}.jpg').toList();
  }

  @override
  Widget build(BuildContext context) {
    // Get the filenames list for image management.
    final List<String> filenames = _createFilenamesList();

    // Update locally stored images if the list of filenames is not empty.
    if (filenames.isNotEmpty) {
      BlocProvider.of<ImageLoadBloc>(context).add(UpdateLocallyStoredImages(filenames));
    }

    // Build the UI based on the HouseListManageBloc state.
    return BlocBuilder<HouseListManageBloc, HouseListManageState>(
        builder: (context, houseListManageState) {
          // Houses to show based on the current state.
          List<House> housesToShow = houseListManageState.houses;

          return Container(
            color: Palette.lightgray,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 6.h),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
                  child: Text("DTT REAL ESTATE", style: CustomTextStyles.title03),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
                  child: CustomSearchBar(
                    onSearchChanged: (searchText) {
                      // Trigger the search text change event.
                      BlocProvider.of<HouseListManageBloc>(context).add(SearchTextChanged(searchText));
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // Toggle sorting order when the sort icon is tapped.
                          BlocProvider.of<HouseListManageBloc>(context).add(
                              SortHousesByPriceEvent(!houseListManageState.sortAscendingByPrice)
                          );
                        },
                        child: Icon(Icons.sort, size: 5.w),
                      )
                    ],
                  ),
                ),
                failureMessage
                    ? Expanded(
                  child: Center(
                    child: Text('Failed to load houses. Connect to the internet'),
                  ),
                )
                    : Expanded(
                  child: BuildHouseListWidget(houses: housesToShow, currentLocation: currentLocation),
                ),
              ],
            ),
          );
        }
    );
  }
}
