import 'package:bloc/bloc.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:dtt_real_estate_app/events/app_initialization_events/location_permission_event.dart';
import 'package:dtt_real_estate_app/states/app_initialization_states/location_permission_states.dart';
import 'package:permission_handler/permission_handler.dart' as hand;
import 'package:connectivity_plus/connectivity_plus.dart';

/// Bloc to handle the location permission and connectivity state of the app.
class LocationPermissionBloc extends Bloc<LocationPermissionEvent, LocationPermissionState> {
  /// Initializes the Bloc with an initial loading state.
  LocationPermissionBloc() : super(LocationPermissionLoading()) {
    on<LocationPermissionRequested>(_onLocationPermissionRequested);
    on<CheckInitialPermissionStatus>(_onCheckInitialPermissionStatus);
  }

  /// Handles the event to check initial location permission status.
  Future<void> _onCheckInitialPermissionStatus(
      CheckInitialPermissionStatus event,
      Emitter<LocationPermissionState> emit,
      ) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      emit(LocationPermissionNoConnection());
      return;
    }

    final permission = await hand.Permission.location.status;
    if (permission.isGranted) {
      await _emitLocationGranted(emit);
    } else {
      emit(LocationPermissionLoading());
      add(LocationPermissionRequested());
    }
  }

  /// Handles the event to request location permission from the user.
  Future<void> _onLocationPermissionRequested(
      LocationPermissionRequested event,
      Emitter<LocationPermissionState> emit,
      ) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      emit(LocationPermissionNoConnection());
      return;
    }

    final permission = await hand.Permission.location.request();
    if (permission.isGranted) {
      await _emitLocationGranted(emit);
    } else {
      emit(LocationPermissionDeniedState());
    }
  }

  /// Emits a state when location permission is granted, including the current location.
  Future<void> _emitLocationGranted(Emitter<LocationPermissionState> emit) async {
    final Location location = Location();
    final LocationData locationData = await location.getLocation();
    emit(LocationPermissionGrantedState(
      LatLng(locationData.latitude!, locationData.longitude!),
    ));
  }
}
