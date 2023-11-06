import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  bool isDataFetchedAndPermissionResolved() {
    final housesState = BlocProvider.of<HousesFetchBloc>(context).state;
    final locationState = BlocProvider.of<LocationPermissionBloc>(context).state;
    return (housesState is HousesLoadSuccess || housesState is HousesLoadFailure) &&
        (locationState is LocationPermissionGrantedState || locationState is LocationPermissionDeniedState);
  }

  @override
  void initState() {
    super.initState();
    // Trigger the events to start the BLoC processes
    BlocProvider.of<HousesFetchBloc>(context).add(HousesFetchRequested());
    BlocProvider.of<LocationPermissionBloc>(context)
        .add(LocationPermissionRequested());
  }

  @override
  Widget build(BuildContext context) {
    // Fetch the current states
    final housesState = BlocProvider.of<HousesFetchBloc>(context).state;
    final locationState = BlocProvider.of<LocationPermissionBloc>(context).state;

    // Determine if we should show the SplashScreen
    final showSplashScreen = housesState is HousesLoadInProgress ||
        locationState is LocationPermissionInitial ||
        locationState is LocationPermissionLoading;

    // Determine if the houses data fetching resulted in failure
    final showLoadFailureMessage = housesState is HousesLoadFailure;

    // Determine if we should show the BottomNavigationBar
    final showBottomNavigationBar = housesState is HousesLoadSuccess &&
        (locationState is LocationPermissionGrantedState ||
            locationState is LocationPermissionDeniedState);

    return Scaffold(
      backgroundColor: Palette.lightgray,
      body: showSplashScreen ? SplashScreen() :
      showLoadFailureMessage ? const Center(child: Text('Failed to load houses')) :
      IndexedStack(
        index: _currentIndex,
        children: [
          HousesListPage(
            currentLocation: currentLocation,
            allHouses: housesState is HousesLoadSuccess ? housesState.houses : [],
          ),
          InfoPage(),
        ],
      ),
      bottomNavigationBar: isDataFetchedAndPermissionResolved()
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
          child: BottomNavigationBar(
            currentIndex: _currentIndex,
            showSelectedLabels: false, // Do not show label when the item is selected
            showUnselectedLabels: false, // Do not show label when the item is unselected
            selectedItemColor: Palette.strong,
            unselectedItemColor: Palette.light,
            onTap: (int index) {
              setState(() {
                _currentIndex = index; // Update state based on selected index by user
              });
            },
            items: [
              BottomNavigationBarItem(
                icon: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    _currentIndex == 0 ? Palette.strong : Palette.light,
                    BlendMode.srcIn,
                  ),
                  child: SvgPicture.asset('Icons/ic_home.svg', width: 4.w, height: 4.h),
                ),
                label: 'Houses',
              ),
              BottomNavigationBarItem(
                icon: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    _currentIndex == 1 ? Palette.strong : Palette.light,
                    BlendMode.srcIn,
                  ),
                  child: SvgPicture.asset('Icons/ic_info.svg', width: 4.w, height: 4.h),
                ),
                label: 'Info',
              ),
            ],
          ),
        )
      : null, // Return null to not show the BottomNavigationBar
    );
  }
}
