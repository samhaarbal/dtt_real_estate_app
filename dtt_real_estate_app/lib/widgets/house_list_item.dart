import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../views/house_detail_page.dart';
import '../models/house.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';
import '../widgets/house_list_tile_content.dart';
import '../blocs/house_list_manage_blocs/image_load_bloc.dart';
import '../states/house_list_manage_states/image_load_states.dart';
import '../events/house_list_manage_events/image_load_event.dart';

/// A list item widget that represents a single house in a list.
///
/// It is responsible for handling the layout of the house's image, details,
/// and navigation to the house's detail page.
class HouseListItem extends StatelessWidget {
  /// The [House] object that contains details about the house.
  final House house;

  /// A [Widget] displaying the calculated distance to the house.
  final String calculatedDistance;

  /// Creates a [HouseListItem] with the given [house] and [calculatedDistance].
  HouseListItem({required this.house, required this.calculatedDistance});

  @override
  Widget build(BuildContext context) {
    // Dispatch the image loading event as soon as the widget is built.
    BlocProvider.of<ImageLoadBloc>(context).add(
        LoadImage('https://intern.d-tt.nl/${house.image}', 'house_${house.id}.jpg')
    );

    return Padding(
      padding: EdgeInsets.only(top: 2.h, left: 6.w, right: 6.w),
      child: InkWell(
        onTap: () {
          // Navigate to the HouseDetailPage on tap.
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => HouseDetailPage(
              house: house,
              calculatedDistance: calculatedDistance,
              imageUrl: 'https://intern.d-tt.nl/${house.image}',
              imageId: 'house_${house.id}.jpg',
            ),
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
                // BlocBuilder to build UI based on ImageLoadBloc state.
                BlocBuilder<ImageLoadBloc, ImageState>(
                  builder: (context, state) {
                    // When the image is successfully loaded, display it.
                    if (state is ImageLoadSuccess) {
                      File? imageFile = state.loadedImages['house_${house.id}.jpg'];
                      return _buildImageContainer(imageFile);
                    }
                    // When the image is loading, show a loading spinner.
                    else if (state is ImageLoadInProgress) {
                      return _buildLoadingContainer();
                    }
                    // By default, show a placeholder image.
                    else {
                      return _buildPlaceholderContainer();
                    }
                  },
                ),
                SizedBox(width: 5.w),
                // Container to hold the content of the house list tile.
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

  /// Builds a container with a loaded image or a placeholder if the image is null.
  Widget _buildImageContainer(File? imageFile) {
    if (imageFile != null) {
      return Container(
        width: 10.h,
        height: 10.h,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.file(
            imageFile,
            fit: BoxFit.cover,
            width: 10.h,
            height: 10.h,
          ),
        ),
      );
    } else {
      return _buildPlaceholderContainer();
    }
  }

  /// Builds a container that indicates an image is loading.
  Widget _buildLoadingContainer() {
    return Container(
      width: 10.h,
      height: 10.h,
      alignment: Alignment.center,
      child: CircularProgressIndicator(),
    );
  }

  /// Builds a container that shows a placeholder when an image is not available.
  Widget _buildPlaceholderContainer() {
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
}
