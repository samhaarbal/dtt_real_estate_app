import 'package:bloc/bloc.dart';
import 'package:location/location.dart';
import 'package:latlong2/latlong.dart';
import 'package:dtt_real_estate_app/events/location_event.dart';
import 'package:dtt_real_estate_app/states/location_state.dart';
import 'package:permission_handler/permission_handler.dart' as hand;



class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationPermissionDeniedState());

  @override
  Stream<LocationState> mapEventToState(LocationEvent event) async* {
    if (event is RequestLocationPermissionEvent) {
      final hand.PermissionStatus permission = await hand.Permission.location.request();
      final Location location = Location();

      if (permission.isGranted) {
        final LocationData locationData = await location.getLocation();
        yield LocationPermissionGrantedState(
          LatLng(locationData.latitude!, locationData.longitude!),
        );
      } else {
        yield LocationPermissionDeniedState();
      }
    }
  }
}
