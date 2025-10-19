import 'package:photo_app/data/files/models/file.dart';

abstract class FilesState {}

class FilesLoading extends FilesState {}

class FilesUploading extends FilesState {
  final List<File> existingFiles;
  final int totalFiles;
  final int uploadedFiles;
  final int failedFiles;

  FilesUploading({
    required this.existingFiles,
    required this.totalFiles,
    this.uploadedFiles = 0,
    this.failedFiles = 0,
  });

  int get remainingFiles => totalFiles - uploadedFiles - failedFiles;
  double get progress =>
      totalFiles > 0 ? (uploadedFiles + failedFiles) / totalFiles : 0.0;
}

class FilesBatchUploading extends FilesState {
  final List<File> existingFiles;
  final int totalFiles;
  final int uploadedFiles;
  final int failedFiles;
  final int currentBatch;
  final int totalBatches;

  FilesBatchUploading({
    required this.existingFiles,
    required this.totalFiles,
    required this.currentBatch,
    required this.totalBatches,
    this.uploadedFiles = 0,
    this.failedFiles = 0,
  });

  int get remainingFiles => totalFiles - uploadedFiles - failedFiles;
  double get progress =>
      totalFiles > 0 ? (uploadedFiles + failedFiles) / totalFiles : 0.0;
  double get batchProgress =>
      totalBatches > 0 ? currentBatch / totalBatches : 0.0;
}

class FilesLoaded extends FilesState {
  final List<File> files;

  FilesLoaded({
    required this.files,
  });
}

class FilesError extends FilesState {
  final String message;
  FilesError(this.message);
}

class FilesDeleting extends FilesState {
  final String message;

  FilesDeleting({
    this.message = 'Удаление всех файлов...',
  });
}
