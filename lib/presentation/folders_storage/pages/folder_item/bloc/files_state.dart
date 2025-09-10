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
