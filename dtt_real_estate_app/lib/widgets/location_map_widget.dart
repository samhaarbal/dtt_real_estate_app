import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

class LocationMapWidget extends StatelessWidget { //StatelessWidget since it does not have any internal state changes after the initial setup. Only when using MapController or other properties dynamically within this widget in the future, keeping it as a StatefulWidget would be necessary.

  final double latitude;
  final double longitude;
  final MapController mapController = MapController();

  LocationMapWidget({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    print("Building LocationMapWidget  Lat: $latitude, Long: $longitude");

    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(latitude, longitude),
            zoom: 15.0,
            interactiveFlags: InteractiveFlag.none,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: 10.w,
                  height: 10.h,
                  point: LatLng(latitude, longitude),
                  builder: (ctx) => Container(
                    child: SvgPicture.asset('Icons/ic_red_pin.svg'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
