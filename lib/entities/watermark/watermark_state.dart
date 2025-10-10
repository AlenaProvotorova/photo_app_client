import 'package:photo_app/data/watermarks/models/watermark.dart';

abstract class WatermarkState {}

class WatermarkLoading extends WatermarkState {}

class WatermarkLoaded extends WatermarkState {
  final Watermark? watermark;

  WatermarkLoaded({
    required this.watermark,
  });
}

class WatermarkError extends WatermarkState {
  final String message;
  WatermarkError(this.message);
}
