import 'package:flutter/material.dart';
import 'package:fueltric/models/fuel_station.dart'; // Pastikan import model yang benar

class StationCard extends StatelessWidget {
  final FuelStation station;
  final VoidCallback onTap;

  const StationCard({
    super.key,
    required this.station,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    station.type.toLowerCase() == 'electric'
                        ? Icons.ev_station
                        : Icons.local_gas_station,
                    color: station.type.toLowerCase() == 'pertamina'
                        ? Colors.blue
                        : station.type.toLowerCase() == 'shell'
                            ? Colors.yellow
                            : station.type.toLowerCase() == 'bp'
                                ? Colors.green
                                : Colors.orange,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      station.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(station.address),
              const SizedBox(height: 8),
              Row(
                children: [
                  Chip(
                    label: Text(station.district),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text('Level ${station.densityLevel}'),
                    backgroundColor: _getDensityColor(station.densityLevel).withOpacity(0.2),
                    labelStyle: TextStyle(
                      color: _getDensityColor(station.densityLevel),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getDensityColor(int densityLevel) {
    switch (densityLevel) {
      case 5: return Colors.red;
      case 4: return Colors.orange;
      case 3: return Colors.yellow;
      case 2: return Colors.blue;
      case 1: return Colors.green;
      default: return Colors.grey;
    }
  }
}