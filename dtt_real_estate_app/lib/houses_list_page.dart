import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';
import 'styles.dart';
import 'package:intl/intl.dart';
import 'house_detail.dart';
import 'house.dart';
import 'package:latlong2/latlong.dart';
import 'distance_widget.dart';
import 'icon_text_group.dart';


class HousesListPage extends StatefulWidget {
  final List<House> allHouses; // allHouseslist set up during loading
  final LatLng currentLocation; // current location set up after granting (or not) permission.

  HousesListPage({required this.allHouses, required this.currentLocation});

  @override
  _HousesListPageState createState() => _HousesListPageState();
}

class _HousesListPageState extends State<HousesListPage> {
  TextEditingController searchController = TextEditingController();
  late List<House> filteredHouses = [];
  late FocusNode searchFocusNode;
  bool sortedByPrice = false;

  @override
  void initState() {
    super.initState(); // ensures that the initState() method of the superclass (State<T> in the case of Flutter) is also executed. For safety.
    filteredHouses = List.from(widget.allHouses);
    // Add the listener to the searchController
    searchFocusNode = FocusNode();
    searchFocusNode.addListener(() { //A listener to check if the uses makes a change in the focus to the textfield
      setState(() {});  // This will trigger a rebuild when the focus changes
    });
  }

  // Create a method to create a new list based on search bar input data
  void filterSearchResults(String text) {
    if (text.isEmpty) {
      setState(() {
        filteredHouses = List.from(widget.allHouses); // Reset to all houses when there's no search text. St
      });
      return;
    }
    List<House> tempList = [];
    widget.allHouses.forEach((house) {
      if (house.city.toLowerCase().contains(text.toLowerCase()) ||
          house.zip.toLowerCase().contains(text.toLowerCase())) {
        tempList.add(house);
      }
    });
    setState(() {
      filteredHouses = tempList; //update the state of the page, of the
    });
  }


  //Method to sort the houselist based on a click on the sorting icon.
  void sortHousesByPrice() {
    setState(() { // state needs to be updated each time the icon is clicked
      if (sortedByPrice) {
        // If the list is already sorted by price, sort it by ID
        filteredHouses.sort((a, b) => a.id.compareTo(b.id));
      } else {
        // Otherwise, sort the list by price
        filteredHouses.sort((a, b) => a.price.compareTo(b.price));
      }
      // Toggle the value of sortedByPrice for the next time the button is tapped
      sortedByPrice = !sortedByPrice;
    });
  }

  // separate widget for the searchbar to make the code more modular
  Widget SearchBar() {
    return Container(
      height: 5.h,
      child: TextField(
        style: CustomTextStyles.body,
        controller: searchController,  // Assign searchController here. Needed for clearing the field when tapping suffixicon
        focusNode: searchFocusNode, // Assign focusnode here to check if user selected searchfield or not
        onChanged: filterSearchResults, // This directly passes the current text to your filtering method
        cursorColor: Palette.medium,
        decoration: InputDecoration(
          labelText: ("Search for a home"),
          labelStyle: CustomTextStyles.hint,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          suffixIcon: FittedBox(
            fit: BoxFit.scaleDown,
            child: searchFocusNode.hasFocus
                ? InkWell(
              onTap: () {
                // Clear the text in the search bar when the close icon is tapped
                setState(() {
                  searchController.clear();
                  filterSearchResults("");  // Update the filtered list after clearing the text by passing an empty string to the function
                  FocusScope.of(context).unfocus();// Remove focus from the search bar and hide the keyboard
                });
              },
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Palette.strong,
                  BlendMode.srcIn,
                ),
                child: SvgPicture.asset('Icons/ic_close.svg', width: 2.5.w, height: 2.5.h),
              ),
            )
                : ColorFiltered(
              colorFilter: ColorFilter.mode(
                Palette.medium,
                BlendMode.srcIn,
              ),
              child: SvgPicture.asset('Icons/ic_search.svg', width: 2.5.w, height: 2.5.h),
            ),
          ),
          fillColor: Palette.darkgray,
          filled: true,
          // Remove the border
          border: InputBorder.none,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),  // Rounded corners
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(10.0),  // Rounded corners
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 2.h),
        ),
      ),
    );
  }

