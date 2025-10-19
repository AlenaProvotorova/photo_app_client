import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:photo_app/data/files/models/upload_progress.dart';
import 'package:photo_app/data/image_picker/models/image_data.dart';

class FileUploadService {
  static const int maxFilesPerBatch = 200;
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const int maxTotalFiles = 1000;

  /// Валидация файлов перед загрузкой
  static List<String> validateFiles(List<ImageData> files) {
    final errors = <String>[];

    if (files.length > maxTotalFiles) {
      errors.add('Максимум $maxTotalFiles файлов за раз');
    }

    for (int i = 0; i < files.length; i++) {
      final file = files[i];
      final fileSize = _getFileSize(file);

      if (fileSize > maxFileSize) {
        errors.add('Файл ${file.path} превышает лимит 5MB');
      }

      if (fileSize == 0) {
        errors.add('Файл ${file.path} пустой');
      }
    }

    return errors;
  }

  /// Получение размера файла
  static int _getFileSize(ImageData file) {
    if (kIsWeb) {
      return file.bytes?.length ?? 0;
    } else {
      return File(file.path!).lengthSync();
    }
  }

  /// Разделение файлов на пакеты
  static List<List<ImageData>> splitIntoBatches(List<ImageData> files) {
    final batches = <List<ImageData>>[];
    for (int i = 0; i < files.length; i += maxFilesPerBatch) {
      final end = (i + maxFilesPerBatch < files.length)
          ? i + maxFilesPerBatch
          : files.length;
      batches.add(files.sublist(i, end));
    }
    return batches;
  }

  /// Создание FormData для пакета файлов
  static Future<FormData> createBatchFormData(List<ImageData> files) async {
    final formData = FormData();

    for (final file in files) {
      if (kIsWeb) {
        formData.files.add(MapEntry(
          'files',
          MultipartFile.fromBytes(
            file.bytes!,
            filename: file.path,
          ),
        ));
      } else {
        formData.files.add(MapEntry(
          'files',
          await MultipartFile.fromFile(file.path!),
        ));
      }
    }

    return formData;
  }

  /// Сжатие изображений (базовая реализация)
  static Future<List<ImageData>> compressImages(List<ImageData> files) async {
    // В Flutter сжатие изображений обычно делается через image package
    // Здесь базовая реализация без сжатия
    // В реальном проекте можно добавить сжатие через flutter_image_compress
    return files;
  }

  /// Создание прогресса загрузки
  static UploadProgress createProgress({
    required int currentBatch,
    required int totalBatches,
    required int uploadedFiles,
    required int totalFiles,
    int failedFiles = 0,
  }) {
    return UploadProgress(
      currentBatch: currentBatch,
      totalBatches: totalBatches,
      uploadedFiles: uploadedFiles,
      totalFiles: totalFiles,
      failedFiles: failedFiles,
    );
  }
}
