import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'blocs/houses_fetch_bloc.dart';
import 'utils/styles.dart';
import 'views/houses_list_page.dart';
import 'views/about.dart';
import 'views/splash_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/location_permission_bloc.dart';
import 'events/houses_fetch_event.dart';
import 'events/location_permission_event.dart';
import 'states/houses_fetch_states.dart';
import 'states/location_permission_states.dart';
import 'package:latlong2/latlong.dart';
import 'widgets/custom_bottom_navigation_bar.dart';

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
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {  // simply serves as an entry point for my application, holds no mutable state so stateless
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
            final showBottomNavigationBar = housesFetchState is HousesFetchSuccess &&
                (locationPermissionState is LocationPermissionGrantedState ||
                    locationPermissionState is LocationPermissionDeniedState);

            print(showSplashScreen);
            print(locationPermissionState);
            print(housesFetchState);

            // Now return the Scaffold with the conditions above
            return Scaffold(
              backgroundColor: Palette.lightgray,
              body: showSplashScreen ? SplashScreen() :
              showLoadFailureMessage ? const Center(child: Text('Failed to load houses')) :
              IndexedStack(
                index: _currentIndex,
                children: [
                  HousesListPage(
                    currentLocation: locationPermissionState is LocationPermissionGrantedState
                        ? locationPermissionState.location
                        : currentLocation, // Use currentLocation from the state if granted
                    allHouses: housesFetchState is HousesFetchSuccess ? housesFetchState.houses : [],
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
                      color: Palette.darkgray, // Change to desired shadow color
                      offset: Offset(0, -1.w), // Using negative y-offset for top shadow
                      spreadRadius: 0.5.w,
                      blurRadius: 1.5.w,
                    ),
                  ],
                ),
                child: CustomBottomNavigationBar(
                  currentIndex: _currentIndex,
                  onIndexChanged: (index) => setState(() => _currentIndex = index),
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
