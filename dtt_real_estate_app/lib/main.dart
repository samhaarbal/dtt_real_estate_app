import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'styles.dart';
import 'houses_list_page.dart';
import 'house.dart';
import 'about.dart';
import 'splash_screen.dart';
import 'package:permission_handler/permission_handler.dart' as hand;
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;



void main() {
  runApp( MyApp());
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
  late List<House> allHouses; // Define allHouses list here.
  var currentLocation = LatLng(0.0, 0.0); // This is the default value of the current location. If permission is granted, it is updated.

  Future<void>? initFuture;

  @override
  void initState() {
    super.initState();
    initFuture = _initialize();
  }

  //Create one future for both the fetching of the housedata and the locationpermission
  Future<void> _initialize() async {
    // Fetch the house data
    allHouses = await fetchHouses(); // This is used to store the fetched data. When the user makes a search, this data is filtered. It doesn't have to be fetched again from the server.
    // Request location permission
    await _requestLocationPermission();
  }

// location permission method. Layout is based mainly on the phone's own settings.
  Future<void> _requestLocationPermission() async {
    hand.PermissionStatus permission = await hand.Permission.location.request(); // hand is the permission handler package
    Location location = Location(); // Initialize the location object. This line is creating an instance of the Location class. This instance provides methods to interact with device location services.

    if (permission.isGranted) {
      LocationData locationData = await location.getLocation(); //This line is using the getLocation() method of the location instance to fetch the current location of the device. The result is stored in the locationData variable.
      setState(() {
        currentLocation = LatLng(locationData.latitude!, locationData.longitude!); // Store the LatLng if permission is granted
      });
    } else {
      setState(() {
        currentLocation = LatLng(0.0, 0.0); // Set to LatLng(0.0, 0.0) if permission is denied
      });
    }
  }

  // Fetch house data method. App should do this while the loading screen is showing
  Future<List<House>> fetchHouses() async {
    final response = await http.get(
      Uri.parse('https://intern.d-tt.nl/api/house'), //Converts the given URL string to a Uri object which is required by the http.get function.
      headers: {
        'Access-Key': '98bww4ezuzfePCYFxJEWyszbUXc7dxRx',
      },
    );

    if (response.statusCode == 200) { // check if the API is responsive to the call
      List jsonResponse = json.decode(response.body); //create a Dart object with the root structure of the JSON from the link (array)
      List<House> houses = jsonResponse.map((house) => House.fromJson(house)).toList(); // house is a temporary variable that represents each map (each house data, from which an instance is created)
      return houses;

    } else {
      throw Exception('Failed to load houses from API');
    }
  }


// Build scaffold with homepage based on the selected index of the bottomnavigationbar, and the two pages (houselist and detail) that I've created.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: initFuture, // Point to the future we want to resolve
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          final List<Widget> _pages = [ // set up pages linked to index number of the _pages list
            HousesListPage(currentLocation: currentLocation, allHouses: allHouses),
            InfoPage(),
          ];

          return Scaffold(
            backgroundColor: Palette.lightgray,
            body: _pages[_currentIndex],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Palette.white,
                boxShadow: [
                  BoxShadow(
                    color: Palette.darkgray,  // Change to desired shadow color
                    offset: Offset(0, -1.w),  // Using negative y-offset for top shadow
                    spreadRadius: 0.5.w,
                    blurRadius: 1.5.w,
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: _currentIndex,
                showSelectedLabels: false,  // Do not show label when the item is selected
                showUnselectedLabels: false,  // Do not show label when the item is unselected
                selectedItemColor: Palette.strong,
                unselectedItemColor: Palette.light,
                onTap: (int index) {
                  setState(() {
                    _currentIndex = index; //update state based on selected index by user
                  });
                },
                items: [
                  BottomNavigationBarItem(
                    icon: ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          _currentIndex == 0 ? Palette.strong : Palette.light,
                          BlendMode.srcIn,
                        ),
                        child: SvgPicture.asset('Icons/ic_home.svg', width: 4.w, height: 4.h)),
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
            ),
          );
        } else {
          // While we wait for the location future to complete, display the splash screen
          return SplashScreen();
        }
      },
    );
  }
}

