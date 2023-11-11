import 'package:flutter/material.dart';
import '../models/house.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import '../widgets/location_map_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../widgets/icon_text_group.dart';
import '../blocs/house_list_manage_blocs/image_load_bloc.dart';
import '../states/house_list_manage_states/image_load_states.dart';
import '../events/house_list_manage_events/image_load_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

class HouseDetailPage extends StatefulWidget { //stateful because of the scrolling possibility, mutable states because of user input
  final House house;
  final Widget calculatedDistance;
  final String imageUrl;
  final String imageId;

  HouseDetailPage({required this.house, required this.calculatedDistance, required this.imageUrl, required this.imageId});

  @override
  _HouseDetailPageState createState() => _HouseDetailPageState();
}

class _HouseDetailPageState extends State<HouseDetailPage> {
  double appBarOpacity = 0.0;
  ScrollController _scrollController = ScrollController();

  // method for the scrollistener. When the user scrolls, the opacity of the appbar should be updated to make it more dark.
  void _scrollListener() {
    if (_scrollController.offset == 0.0) {
      // When the CustomScrollView is fully scrolled down
      if (appBarOpacity != 0) {
        setState(() {
          appBarOpacity = 0;
        });
      }
    } else {
      // Any other scroll position, so even if it's just a little bit upwards
      if (appBarOpacity != 0.2) {
        setState(() {
          appBarOpacity = 0.2;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    BlocProvider.of<ImageLoadBloc>(context, listen: false).add(
      LoadImage('https://intern.d-tt.nl/${widget.house.image}', 'house_${widget.house.id}.jpg'),
    );
  }

// build the context for this page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BlocBuilder<ImageLoadBloc, ImageState>(
            builder: (context, state) {
              if (state is ImageLoadSuccess) {
                File? imageFile = state.loadedImages['house_${widget.house.id}.jpg'];
                if (imageFile != null) {
                  // Image file is not null, safe to use.
                  return Image.file(imageFile, fit: BoxFit.cover, height: 35.h, width: double.infinity);
                } else {
                  // Image file is null, provide a fallback.
                  return Image.asset('Images/place_holder.png', fit: BoxFit.cover, height: 35.h, width: double.infinity);
                }
              }
              // If the image is still loading, show a loading indicator
              else if (state is ImageLoadInProgress) {
                return CircularProgressIndicator();
              }
              // If the image loading has failed, show a placeholder
              else {
                return Image.asset('Images/place_holder.png', fit: BoxFit.cover, height: 35.h, width: double.infinity);
              }
            },
          ),

          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverAppBar(
                expandedHeight: 25.h,
                backgroundColor: Colors.transparent.withOpacity(appBarOpacity),
                elevation: 0, // Remove any shadow
                flexibleSpace: Container(),
              ),
              SliverFillRemaining(
                hasScrollBody: false,
                child: Container(
                  decoration: BoxDecoration(
                    color: Palette.lightgray,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5.h),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,  // to put space between top and bottom containers
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Price to the left
                              Text('\$${NumberFormat("#,###").format(widget.house.price)}', style: CustomTextStyles.title03,),

                              // Container for row with icons
                              Row(
                                children: [
                                  IconTextGroup(
                                    iconPath: 'Icons/ic_bed.svg',
                                    text: '${widget.house.bedrooms}',
                                  ),

                                  SizedBox(width: 3.w), // spacing between text and next icon

                                  IconTextGroup(
                                    iconPath: 'Icons/ic_bath.svg',
                                    text: '${widget.house.bathrooms}',
                                  ),

                                  SizedBox(width: 3.w), // spacing between text and next icon

                                  IconTextGroup(
                                    iconPath: 'Icons/ic_layers.svg',
                                    text: '${widget.house.size}',
                                  ),

                                  SizedBox(width: 3.w), // spacing between text and next icon

                                  // Can't call the IconTextGroup for this one, because the calculatedDistance is of type Future<string>
                                  // which is passed from the houselistpage.
                                  ColorFiltered(
                                    colorFilter: ColorFilter.mode(Palette.medium, BlendMode.srcIn),
                                    child: SvgPicture.asset('Icons/ic_location.svg', width: 2.w, height: 2.h),
                                  ),
                                  SizedBox(width: 1.w),  // spacing between icon and text
                                  widget.calculatedDistance,
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Description',
                            style: CustomTextStyles.title03
                        ),
                        SizedBox(height: 4.h),
                        Text('${widget.house.description}', style: CustomTextStyles.body,),
                        SizedBox(height: 4.h),
                        Text(
                            'Location',
                            style: CustomTextStyles.title03
                        ),
                        SizedBox(height: 4.h),
                        Stack(
                          children: [
                            Container(
                              height: 40.h,
                              child: LocationMapWidget(
                                latitude: widget.house.latitude,
                                longitude: widget.house.longitude,
                              ),
                            ),
                            Positioned.fill(
                              child: GestureDetector(
                                onTap: () {
                                  print('GestureDetector onTap triggered.');
                                  launchUrlString('https://www.google.com/maps/search/?api=1&query=${widget.house.latitude},${widget.house.longitude}');
                                },
                                child: Container(
                                  color: Colors.transparent, // make sure it's transparent
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 4.h),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


// dispose of scrollcontroller when state is disposed of
  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}


