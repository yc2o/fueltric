class FuelStation {
  final String id;
  final String name;
  final String type;
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final String district;
  final int population;
  final int densityLevel;

  FuelStation({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.district,
    required this.population,
    required this.densityLevel,
  });

  factory FuelStation.fromCsv(List<dynamic> row) {
    final name = row[1].toString();
    final type = name.contains('SPKLU') 
        ? 'Electric' 
        : name.contains('Pertamina') 
            ? 'Pertamina'
            : name.contains('Shell')
                ? 'Shell'
                : name.contains('BP')
                    ? 'BP'
                    : 'Other';

    final population = int.tryParse(row[7].toString()) ?? 0;
    final densityLevel = _calculateDensityLevel(population);

    return FuelStation(
      id: row[0].toString(),
      name: name,
      type: type,
      address: row[2].toString(),
      city: row[3].toString(),
      latitude: double.parse(row[4].toString()),
      longitude: double.parse(row[5].toString()),
      district: row[6].toString(),
      population: population,
      densityLevel: densityLevel,
    );
  }

  static int _calculateDensityLevel(int population) {
    if (population > 100000) return 5;
    if (population > 80000) return 4;
    if (population > 50000) return 3;
    if (population > 30000) return 2;
    return 1;
  }
}