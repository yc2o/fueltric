import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:fueltric/models/fuel_station.dart';
import 'package:fueltric/providers/station_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class FuelMapScreen extends StatefulWidget {
  const FuelMapScreen({super.key});

  @override
  State<FuelMapScreen> createState() => _FuelMapScreenState();
}

class _FuelMapScreenState extends State<FuelMapScreen> {
  late MapController _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<StationProvider>(context, listen: false).loadStations();
    });
  }

  Color _getDensityColor(int densityLevel) {
    switch (densityLevel) {
      case 5: return Colors.red[700]!;
      case 4: return Colors.orange[600]!;
      case 3: return Colors.yellow[600]!;
      case 2: return Colors.blue[600]!;
      case 1: return Colors.green[600]!;
      default: return Colors.grey;
    }
  }

  IconData _getStationIcon(String type) {
    switch (type.toLowerCase()) {
      case 'electric': return Icons.ev_station;
      default: return Icons.local_gas_station;
    }
  }

  Color _getBrandColor(String type) {
    switch (type.toLowerCase()) {
      case 'pertamina': return Colors.blue[800]!;
      case 'shell': return Colors.yellow[800]!;
      case 'bp': return Colors.green[800]!;
      case 'electric': return Colors.purple[800]!;
      default: return Colors.grey;
    }
  }

  void _showStationDetails(FuelStation station) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getStationIcon(station.type),
                    color: _getBrandColor(station.type),
                    size: 40,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      station.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Tipe', station.type),
              _buildDetailRow('Alamat', station.address),
              _buildDetailRow('Kecamatan', station.district),
              _buildDetailRow('Kepadatan', 'Level ${station.densityLevel}'),
              _buildDetailRow('Populasi', '${station.population} jiwa'),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.directions),
                  label: const Text('Buka di Google Maps'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final url = Uri.parse(
                      'https://www.google.com/maps/search/?api=1&query='
                      '${station.latitude},${station.longitude}',
                    );
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stations = Provider.of<StationProvider>(context).stations;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta SPBU/SPKLU'),
        actions: [
          IconButton(
            icon: const Icon(Icons.legend_toggle),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Legenda Peta'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildLegendItem('Padat (Level 5)', Colors.red[700]!),
                      _buildLegendItem('Rapat (Level 4)', Colors.orange[600]!),
                      _buildLegendItem('Sedang (Level 3)', Colors.yellow[600]!),
                      _buildLegendItem('Sepi (Level 2)', Colors.blue[600]!),
                      _buildLegendItem('Sangat Sepi (Level 1)', Colors.green[600]!),
                      const SizedBox(height: 16),
                      const Text('Warna Brand:'),
                      _buildLegendItem('Pertamina', Colors.blue[800]!),
                      _buildLegendItem('Shell', Colors.yellow[800]!),
                      _buildLegendItem('BP', Colors.green[800]!),
                      _buildLegendItem('Elektrik', Colors.purple[800]!),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: const LatLng(-7.2575, 112.7521),
          zoom: 13.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: stations.map((station) {
              return Marker(
                point: LatLng(station.latitude, station.longitude),
                width: 40,
                height: 40,
                builder: (ctx) => GestureDetector(
                  onTap: () => _showStationDetails(station),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        Icons.circle,
                        color: _getDensityColor(station.densityLevel),
                        size: 30,
                      ),
                      Icon(
                        _getStationIcon(station.type),
                        color: Colors.white,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }
}