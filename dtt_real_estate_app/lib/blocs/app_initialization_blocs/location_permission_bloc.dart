import 'package:bloc/bloc.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:dtt_real_estate_app/events/app_initialization_events/location_permission_event.dart';
import 'package:dtt_real_estate_app/states/app_initialization_states/location_permission_states.dart';
import 'package:permission_handler/permission_handler.dart' as hand;

class LocationPermissionBloc extends Bloc<LocationPermissionEvent, LocationPermissionState> {
  LocationPermissionBloc() : super(LocationPermissionLoading()) {
    on<LocationPermissionRequested>(_onLocationPermissionRequested);
    on<CheckInitialPermissionStatus>(_onCheckInitialPermissionStatus);
  }

  // This method checks the permission status and emits the appropriate state.
  Future<void> _onCheckInitialPermissionStatus(
      CheckInitialPermissionStatus event,
      Emitter<LocationPermissionState> emit,
      ) async {
    final hand.PermissionStatus permission = await hand.Permission.location.status;
    if (permission.isGranted) {
      // If already granted, get the location and emit granted state.
      print('permission granted');
      final Location location = Location();
      final LocationData locationData = await location.getLocation();
      emit(LocationPermissionGrantedState(
        LatLng(locationData.latitude!, locationData.longitude!),
      ));
      print('Location permission status after request: $permission');
    } else {
      emit(LocationPermissionLoading());  // Emits loading state, which then triggers a permission request
      add(LocationPermissionRequested());
      print('Need to check permission again');
    }
  }

  Future<void> _onLocationPermissionRequested(
      LocationPermissionRequested event,
      Emitter<LocationPermissionState> emit,
      ) async {
    final hand.PermissionStatus permission = await hand.Permission.location.request();
    final Location location = Location();
    print('Location permission status after request: $permission');

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
