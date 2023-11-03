import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'styles.dart';


class DistanceWidget extends StatefulWidget { //designed as a StatefulWidget since it involves a Future that computes the distance asynchronously, and the state of the widget changes based on the result of this Future.
  final LatLng currentLocation;
  final double houseLatitude;
  final double houseLongitude;

  // Import necessary parameters
  const DistanceWidget({
    required this.currentLocation,
    required this.houseLatitude,
    required this.houseLongitude,
  });

  @override
  _DistanceWidgetState createState() => _DistanceWidgetState();
}

//set parameters for the state of the distance widget
class _DistanceWidgetState extends State<DistanceWidget> {
  Future<String>? _distanceFuture;

  Future<String> calculateDistance(LatLng currentLocation, double targetLatitude, double targetLongitude) async {
    final point1 = LatLng(currentLocation.latitude, currentLocation.longitude);
    final point2 = LatLng(targetLatitude, targetLongitude);

    //Use distance method to calculate final distance
    final distance = Distance().distance(point1, point2);

    // Convert to kilometers and format it as a string with desired decimal places
    return (distance / 1000).toStringAsFixed(1); // Converts the distance to a string with 1 decimal place
  }

  //Init a state for the distancefuture only if the user has granted location permission. Otherwise the contextbuilder should output a simple text
  @override
  void initState() {
    super.initState();
    if (widget.currentLocation != LatLng(0.0, 0.0)) {
      _distanceFuture = calculateDistance(
        widget.currentLocation,
        widget.houseLatitude,
        widget.houseLongitude,
      );
    }
  }

  //If the _distancefuture variable state is intitialized, it should be outputted based on the snapshot. Otherwise, a simple string should be outputted.
  @override
  Widget build(BuildContext context) {
    if (_distanceFuture == null) {
      return Text('-', style: CustomTextStyles.detail);
    }

    return FutureBuilder<String>(
      future: _distanceFuture!,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          return Text(
            snapshot.data! + ' km',
            style: CustomTextStyles.detail,
          );
        } else {
          return CircularProgressIndicator();  // Show a loading indicator while waiting for the future to complete
        }
      },
    );
  }
}



