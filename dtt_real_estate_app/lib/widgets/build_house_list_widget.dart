import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/house.dart';
import '../widgets/calculate_distance_widget.dart';
import '../widgets/house_list_item.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';
import 'package:latlong2/latlong.dart';
import '../blocs/house_list_manage_blocs/image_load_bloc.dart';

class BuildHouseListWidget extends StatelessWidget {
  final List<House> houses;
  final LatLng currentLocation;

  BuildHouseListWidget({required this.houses, required this.currentLocation});

  @override
  Widget build(BuildContext context) {
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
    } else {
      return ListView.builder(
        itemCount: houses.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final house = houses[index];
          final calculatedDistance = DistanceWidget(
              currentLocation: currentLocation,
              houseLatitude: house.latitude,
              houseLongitude: house.longitude
          );
          return HouseListItem(house: house, calculatedDistance: calculatedDistance);
        },
      );
    }
  }
}



