import 'package:flutter/foundation.dart';
import 'package:photo_app/core/constants/environment.dart';

class File {
  final int id;
  final String filename;
  final String originalName;
  final int size;
  final String mimetype;
  final String? deletedAt;
  final String url;
  final String? thumbnailUrl;
  File({
    required this.id,
    required this.filename,
    required this.originalName,
    required this.size,
    required this.mimetype,
    this.deletedAt,
    required this.url,
    this.thumbnailUrl,
  });

  factory File.fromJson(Map<String, dynamic>? json) {
    // Проверяем на null
    if (json == null) {
      if (kDebugMode) {
        print('⚠️ Получен null вместо данных файла');
      }
      throw Exception('File data is null');
    }

    if (kDebugMode) {
      print('Парсим File из JSON: $json');
    }

    try {
      // Безопасное извлечение полей с проверкой типов
      final idValue = json['id'];
      final id = idValue is int 
          ? idValue 
          : (idValue is num ? idValue.toInt() : 0);
      
      final filenameValue = json['filename'];
      final filename = filenameValue is String ? filenameValue : '';
      
      final originalNameValue = json['originalName'];
      final originalName = originalNameValue is String ? originalNameValue : '';
      
      final sizeValue = json['fileSize'] ?? json['size'];
      final size = sizeValue is int 
          ? sizeValue 
          : (sizeValue is num ? sizeValue.toInt() : 0);
      
      final mimetypeValue = json['mimetype'];
      final mimetype = mimetypeValue is String ? mimetypeValue : '';
      
      final deletedAtValue = json['deletedAt'];
      final deletedAt = deletedAtValue is String ? deletedAtValue : null;
      
      // Используем url, если есть, иначе path
      final urlValue = json['url'] ?? json['path'];
      final url = urlValue is String ? urlValue : '';
      
      // Пытаемся получить миниатюру из разных возможных полей
      final thumbnailValue = json['thumbnailUrl'] ?? 
                             json['thumbnail_url'] ?? 
                             json['thumbnail'] ?? 
                             json['thumbUrl'] ?? 
                             json['thumb_url'];
      final thumbnail = thumbnailValue is String ? thumbnailValue : null;
      
      // Логируем только если миниатюра найдена (для экономии логов)
      if (thumbnail != null && kDebugMode) {
        print('✅ Найдена миниатюра для файла $id: $thumbnail');
      }
      
      return File(
        id: id,
        filename: filename,
        originalName: originalName,
        size: size,
        mimetype: mimetype,
        deletedAt: deletedAt,
        url: url,
        thumbnailUrl: thumbnail,
      );
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print('❌ Ошибка парсинга File: $e');
        print('📋 JSON данные: $json');
        print('📋 StackTrace: $stackTrace');
      }
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

  /// Возвращает полный URL миниатюры изображения
  /// Если миниатюра есть, использует её, иначе возвращает полный URL изображения
  /// Если URL уже полный (начинается с http:// или https://), возвращает как есть
  /// Иначе добавляет base URL API (без /api в конце)
  String get fullThumbnailUrl {
    // Если миниатюра не задана, используем полное изображение
    final thumbnailToProcess = thumbnailUrl ?? url;
    String processedUrl = thumbnailToProcess.trim();
    
    if (processedUrl.isEmpty) {
      if (kDebugMode) {
        print('⚠️ Пустой URL для миниатюры. ID файла: $id');
      }
      return '';
    }
    
    // Убираем точку в конце URL, если есть
    if (processedUrl.endsWith('.')) {
      processedUrl = processedUrl.substring(0, processedUrl.length - 1);
    }
    
    if (processedUrl.startsWith('http://') || processedUrl.startsWith('https://')) {
      // URL уже полный (CDN или другой внешний источник)
      if (kIsWeb) {
        print('📸 Full thumbnail URL (CDN): $processedUrl');
      }
      return processedUrl;
    }
    
    // Получаем base URL без /api в конце для статических файлов
    final apiBaseUrl = EnvironmentConfig.apiBaseURL;
    // Убираем /api/ из конца, если есть
    final baseUrl = apiBaseUrl.replaceAll(RegExp(r'/api/?$'), '');
    
    // Обеспечиваем, что url начинается с /
    final cleanUrl = processedUrl.startsWith('/') ? processedUrl : '/$processedUrl';
    
    final finalUrl = '$baseUrl$cleanUrl';
    
    if (kIsWeb) {
      print('📸 Constructed thumbnail URL: $finalUrl');
    }
    
    return finalUrl;
  }
}
