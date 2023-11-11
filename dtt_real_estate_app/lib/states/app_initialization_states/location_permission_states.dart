import 'package:latlong2/latlong.dart';

abstract class LocationPermissionState {
  final LatLng location;

  LocationPermissionState({LatLng? location})
      : this.location = location ?? LatLng(0.0, 0.0);
}

class LocationPermissionLoading extends LocationPermissionState {
  LocationPermissionLoading() : super();
}

class LocationPermissionGrantedState extends LocationPermissionState {
  final LatLng location;

  LocationPermissionGrantedState(this.location) : super(location: location);
}

class LocationPermissionDeniedState extends LocationPermissionState {
  LocationPermissionDeniedState() : super();
}

class LocationPermissionNoConnection extends LocationPermissionState {
  LocationPermissionNoConnection() : super();
}
