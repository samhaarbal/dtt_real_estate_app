import 'package:flutter/material.dart';
import '../models/house.dart';
import 'package:sizer/sizer.dart';
import '../utils/styles.dart';
import 'package:intl/intl.dart';
import '../widgets/location_map_widget.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../widgets/icon_text_group.dart';
import '../blocs/house_list_manage_blocs/image_load_bloc.dart';
import '../states/house_list_manage_states/image_load_states.dart';
import '../events/house_list_manage_events/image_load_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';

/// Static constant for placeholder image asset path.
const String _placeholderImagePath = 'Images/place_holder.png';

/// A page that displays detailed information about a specific house.
///
/// This includes an image of the house, the price, a description, and the location
/// on a map. It also supports launching the location in an external map application.
class HouseDetailPage extends StatefulWidget {
  /// The house to display.
  final House house;

  /// The calculated distance from the user to the house as a string.
  final String calculatedDistance;

  /// The URL for the house's image.
  final String imageUrl;

  /// The identifier for the house's image.
  final String imageId;

  HouseDetailPage({
    required this.house,
    required this.calculatedDistance,
    required this.imageUrl,
    required this.imageId,
  });

  @override
  _HouseDetailPageState createState() => _HouseDetailPageState();
}

/// The state for [HouseDetailPage] which handles the dynamic aspects of the page.
class _HouseDetailPageState extends State<HouseDetailPage> {
  /// The opacity of the app bar which changes based on the scroll position.
  double appBarOpacity = 0.0;

  /// The controller for the scrollable content in the page.
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Setting up a listener for scroll events to adjust the app bar's opacity.
    _scrollController.addListener(_scrollListener);
    // Initiating the image loading process for the house's image.
    BlocProvider.of<ImageLoadBloc>(context, listen: false).add(
      LoadImage(widget.imageUrl, widget.imageId),
    );
  }

  /// Listens to scroll events to adjust the app bar's opacity.
  void _scrollListener() {
    double newOpacity = _scrollController.offset > 0 ? 0.2 : 0.0;
    if (appBarOpacity != newOpacity) {
      setState(() {
        appBarOpacity = newOpacity;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Building the page content as a stack of the house's image and details.
    return Scaffold(
      body: Stack(
        children: [
          // Handles the state of the image loading and renders the appropriate widget.
          BlocBuilder<ImageLoadBloc, ImageState>(
            builder: (context, state) {
              return state is ImageLoadSuccess
                  ? _buildImage(state.loadedImages[widget.imageId])
                  : _buildPlaceholder();
            },
          ),
          // The main content of the page including the app bar and house details.
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              _buildSliverAppBar(),
              _buildHouseDetailsSliver(),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the image widget for the house's image or a placeholder if the image is not available.
  Widget _buildImage(File? imageFile) {
    return Image.file(
      imageFile ?? File(''),
      fit: BoxFit.cover,
      height: 35.h,
      width: double.infinity,
      errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
    );
  }

  /// Builds a placeholder image widget when the house's image is not available.
  Widget _buildPlaceholder() {
    return Image.asset(
      _placeholderImagePath,
      fit: BoxFit.cover,
      height: 35.h,
      width: double.infinity,
    );
  }

  /// Builds the sliver app bar that fades based on the scroll position.
  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 25.h,
      backgroundColor: Colors.transparent.withOpacity(appBarOpacity),
      elevation: 0, // Removes shadow for a cleaner look.
      flexibleSpace: Container(), // Empty container for customization purposes.
    );
  }

  /// Builds the sliver that contains the house details.
  Widget _buildHouseDetailsSliver() {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: _buildHouseDetails(),
    );
  }

  /// Builds the details about the house, including price, description, and location.
  Widget _buildHouseDetails() {
    return Container(
      // Decorative aspects of the details container.
      decoration: BoxDecoration(
        color: Palette.lightgray,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      // Internal padding for the details container.
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 6.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPriceAndIconTextGroups(),
            _buildDescription(),
            _buildLocation(),
          ],
        ),
      ),
    );
  }

  /// Builds the row containing the price and icons for the house details.
  Widget _buildPriceAndIconTextGroups() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Displays the formatted price of the house.
          Text(
            '\$${NumberFormat("#,###").format(widget.house.price)}',
            style: CustomTextStyles.title03,
          ),
          // Builds a row of icons and text for house attributes.
          _buildIconTextGroups(),
        ],
      ),
    );
  }

  /// Builds a row of IconTextGroup widgets to represent house attributes.
  Widget _buildIconTextGroups() {
    return Row(
      children: [
        // An icon and text group for the number of bedrooms.
        IconTextGroup(iconPath: 'Icons/ic_bed.svg', text: '${widget.house.bedrooms}'),
        SizedBox(width: 3.w),
        // An icon and text group for the number of bathrooms.
        IconTextGroup(iconPath: 'Icons/ic_bath.svg', text: '${widget.house.bathrooms}'),
        SizedBox(width: 3.w),
        // An icon and text group for the house size.
        IconTextGroup(iconPath: 'Icons/ic_layers.svg', text: '${widget.house.size}'),
        SizedBox(width: 3.w),
        // An icon and text group for the calculated distance to the house.
        IconTextGroup(iconPath: 'Icons/ic_location.svg', text: widget.calculatedDistance),
      ],
    );
  }

  /// Builds the description section of the house details.
  Widget _buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Heading for the description section.
        Text(
          'Description',
          style: CustomTextStyles.title03,
        ),
        SizedBox(height: 2.h),
        // The actual text of the house's description.
        Text(
          widget.house.description,
          style: CustomTextStyles.body,
        ),
        SizedBox(height: 2.h), // Spacing after the description for separation.
      ],
    );
  }

  /// Builds the location section, including a map and a clickable overlay.
  Widget _buildLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // The title for the location section.
        Text(
          'Location',
          style: CustomTextStyles.title03,
        ),
        SizedBox(height: 4.h),
        // A stack with a map widget and a clickable overlay to launch the map URL.
        Stack(
          children: [
            Container(
              height: 40.h,
              // The map widget showing the house location.
              child: LocationMapWidget(
                latitude: widget.house.latitude,
                longitude: widget.house.longitude,
              ),
            ),
            Positioned.fill(
              // An invisible overlay that responds to taps to launch an external map.
              child: GestureDetector(
                onTap: () {
                  _launchURL('https://www.google.com/maps/search/?api=1&query=${widget.house.latitude},${widget.house.longitude}');
                },
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 4.h),
      ],
    );
  }

  /// Launches a URL string in an external browser or application.
  /// Helper method to launch a URL in the browser.
  void _launchURL(String url) async {
    try {
      await launchUrlString(url);
    } catch (e) {
      // Log the error
      print('Could not launch $url: $e');
      // Inform the user of the failure using a SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Could not launch the website. Please check your connection and try again.'),
        ),
      );
    }
  }

  @override
  void dispose() {
    // Cleaning up the controller when the widget is disposed of.
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }
}