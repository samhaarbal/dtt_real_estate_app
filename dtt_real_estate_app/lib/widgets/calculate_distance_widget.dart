import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import '../utils/styles.dart';

class DistanceWidget extends StatelessWidget {
  final LatLng currentLocation;
  final double houseLatitude;
  final double houseLongitude;

  // Create a key so that the program knows which distance widget is which when the list gets jumbled, for example due to searching
  const DistanceWidget({
    required this.currentLocation,
    required this.houseLatitude,
    required this.houseLongitude,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (currentLocation == LatLng(0.0, 0.0)) {
      return Text('-', style: CustomTextStyles.detail);
    }

    final point1 = LatLng(currentLocation.latitude, currentLocation.longitude);
    final point2 = LatLng(houseLatitude, houseLongitude);
    final distance = Distance().distance(point1, point2);
    final distanceString = (distance / 1000).toStringAsFixed(1) + ' km';

    print(point1);
    print(point2);
    print(distance);
    print(distanceString);
    return Text(distanceString, style: CustomTextStyles.detail);

  }
}

