import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fueltric/services/map_service.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final LatLng center;
  final double zoom;
  final List<Marker> markers;

  const MapWidget({
    super.key,
    required this.center,
    this.zoom = 13.0,
    required this.markers,
  });

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      mapController: MapService.mapController,
      options: MapOptions(
        center: center,
        zoom: zoom,
      ),
      children: [
        TileLayer(
          urlTemplate: MapService.getTileLayerUrl(),
          userAgentPackageName: 'com.example.fueltric',
        ),
        MarkerLayer(markers: markers),
      ],
    );
  }
}