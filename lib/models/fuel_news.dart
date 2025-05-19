class FuelNews {
  final String id;
  final String title;
  final String description;
  final String content;
  final String source;
  final DateTime publishedAt;
  final String imageUrl;
  final String category; // 'gasoline', 'electric', 'policy', etc.

  FuelNews({
    required this.id,
    required this.title,
    required this.description,
    required this.content,
    required this.source,
    required this.publishedAt,
    required this.imageUrl,
    required this.category,
  });

  factory FuelNews.fromJson(Map<String, dynamic> json) {
    return FuelNews(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      content: json['content'] ?? '',
      source: json['source'] ?? 'Unknown',
      publishedAt: DateTime.parse(json['publishedAt']),
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
      category: json['category'] ?? 'general',
    );
  }

  String get formattedDate {
    final day = publishedAt.day.toString().padLeft(2, '0');
    final month = publishedAt.month.toString().padLeft(2, '0');
    final year = publishedAt.year;
    return '$day/$month/$year';
  }
}