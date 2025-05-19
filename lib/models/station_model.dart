class FuelStation {
  final String id;
  final String name;
  final String type; // Akan kita tentukan dari nama
  final String address;
  final String city;
  final double latitude;
  final double longitude;
  final String district;
  final int population;

  const FuelStation({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.city,
    required this.latitude,
    required this.longitude,
    required this.district,
    required this.population,
  });

  factory FuelStation.fromCsv(List<dynamic> row) {
    // Menentukan jenis stasiun dari nama
    final name = row[1].toString();
    final type = name.contains('SPKLU') 
        ? 'SPKLU' 
        : (name.contains('Pertamina') || name.contains('Shell') || name.contains('BP'))
            ? 'SPBU'
            : 'SPBU'; // Default ke SPBU jika tidak diketahui

    return FuelStation(
      id: row[0].toString(),
      name: name,
      type: type,
      address: row[2].toString(),
      city: row[3].toString(),
      latitude: double.parse(row[4].toString()),
      longitude: double.parse(row[5].toString()),
      district: row[6].toString(),
      population: int.parse(row[7].toString()),
    );
  }
}