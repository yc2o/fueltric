class District {
  final String name;
  final int stationCount;
  final int densityLevel; // 1-5 untuk warna

  District({
    required this.name,
    required this.stationCount,
    required this.densityLevel,
  });

  factory District.fromJson(Map<String, dynamic> json) {
    return District(
      name: json['name'],
      stationCount: json['stationCount'],
      densityLevel: json['densityLevel'],
    );
  }
}