//Didn't create a separate custom class for this widget, because it's such an essential part of the houseslistpage and won't be used somewhere else.
  Widget buildHousesList() {  // this builds the list of houses based on the search filter results
    if (widget.allHouses.isEmpty) { //What do display if there are no houses retrieved from the API
      return Center(child: Text('No houses found.'));
    } else if (filteredHouses.isEmpty) { // What to display when the search doesn't lead to any results
      return Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('Images/search_state_empty.png', width: 60.w),
              SizedBox(height: 5.h),
              Text('No results found!', style: CustomTextStyles.search),
              Text('Perhaps try another search?', style: CustomTextStyles.search),
            ],
          ),
        ),
      );
    } else { // What to display when there are search results. The listviewbuilder builds an item for each house instance in the filtered list
      return ListView.builder(
        itemCount: filteredHouses.length,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          final house = filteredHouses[index];
          final calculatedDistance = DistanceWidget(currentLocation: widget.currentLocation, houseLatitude: house.latitude, houseLongitude: house.longitude);

          return Padding(
            padding: EdgeInsets.only(top: 2.h, left: 6.w, right: 6.w),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HouseDetailPage(house: house, calculatedDistance: calculatedDistance),
                ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    const BoxShadow(
                      color: Palette.darkgray,  // This is a light shadow color.
                      offset: Offset(0, 0),   // Position of shadow. Moves it to the bottom.
                      blurRadius: 1.0,       // Adjust to make shadow softer or harder.
                      spreadRadius: 1,     // Adjust to increase or decrease the size of the shadow.
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
                          child: Image.network('https://intern.d-tt.nl/${house.image}',
                            fit: BoxFit.cover,
                            width: 10.h,
                            height: 10.h,  // Added this line to specify the height
                          ),
                        ),
                      ),

                      SizedBox(width: 5.w), // some spacing

                      // Column for title, subtitle, empty container, and the row of icons and texts
                      Container(
                        height: 10.h,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,  // to put space between top and bottom containers
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Container for Title and Subtitle
                            Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('\$${NumberFormat("#,###").format(house.price)}', style: CustomTextStyles.title03,),
                                  Text('${house.zip} ${house.city}', style: CustomTextStyles.subtitle,),
                                ],
                              ),
                            ),

                            // Container for Row at the bottom
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Row(
                                children: [
                                  IconTextGroup( // Custom class for the icontext group to make the code a bit more modular
                                    iconPath: 'Icons/ic_bed.svg',
                                    text: '${house.bedrooms}',
                                  ),

                                  SizedBox(width: 5.w), // spacing between text and next icon

                                  IconTextGroup(
                                    iconPath: 'Icons/ic_bath.svg',
                                    text: '${house.bathrooms}',
                                  ),

                                  SizedBox(width: 5.w), // spacing between text and next icon

                                  IconTextGroup(
                                    iconPath: 'Icons/ic_layers.svg',
                                    text: '${house.size}',
                                  ),

                                  SizedBox(width: 5.w), // spacing between text and next icon

                                  // Can't call the IconTextGroup for this one, because the calculatedDistance is of type Future<string>
                                  ColorFiltered(
                                      colorFilter: ColorFilter.mode(Palette.medium, BlendMode.srcIn),
                                      child: SvgPicture.asset('Icons/ic_location.svg', width: 2.w, height: 2.h)),
                                  SizedBox(width: 2.w), // spacing between icon and text
                                  calculatedDistance
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );

        },
      );
    }
  }

// this is where we build the context with all the available widgets that we created before
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Palette.lightgray,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,  // Set cross-axis alignment to start (left)
        children: [
          SizedBox(height: 6.h),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
            child: Text(
                "DTT REAL ESTATE",
                style: CustomTextStyles.title03
            ),
          ),
          Padding( // Using the SearchBar widget here
            padding: EdgeInsets.symmetric(vertical: 1.h, horizontal: 6.w),
            child: SearchBar(),
          ),
          Padding( // Insert the sorting button here
            padding: EdgeInsets.symmetric(horizontal: 6.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,  // This will push all elements to the edges of the row
              children: [  // Start of children list
                GestureDetector(
                  onTap: () {
                    sortHousesByPrice();
                  },
                  child: Container(
                    child: Icon(
                      Icons.sort,
                      size: 5.w,  // Adjust size as needed
                    ),
                  ),
                )
              ],  // End of children list
            ),
          ),

          Expanded( //to ensure that the list view with the houses takes up all available space in its parent widget, while still respecting the constraints of the other widgets in the same parent
              child: buildHousesList())

        ],
      ),
    );
  }


  // Make sure that the data stored in memory for the search for houses (the listener, focusnode, and the controller) are disposed when the state is disposed of.
  //
  @override
  void dispose() {
    searchController.dispose();
    searchFocusNode.dispose();
    super.dispose();
  }

}