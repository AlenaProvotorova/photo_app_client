import 'package:photo_app/core/constants/environment.dart';

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
      // Используем url, если есть, иначе path
      final urlValue = json['url'] ?? json['path'] ?? '';
      
      return File(
        id: json['id'] ?? 0,
        filename: json['filename'] ?? '',
        originalName: json['originalName'] ?? '',
        size: json['fileSize'] ??
            json['size'] ??
            0, // Используем fileSize вместо size
        mimetype: json['mimetype'] ?? '',
        deletedAt: json['deletedAt'],
        url: urlValue,
      );
    } catch (e) {
      print('Ошибка парсинга File: $e');
      print('JSON данные: $json');
      rethrow;
    }
  }

  /// Возвращает полный URL изображения
  /// Если URL уже полный (начинается с http:// или https://), возвращает как есть
  /// Иначе добавляет base URL API (без /api в конце, т.к. файлы могут быть в /uploads или другом пути)
  String get fullUrl {
    String processedUrl = url.trim();
    
    // Убираем точку в конце URL, если есть
    if (processedUrl.endsWith('.')) {
      processedUrl = processedUrl.substring(0, processedUrl.length - 1);
    }
    
    if (processedUrl.startsWith('http://') || processedUrl.startsWith('https://')) {
      return processedUrl;
    }
    
    // Получаем base URL без /api в конце для статических файлов
    final apiBaseUrl = EnvironmentConfig.apiBaseURL;
    // Убираем /api/ из конца, если есть
    final baseUrl = apiBaseUrl.replaceAll(RegExp(r'/api/?$'), '');
    
    // Обеспечиваем, что url начинается с /
    final cleanUrl = processedUrl.startsWith('/') ? processedUrl : '/$processedUrl';
    
    return '$baseUrl$cleanUrl';
  }
}
