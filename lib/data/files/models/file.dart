class File {
  final int id;
  final String filename;
  final String originalName;
  final int size;
  final String mimetype;
  final String? deletedAt;
  final String url;
  File({
    required this.id,
    required this.filename,
    required this.originalName,
    required this.size,
    required this.mimetype,
    this.deletedAt,
    required this.url,
  });

  factory File.fromJson(Map<String, dynamic> json) {
    print('Парсим File из JSON: $json');

    try {
      return File(
        id: json['id'] ?? 0,
        filename: json['filename'] ?? '',
        originalName: json['originalName'] ?? '',
        size: json['fileSize'] ??
            json['size'] ??
            0, // Используем fileSize вместо size
        mimetype: json['mimetype'] ?? '',
        deletedAt: json['deletedAt'],
        url: json['url'] ?? '',
      );
    } catch (e) {
      print('Ошибка парсинга File: $e');
      print('JSON данные: $json');
      rethrow;
    }
  }
}
