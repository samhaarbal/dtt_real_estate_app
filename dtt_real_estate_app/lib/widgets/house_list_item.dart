import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../views/house_detail_page.dart';
import '../models/house.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';
import '../widgets/house_list_tile_content.dart';
import '../blocs/house_list_manage_blocs/image_load_bloc.dart';
import '../states/house_list_manage_states/image_load_states.dart';
import '../events/house_list_manage_events/image_load_event.dart';

class HouseListItem extends StatelessWidget {
  final House house;
  final Widget calculatedDistance;

  HouseListItem({required this.house, required this.calculatedDistance});

  @override
  Widget build(BuildContext context) {
    // Create an instance of ImageLoadBloc
    final imageLoadBloc = ImageLoadBloc();

    // Add the LoadImage event
    imageLoadBloc.add(LoadImage(
      imageUrl: 'https://intern.d-tt.nl/${house.image}',
      filename: 'house_${house.id}.jpg',
    ));

    // Provide the existing bloc to the widget tree
    return BlocProvider.value(
      value: imageLoadBloc,
      child: Padding(
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
                  // Replace Image.network with a BlocBuilder
                  BlocBuilder<ImageLoadBloc, ImageState>(
                    builder: (context, state) {
                      if (state is ImageLoadSuccess) {
                        return Container(
                          width: 10.h,
                          height: 10.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.file(
                              state.image,
                              fit: BoxFit.cover,
                              width: 10.h,
                              height: 10.h,
                            ),
                          ),
                        );
                      } else {
                        // Fallback placeholder image
                        print('Placeholder');
                        return Container(
                          width: 10.h,
                          height: 10.h,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              'Images/place_holder.png',
                              fit: BoxFit.cover,
                              width: 10.h,
                              height: 10.h,
                            ),
                          ),
                        );
                      }
                    },
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
      ),
    );
  }
}
