import 'package:flutter/material.dart';
import '../models/house.dart';
import '../widgets/icon_text_group.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';
import 'package:intl/intl.dart';


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
