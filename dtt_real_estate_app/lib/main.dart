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


void main() {
  runApp(
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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
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


class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0; //set current index of _pages list so that the app knows which page to display first
  LatLng currentLocation = LatLng(0.0, 0.0); // Default location

  @override
  void initState() {
    super.initState();
    // Add the event to check initial permission status 
    BlocProvider.of<LocationPermissionBloc>(context).add(CheckInitialPermissionStatus());
    // Trigger the events to start the housesfetch BLoC process
    BlocProvider.of<HousesFetchBloc>(context).add(HousesFetchRequested());
  }


  @override
  Widget build(BuildContext context) {
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
                    locationPermissionState is LocationPermissionDeniedState);



            // Now return the Scaffold with the conditions above
            print(showBottomNavigationBar);
            print(showLoadFailureMessage);
            print(showSplashScreen);
            return Scaffold(
              backgroundColor: Palette.lightgray,
              body: showSplashScreen ? SplashScreen() :
              IndexedStack(
                index: _currentIndex,
                children: [
                  BlocProvider<HouseListManageBloc>(
                    create: (context) => HouseListManageBloc(housesFetchState.houses),
                    child: HousesListPage(
                      currentLocation: locationPermissionState.location,
                      allHouses: housesFetchState.houses,
                      failureMessage: showLoadFailureMessage,
                    ),
                  ),
                  InfoPage(),
                ],

              ),
              bottomNavigationBar: showBottomNavigationBar
                  ? Container(
                decoration: BoxDecoration(
                  color: Palette.white,
                  boxShadow: [
                    BoxShadow(
                      color: Palette.darkgray,
                      // Change to desired shadow color
                      offset: Offset(0, -1.w),
                      // Using negative y-offset for top shadow
                      spreadRadius: 0.5.w,
                      blurRadius: 1.5.w,
                    ),
                  ],
                ),
                child: CustomBottomNavigationBar(
                  currentIndex: _currentIndex,
                  onIndexChanged: (index) =>
                      setState(() => _currentIndex = index),
                ),
              )
                  : null, // Return null to not show the BottomNavigationBar
            );
          },
        );
      },
    );
  }
}