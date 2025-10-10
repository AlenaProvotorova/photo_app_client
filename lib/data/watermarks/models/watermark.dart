class Watermark {
  final int id;
  final String filename;
  final String originalName;
  final int fileSize;
  final String mimetype;
  final String? deletedAt;
  final String url;
  final String? path;
  final bool isActive;
  final double opacity;
  final String position;
  final double size;
  final int userId;

  Watermark({
    required this.id,
    required this.filename,
    required this.originalName,
    required this.fileSize,
    required this.mimetype,
    this.deletedAt,
    required this.url,
    this.path,
    required this.isActive,
    required this.opacity,
    required this.position,
    required this.size,
    required this.userId,
  });

  factory Watermark.fromJson(Map<String, dynamic> json) {
    print('Парсим Watermark из JSON: $json');

    try {
      return Watermark(
        id: json['id'] ?? 0,
        filename: json['filename'] ?? '',
        originalName: json['originalName'] ?? '',
        fileSize: json['fileSize'] ?? 0,
        mimetype: json['mimetype'] ?? '',
        deletedAt: json['deletedAt'],
        url: json['url'] ?? '',
        path: json['path'],
        isActive: json['isActive'] ?? true,
        opacity: (json['opacity'] ?? 1.0).toDouble(),
        position: json['position'] ?? 'center',
        size: (json['size'] ?? 1.0).toDouble(),
        userId: json['userId'] ?? 0,
      );
    } catch (e) {
      print('Ошибка парсинга Watermark: $e');
      print('JSON данные: $json');
      rethrow;
    }
  }
}
