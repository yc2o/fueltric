import 'package:flutter/material.dart';

class DistrictDensityLegend extends StatelessWidget {
  const DistrictDensityLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Legenda Kepadatan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildLegendItem('Sangat Rendah', Colors.green[100]!),
            _buildLegendItem('Rendah', Colors.green[300]!),
            _buildLegendItem('Sedang', Colors.orange[300]!),
            _buildLegendItem('Tinggi', Colors.orange[600]!),
            _buildLegendItem('Sangat Tinggi', Colors.red[600]!),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 20,
            height: 20,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}