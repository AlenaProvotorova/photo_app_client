import 'package:photo_app/data/files/models/file.dart';

abstract class WatermarkState {}

class WatermarkLoading extends WatermarkState {}

class WatermarkLoaded extends WatermarkState {
  final File? watermark;

  WatermarkLoaded({
    required this.watermark,
  });
}

class WatermarkError extends WatermarkState {
  final String message;
  WatermarkError(this.message);
}
