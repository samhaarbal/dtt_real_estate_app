import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sizer/sizer.dart';

/// The URL template for the tile layer that uses OpenStreetMap's tiles.
const String _tileUrlTemplate = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
/// The subdomains for the OpenStreetMap tile server.
const List<String> _tileSubdomains = ['a', 'b', 'c'];
/// The zoom level to use when displaying the map.
const double _mapZoomLevel = 15.0;
/// Width and height for the marker representing the location on the map.
const double _markerSize = 10.0;
/// The asset path for the location pin icon.
const String _locationPinAsset = 'Icons/ic_red_pin.svg';


/// A widget that displays a map centered on the given latitude and longitude.
class LocationMapWidget extends StatelessWidget {
  /// The latitude to center the map on.
  final double latitude;

  /// The longitude to center the map on.
  final double longitude;

  /// Controller for the map.
  final MapController mapController = MapController();

  /// Constructs a `LocationMapWidget` that shows a map centered on the specified coordinates.
  LocationMapWidget({required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          mapController: mapController,
          options: MapOptions(
            center: LatLng(latitude, longitude),
            zoom: _mapZoomLevel,
            interactiveFlags: InteractiveFlag.none,
          ),
          children: [
            TileLayer(
              urlTemplate: _tileUrlTemplate,
              subdomains: _tileSubdomains,
            ),
            MarkerLayer(
              markers: [
                Marker(
                  width: _markerSize.w,
                  height: _markerSize.h,
                  point: LatLng(latitude, longitude),
                  builder: (ctx) => Container(
                    child: SvgPicture.asset(_locationPinAsset),
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
