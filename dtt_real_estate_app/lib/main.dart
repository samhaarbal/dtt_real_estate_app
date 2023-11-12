import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'blocs/app_initialization_blocs/houses_fetch_bloc.dart';
import 'utils/styles.dart';
import 'views/houses_list_page.dart';
import 'views/about_page.dart';
import 'views/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/app_initialization_blocs/location_permission_bloc.dart';
import 'events/app_initialization_events/houses_fetch_event.dart';
import 'events/app_initialization_events/location_permission_event.dart';
import 'states/app_initialization_states/houses_fetch_states.dart';
import 'states/app_initialization_states/location_permission_states.dart';
import 'package:latlong2/latlong.dart';
import 'widgets/custom_bottom_navigation_bar.dart';
import '../blocs/house_list_manage_blocs/house_list_manage_bloc.dart';
import '../blocs/house_list_manage_blocs/image_load_bloc.dart';

/// Entry point of the Flutter application
void main() {
  runApp(
    // Providing instances of BLoCs to be available throughout the app.
    MultiBlocProvider(
      providers: [
        BlocProvider<LocationPermissionBloc>(
          create: (context) => LocationPermissionBloc(),
        ),
        BlocProvider<HousesFetchBloc>(
          create: (context) => HousesFetchBloc(),
        ),
        BlocProvider(
          create: (context) => ImageLoadBloc(),
          child: MyApp(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

/// The root widget of the application.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Sizer helps with making the UI responsive.
    return Sizer(
      builder: (context, orientation, deviceType) {
        // MaterialApp is the wrapper of the entire app UI
        return MaterialApp(
          title: 'DTT REAL ESTATE',
          theme: ThemeData(
            fontFamily: 'Gotham SSm',
          ),
          home: HomePage(),
        );
      },
    );
  }
}

/// The home page of the app which houses the main navigation.
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// The default index for the bottom navigation bar.
  int _currentIndex = 0;
  /// The default location used before a real location is obtained.
  LatLng currentLocation = LatLng(0.0, 0.0); // Default location

  @override
  void initState() {
    super.initState();
    // Checking initial location permission status on app start.
    BlocProvider.of<LocationPermissionBloc>(context).add(CheckInitialPermissionStatus());
    // Requesting the fetching of houses data on app start.
    BlocProvider.of<HousesFetchBloc>(context).add(HousesFetchRequested());
  }


  @override
  Widget build(BuildContext context) {
    // BlocBuilder listens to HousesFetchBloc's state changes
    return BlocBuilder<LocationPermissionBloc, LocationPermissionState>(
      builder: (context, locationPermissionState) {
        return BlocBuilder<HousesFetchBloc, HousesFetchState>(
          builder: (context, housesFetchState) {
            // Determine if we should show the SplashScreen
            final showSplashScreen = housesFetchState is HousesFetchInProgress ||
                locationPermissionState is LocationPermissionLoading;

            // Determine if the houses data fetching resulted in failure
            final showLoadFailureMessage = housesFetchState is HousesFetchFailure;

            // Determine if we should show the BottomNavigationBar
            final showBottomNavigationBar = (housesFetchState is HousesFetchSuccess ||
                housesFetchState is HousesFetchFailure) &&
                  (locationPermissionState is LocationPermissionGrantedState ||
                    locationPermissionState is LocationPermissionDeniedState ||
                      locationPermissionState is LocationPermissionNoConnection);

            // Main Scaffold which provides the structure of the UI
            return Scaffold(
              // Background color of the Scaffold.
              backgroundColor: Palette.lightgray,
              body: showSplashScreen ? SplashScreen() :
              IndexedStack(
                // The index of the current page.
                index: _currentIndex,
                children: [
                  // Provides a BLoC for managing the house list.
                  BlocProvider<HouseListManageBloc>(
                    create: (context) => HouseListManageBloc(housesFetchState.houses),
                    child: HousesListPage(
                      currentLocation: locationPermissionState.location,
                      allHouses: housesFetchState.houses,
                      failureMessage: showLoadFailureMessage,
                    ),
                  ),
                  // InfoPage for additional information about DTT
                  InfoPage(),
                ],

              ),
              // Check if navigationbar should be shown
              bottomNavigationBar: showBottomNavigationBar
                  ? Container(
                decoration: BoxDecoration(
                  // Background color of the BottomNavigationBar.
                  color: Palette.white,
                  boxShadow: [
                    BoxShadow(
                      // Shadow color.
                      color: Palette.darkgray,
                      // Offset for shadow.
                      offset: Offset(0, -1.w),
                      // Spread radius of the shadow.
                      spreadRadius: 0.5.w,
                      // Blur radius of the shadow.
                      blurRadius: 1.5.w,
                    ),
                  ],
                ),
                child: CustomBottomNavigationBar(
                  // Current index for navigation.
                  currentIndex: _currentIndex,
                  // Handler for index change.
                  onIndexChanged: (index) =>
                      setState(() => _currentIndex = index),
                ),
              )
              // Return null when the bottomnavigationbar shouldn't be shown
                  : null,
            );
          },
        );
      },
    );
  }
}