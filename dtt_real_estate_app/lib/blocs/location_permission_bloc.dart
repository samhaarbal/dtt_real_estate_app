import 'package:bloc/bloc.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:dtt_real_estate_app/events/location_permission_event.dart';
import 'package:dtt_real_estate_app/states/location_permission_states.dart';
import 'package:permission_handler/permission_handler.dart' as hand;

class LocationPermissionBloc extends Bloc<LocationPermissionEvent, LocationPermissionState> {
  LocationPermissionBloc() : super(LocationPermissionDeniedState()) {
    on<LocationPermissionRequested>(_onLocationPermissionRequested);
  }

  Future<void> _onLocationPermissionRequested(
      LocationPermissionRequested event,
      Emitter<LocationPermissionState> emit,
      ) async {
    final hand.PermissionStatus permission = await hand.Permission.location.request();
    final Location location = Location();

    if (permission.isGranted) {
      final LocationData locationData = await location.getLocation();
      emit(LocationPermissionGrantedState(
        LatLng(locationData.latitude!, locationData.longitude!),
      ));
    } else {
      emit(LocationPermissionDeniedState());
    }
  }
}
