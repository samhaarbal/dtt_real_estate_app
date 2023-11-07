import 'package:latlong2/latlong.dart';

abstract class LocationPermissionState {}

class LocationPermissionLoading extends LocationPermissionState {}

class LocationPermissionGrantedState extends LocationPermissionState {
  final LatLng location;

  LocationPermissionGrantedState(this.location);
}

class LocationPermissionDeniedState extends LocationPermissionState {
  final LatLng location;

  LocationPermissionDeniedState() : location = LatLng(0.0, 0.0);
}