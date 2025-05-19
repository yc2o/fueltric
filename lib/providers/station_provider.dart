import 'package:flutter/foundation.dart';
import 'package:fueltric/models/fuel_station.dart';
import 'package:fueltric/services/csv_service.dart';

class StationProvider with ChangeNotifier {
  List<FuelStation> _stations = [];
  bool _isLoading = false;
  String? _error;

  List<FuelStation> get stations => _stations;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadStations() async {
    _isLoading = true;
    notifyListeners();

    try {
      _stations = await CsvService.loadStationsFromCsv();
      _error = null;
    } catch (e) {
      _error = 'Failed to load stations: ${e.toString()}';
      _stations = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<FuelStation> getStationsByType(String type) {
    return _stations.where((station) => station.type == type).toList();
  }

  List<FuelStation> getStationsByDistrict(String district) {
    return _stations.where((station) => station.district == district).toList();
  }
}