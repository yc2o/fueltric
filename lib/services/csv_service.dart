import 'dart:async';
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import 'package:fueltric/models/fuel_station.dart';

class CsvService {
  static Future<List<FuelStation>> loadStationsFromCsv() async {
    try {
      final csvData = await rootBundle.loadString('assets/data/stations.csv');
      final List<List<dynamic>> csvTable = const CsvToListConverter().convert(csvData);
      
      // Skip header row and convert each row to FuelStation
      return csvTable.skip(1).map((row) => FuelStation.fromCsv(row)).toList();
    } catch (e) {
      throw Exception('Failed to load CSV: $e');
    }
  }
}