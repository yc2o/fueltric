import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fueltric/models/district_model.dart';
import 'package:fueltric/models/station_model.dart';
import 'package:fueltric/services/map_service.dart';
import 'package:fueltric/widgets/district_density_legend.dart';
import 'package:latlong2/latlong.dart';

class DistrictMapScreen extends StatefulWidget {
  const DistrictMapScreen({super.key});

  @override
  State<DistrictMapScreen> createState() => _DistrictMapScreenState();
}

class _DistrictMapScreenState extends State<DistrictMapScreen> {
  final List<District> districts = [
    District(name: 'Wonokromo', stationCount: 8, densityLevel: 3),
    District(name: 'Genteng', stationCount: 12, densityLevel: 5),
    District(name: 'Sukolilo', stationCount: 5, densityLevel: 2),
  ];

  final List<FuelStation> stations = [
    FuelStation(
      id: '1',
      name: 'SPBU Pertamina 54.641.01',
      type: 'SPBU',
      address: 'Jl. Raya Darmo, Surabaya',
      city: 'Surabaya',
      latitude: -7.2575,
      longitude: 112.7521,
      district: 'Wonokromo',
      population: 50000,
    ),
    FuelStation(
      id: '2',
      name: 'SPKLU PLN Sudirman',
      type: 'SPKLU',
      address: 'Jl. Sudirman, Surabaya',
      city: 'Surabaya',
      latitude: -7.2658,
      longitude: 112.7479,
      district: 'Genteng',
      population: 45000,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Kecamatan'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: MapService.mapController,
            options: MapOptions(
              center: const LatLng(-7.2575, 112.7521),
              zoom: 12.0,
            ),
            children: [
              TileLayer(
                urlTemplate: MapService.getTileLayerUrl(),
                userAgentPackageName: 'com.example.fueltric',
              ),
              PolygonLayer(
                polygons: _generateDistrictPolygons(),
              ),
              MarkerLayer(
                markers: MapService.generateMarkers(
                  stations,
                  (station) => _showStationPopup(context, station),
                ),
              ),
            ],
          ),
          const Positioned(
            bottom: 16,
            right: 16,
            child: DistrictDensityLegend(),
          ),
        ],
      ),
    );
  }

  List<Polygon> _generateDistrictPolygons() {
    return districts.map((district) {
      final color = _getDistrictColor(district.densityLevel);
      return Polygon(
        points: _getDistrictCoordinates(district.name),
        color: color.withOpacity(0.5),
        borderColor: color,
        borderStrokeWidth: 2,
        isFilled: true,
      );
    }).toList();
  }

  Color _getDistrictColor(int densityLevel) {
    switch (densityLevel) {
      case 1: return Colors.green[100]!;
      case 2: return Colors.green[300]!;
      case 3: return Colors.orange[300]!;
      case 4: return Colors.orange[600]!;
      case 5: return Colors.red[600]!;
      default: return Colors.grey;
    }
  }

  List<LatLng> _getDistrictCoordinates(String districtName) {
    switch (districtName) {
      case 'Wonokromo':
        return [
          const LatLng(-7.25, 112.74),
          const LatLng(-7.25, 112.76),
          const LatLng(-7.27, 112.76),
          const LatLng(-7.27, 112.74),
        ];
      case 'Genteng':
        return [
          const LatLng(-7.26, 112.74),
          const LatLng(-7.26, 112.75),
          const LatLng(-7.27, 112.75),
          const LatLng(-7.27, 112.74),
        ];
      default:
        return [
          const LatLng(-7.25, 112.74),
          const LatLng(-7.25, 112.75),
          const LatLng(-7.26, 112.75),
          const LatLng(-7.26, 112.74),
        ];
    }
  }

  void _showStationPopup(BuildContext context, FuelStation station) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(station.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tipe: ${station.type}'),
            Text('Alamat: ${station.address}'),
            Text('Kecamatan: ${station.district}'),
            Text('Kota: ${station.city}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              MapService.moveToLocation(
                LatLng(station.latitude, station.longitude),
              );
            },
            child: const Text('Lihat di Peta'),
          ),
        ],
      ),
    );
  }
}