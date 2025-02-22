import 'package:photo_app/data/files/models/file.dart';

abstract class FilesState {}

class FilesLoading extends FilesState {}

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
