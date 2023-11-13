import 'package:latlong2/latlong.dart';

/// Defines a default location with latitude and longitude set to zero.
/// This is used to signify an unknown or invalid location.
const LatLng defaultLocation = LatLng(0.0, 0.0);

/// A utility class for calculating the distance between two geographical points.
class CustomDistanceCalculator {
  /// The current location of the user.
  final LatLng currentLocation;

  /// The latitude coordinate of the house.
  final double houseLatitude;

  /// The longitude coordinate of the house.
  final double houseLongitude;

  /// Constructs a [CustomDistanceCalculator] with the user's current location and the house's coordinates.
  CustomDistanceCalculator({
    required this.currentLocation,
    required this.houseLatitude,
    required this.houseLongitude,
  });

  /// Calculates the distance from the current location to the house's location.
  ///
  /// Returns a string representation of the distance in kilometers, formatted to one decimal place.
  /// If the current location is invalid (0.0, 0.0), a dash is returned to indicate the distance is unknown.
  String calculateDistance() {
    // Check for the default or invalid location.
    if (currentLocation == defaultLocation) {
      return '-';
    }

    // Calculate the distance using the LatLng points.
    final point1 = LatLng(currentLocation.latitude, currentLocation.longitude);
    final point2 = LatLng(houseLatitude, houseLongitude);
    final distance = Distance().distance(point1, point2);

    // Convert meters to kilometers, format to one decimal place, and return.
    return '${(distance / 1000).toStringAsFixed(1)} km';
  }
}
