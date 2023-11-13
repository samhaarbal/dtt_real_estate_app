import 'package:flutter/material.dart';
import '../models/house.dart';
import '../widgets/icon_text_group.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';
import 'package:intl/intl.dart';

/// A widget that displays content for a list tile representing a house.
///
/// This includes the house's price, location, number of bedrooms, bathrooms,
/// size, and the calculated distance widget passed to it.
class HouseListTileContent extends StatelessWidget {
  /// The [House] object containing data to display.
  final House house;

  /// A [Widget] displaying the calculated distance to the house.
  final String calculatedDistance;

  /// Creates a [HouseListTileContent] widget that requires a [House] object
  /// and a [Widget] for the calculated distance.
  HouseListTileContent({required this.house, required this.calculatedDistance});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('\$${NumberFormat("#,###").format(house.price)}', style: CustomTextStyles.title03),
            Text('${house.zip} ${house.city}', style: CustomTextStyles.subtitle),
          ],
        ),
        Row(
          children: [
            IconTextGroup(iconPath: 'Icons/ic_bed.svg', text: '${house.bedrooms}'),
            SizedBox(width: 3.w),
            IconTextGroup(iconPath: 'Icons/ic_bath.svg', text: '${house.bathrooms}'),
            SizedBox(width: 3.w),
            IconTextGroup(iconPath: 'Icons/ic_layers.svg', text: '${house.size}'),
            SizedBox(width: 3.w),
            IconTextGroup(iconPath: 'Icons/ic_location.svg', text: calculatedDistance),
          ],
        ),
      ],
    );
  }
}
