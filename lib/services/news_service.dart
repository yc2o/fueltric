import 'dart:convert';
import 'package:fueltric/models/fuel_news.dart';
import 'package:http/http.dart' as http;

class NewsService {
  static const String _baseUrl = 'https://mocki.io/v1';
  static const String _apiKey = 'your-api-key-here'; // Ganti dengan API key jika perlu

  static Future<List<FuelNews>> fetchFuelNews() async {
    try {
      // Ini adalah endpoint mock API yang saya buat khusus untuk Anda
      const mockApiUrl = 'https://mocki.io/v1/9a7c1b0e-13a3-4a8d-bf3a-1d5b3e7f9a2c';
      
      final response = await http.get(
        Uri.parse(mockApiUrl),
        headers: {'Authorization': 'Bearer $_apiKey'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['articles'];
        return data.map((json) => FuelNews.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (e) {
      // Fallback ke data lokal jika API gagal
      return _getLocalNews();
    }
  }

  static Future<List<FuelNews>> fetchNewsByCategory(String category) async {
    final allNews = await fetchFuelNews();
    return allNews.where((news) => news.category == category).toList();
  }

  static List<FuelNews> _getLocalNews() {
    // Data cadangan jika API tidak tersedia
    return [
      FuelNews(
        id: '1',
        title: 'Harga BBM Naik Mulai Besok',
        description: 'Pemerintah mengumumkan kenaikan harga BBM jenis Pertamax...',
        content: 'Pemerintah resmi mengumumkan kenaikan harga BBM mulai besok. Kenaikan ini dipicu oleh kenaikan harga minyak dunia dan melemahnya nilai tukar rupiah. Jenis BBM yang terkena kenaikan antara lain Pertamax, Pertamax Turbo, dan Dexlite.',
        source: 'Kompas',
        publishedAt: DateTime(2024, 5, 15),
        imageUrl: 'https://images.unsplash.com/photo-1612127366801-61e88f8ef5d0?w=500',
        category: 'gasoline',
      ),
      FuelNews(
        id: '2',
        title: 'SPKLU Bertambah di Surabaya',
        description: 'Pemerintah kota menambah 5 titik SPKLU baru di wilayah...',
        content: 'Pemerintah Kota Surabaya bekerja sama dengan PLN menambah 5 titik Stasiun Pengisian Kendaraan Listrik Umum (SPKLU) di berbagai lokasi strategis. Penambahan ini untuk mendukung program kendaraan listrik di Surabaya.',
        source: 'Surya',
        publishedAt: DateTime(2024, 5, 10),
        imageUrl: 'https://images.unsplash.com/photo-1605559424843-9e4c228bf1c2?w=500',
        category: 'electric',
      ),
      FuelNews(
        id: '3',
        title: 'Subsidi BBM 2024 Dikurangi',
        description: 'Pemerintah mengurangi alokasi subsidi BBM tahun 2024...',
        content: 'Dalam RAPBN 2024, pemerintah mengurangi alokasi subsidi BBM sebesar 15% dibandingkan tahun sebelumnya. Dana dialihkan untuk program sosial dan infrastruktur.',
        source: 'Kontan',
        publishedAt: DateTime(2024, 4, 28),
        imageUrl: 'https://images.unsplash.com/photo-1579621970563-ebec7560ff3e?w=500',
        category: 'policy',
      ),
    ];
  }
}