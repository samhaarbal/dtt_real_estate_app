import 'package:flutter/material.dart';
import '../views/house_detail_page.dart';
import '../models/house.dart';
import '../widgets/distance_widget.dart';
import '../widgets/icon_text_group.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

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

class HouseListItem extends StatelessWidget {
  final House house;
  final Widget calculatedDistance;

  HouseListItem({required this.house, required this.calculatedDistance});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 6.w, right: 6.w),
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => HouseDetailPage(house: house, calculatedDistance: calculatedDistance),
          ));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Palette.white,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Palette.darkgray,
                offset: Offset(0, 0),
                blurRadius: 1.0,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(3.w),
            child: Row(
              children: [
                // Image to the left
                Container(
                  width: 10.h,
                  height: 10.h,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      'https://intern.d-tt.nl/${house.image}',
                      fit: BoxFit.cover,
                      width: 10.h,
                      height: 10.h,
                    ),
                  ),
                ),
                SizedBox(width: 5.w),
                // Column for title, subtitle, and the row of icons and texts
                Container(
                  height: 10.h,
                  child: HouseListTileContent(house: house, calculatedDistance: calculatedDistance),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HouseListTileContent extends StatelessWidget {
  final House house;
  final Widget calculatedDistance;

  HouseListTileContent({required this.house, required this.calculatedDistance});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Container for Title and Subtitle
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$${NumberFormat("#,###").format(house.price)}', style: CustomTextStyles.title03),
            Text('${house.zip} ${house.city}', style: CustomTextStyles.subtitle),
          ],
        ),
        // Row at the bottom
        Row(
          children: [
            IconTextGroup(iconPath: 'Icons/ic_bed.svg', text: '${house.bedrooms}'),
            SizedBox(width: 5.w),
            IconTextGroup(iconPath: 'Icons/ic_bath.svg', text: '${house.bathrooms}'),
            SizedBox(width: 5.w),
            IconTextGroup(iconPath: 'Icons/ic_layers.svg', text: '${house.size}'),
            SizedBox(width: 5.w),
            calculatedDistance
          ],
        ),
      ],
    );
  }
}
