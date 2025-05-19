import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlong2;

class MapService {
  static final MapController mapController = MapController();

  static void moveToLocation(latlong2.LatLng point) {
    mapController.move(point, 15);
  }

  static String getTileLayerUrl() {
    return 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  }

  static List<Marker> generateMarkers(List<dynamic> stations, Function onTap) {
    return stations.map((station) {
      return Marker(
        point: latlong2.LatLng(station.latitude, station.longitude),
        width: 40,
        height: 40,
        builder: (ctx) => GestureDetector(
          onTap: () => onTap(station),
          child: Icon(
            station.type == 'SPBU' ? Icons.local_gas_station : Icons.ev_station,
            color: station.type == 'SPBU' ? Colors.orange : Colors.green,
            size: 30,
          ),
        ),
      );
    }).toList();
  }
}