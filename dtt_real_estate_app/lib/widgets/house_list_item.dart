import 'package:flutter/material.dart';
import '../views/house_detail_page.dart';
import '../models/house.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';
import '../widgets/house_list_tile_content.dart';

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