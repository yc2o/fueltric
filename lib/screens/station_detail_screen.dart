import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map/plugin_api.dart';
import 'package:fueltric/models/fuel_station.dart'; // PERBAIKAN IMPORT
import 'package:latlong2/latlong.dart' as latlong;
import 'package:url_launcher/url_launcher.dart';

class StationDetailScreen extends StatelessWidget {
  final FuelStation station; // Gunakan FuelStation bukan StationModel

  const StationDetailScreen({
    super.key,
    required this.station,
  });

void _openInGoogleMaps(BuildContext context) async {  // Tambahkan parameter context
  final lat = station.latitude;
  final lng = station.longitude;
  
  final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

  try {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      final webUri = Uri.parse('https://maps.google.com/?q=$lat,$lng');
      if (await canLaunchUrl(webUri)) {
        await launchUrl(webUri);
      } else {
        throw 'Tidak dapat membuka Google Maps';
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(  // Sekarang context tersedia
      SnackBar(content: Text('Error: ${e.toString()}'))
    );
  }
}

  Color _getBrandColor(String type) {
    switch (type.toLowerCase()) {
      case 'pertamina': return Colors.blue[800]!;
      case 'shell': return Colors.yellow[800]!;
      case 'bp': return Colors.green[800]!;
      case 'electric': return Colors.purple[800]!;
      default: return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(station.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan Icon
            Row(
              children: [
                Icon(
                  station.type.toLowerCase() == 'electric' 
                      ? Icons.ev_station 
                      : Icons.local_gas_station,
                  color: _getBrandColor(station.type),
                  size: 40,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    station.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Informasi Detail
            _buildDetailRow('Tipe', station.type),
            _buildDetailRow('Alamat', station.address),
            _buildDetailRow('Kota', station.city),
            _buildDetailRow('Kecamatan', station.district),
            _buildDetailRow('Populasi', '${station.population} jiwa'),
            _buildDetailRow('Tingkat Kepadatan', 'Level ${station.densityLevel}'),
            
            // Peta
            const SizedBox(height: 24),
            SizedBox(
              height: 300,
              child: FlutterMap(
                options: MapOptions(
                  center: latlong.LatLng(station.latitude, station.longitude),
                  zoom: 15.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.fueltric',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: latlong.LatLng(station.latitude, station.longitude),
                        width: 40,
                        height: 40,
                        builder: (ctx) => Icon(
                          station.type.toLowerCase() == 'electric'
                              ? Icons.ev_station
                              : Icons.local_gas_station,
                          color: _getBrandColor(station.type),
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Tombol
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.directions),
                label: const Text('Buka di Google Maps'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                onPressed: () => _openInGoogleMaps(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
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
}