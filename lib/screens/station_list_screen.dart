import 'package:flutter/material.dart';
import 'package:fueltric/models/fuel_station.dart';
import 'package:fueltric/screens/station_detail_screen.dart';
import 'package:fueltric/services/csv_service.dart';
import 'package:fueltric/widgets/station_card.dart';

class StationListScreen extends StatefulWidget {
  const StationListScreen({super.key});

  @override
  State<StationListScreen> createState() => _StationListScreenState();
}

class _StationListScreenState extends State<StationListScreen> {
  late Future<List<FuelStation>> _stationsFuture;
  String _searchQuery = '';
  String _selectedDistrict = 'Semua';
  String _selectedType = 'Semua';

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  void _loadStations() {
    setState(() {
      _stationsFuture = CsvService.loadStationsFromCsv()
          .catchError((error) {
        print('Error loading stations: $error');
        throw error; // Tetap lempar error untuk ditangani oleh FutureBuilder
      });
    });
  }

List<FuelStation> _filterStations(List<FuelStation> stations) {
    return stations.where((station) {
      final matchesSearch = _searchQuery.isEmpty ||
          station.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          station.address.toLowerCase().contains(_searchQuery.toLowerCase());
      
      final matchesDistrict = _selectedDistrict == 'Semua' || 
          station.district == _selectedDistrict;
      
      final matchesType = _selectedType == 'Semua' || 
          (_selectedType == 'SPBU' 
              ? (station.type != 'Electric')
              : (station.type == 'Electric'));
      
      return matchesSearch && matchesDistrict && matchesType;
    }).toList();
  }


  List<String> _getUniqueDistricts(List<FuelStation> stations) {
    final districts = stations.map((s) => s.district).toSet().toList();
    districts.sort();
    return ['Semua', ...districts];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar SPBU & SPKLU Surabaya'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadStations,
          ),
        ],
      ),
      body: FutureBuilder<List<FuelStation>>(
        future: _stationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Gagal memuat data stasiun'),
                  Text(
                    snapshot.error.toString(),
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  ElevatedButton(
                    onPressed: _loadStations,
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data stasiun'));
          }

          final allStations = snapshot.data!;
          final districts = _getUniqueDistricts(allStations);
          final types = ['Semua', 'SPBU', 'SPKLU'];
          final filteredStations = _filterStations(allStations);

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  decoration: InputDecoration(
                    labelText: 'Cari SPBU/SPKLU...',
                    prefixIcon: const Icon(Icons.search),
                    border: const OutlineInputBorder(),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedDistrict,
                        items: districts.map((district) {
                          return DropdownMenuItem(
                            value: district,
                            child: Text(
                              district.length > 15 
                                  ? '${district.substring(0, 15)}...' 
                                  : district,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedDistrict = value;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Kecamatan',
                          border: OutlineInputBorder(),
                        ),
                        isExpanded: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedType,
                        items: types.map((type) {
                          return DropdownMenuItem(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              _selectedType = value;
                            });
                          }
                        },
                        decoration: const InputDecoration(
                          labelText: 'Jenis',
                          border: OutlineInputBorder(),
                        ),
                        isExpanded: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: filteredStations.isEmpty
                    ? const Center(
                        child: Text('Tidak ada stasiun yang sesuai dengan filter'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 16),
                        itemCount: filteredStations.length,
                        itemBuilder: (context, index) {
                          final station = filteredStations[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                              vertical: 6.0,
                            ),
                            child: StationCard(
                              station: station,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => 
                                        StationDetailScreen(station: station),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}