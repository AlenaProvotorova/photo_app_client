import 'package:photo_app/data/files/models/file.dart';
import 'package:photo_app/data/image_picker/models/image_data.dart';

abstract class FilesState {}

class FilesLoading extends FilesState {}

class FilesLoaded extends FilesState {
  final List<File> files;
  final List<ImageData> images;

  FilesLoaded({
    required this.files,
    this.images = const [],
  });
}

class FilesError extends FilesState {
  final String message;
  FilesError(this.message);
}
