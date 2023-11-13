import 'package:flutter/material.dart';
import '../models/house.dart';
import '../widgets/custom_distance_calculator.dart';
import '../widgets/house_list_item.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';
import 'package:latlong2/latlong.dart';

/// A widget that builds a list of houses, each with a calculated distance from the current location.
class BuildHouseListWidget extends StatelessWidget {
  /// The list of [House] objects to display.
  final List<House> houses;

  /// The current location as a [LatLng] object.
  final LatLng currentLocation;

  /// Creates a [BuildHouseListWidget] with a given list of [houses] and the [currentLocation].
  BuildHouseListWidget({required this.houses, required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    // If the list of houses is empty, show a 'No results' message and image.
    if (houses.isEmpty) {
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('Images/search_state_empty.png', width: 60.w),
              SizedBox(height: 5.h),
              Text('No results found!', style: CustomTextStyles.search),
              Text('Perhaps try another search?', style: CustomTextStyles.search),
            ],
          ),
        ),
      );
    }

    // If the list of houses is not empty, build a ListView of HouseListItems.
    else {
      return ListView.builder(
        itemCount: houses.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          // Get the house for the current index.
          final house = houses[index];

          // Instantiate the DistanceCalculator with the necessary parameters.
          CustomDistanceCalculator calculator = CustomDistanceCalculator(
            currentLocation: currentLocation,
            houseLatitude: house.latitude,
            houseLongitude: house.longitude,
          );

          // Calculate the distance and store it as a string.
          String calculatedDistanceString = calculator.calculateDistance();

          // Return a list item for the house.
          return HouseListItem(house: house, calculatedDistance: calculatedDistanceString);
        },
      );
    }
  }
}
