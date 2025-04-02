import 'package:flutter/material.dart';
import 'package:photo_app/data/image_picker/models/image_data.dart';

abstract class WatermarkEvent {}

class LoadWatermark extends WatermarkEvent {
  final String userId;

  LoadWatermark({required this.userId});
}

class UploadWatermark extends WatermarkEvent {
  final String userId;
  final ImageData image;
  final BuildContext context;

  UploadWatermark({
    required this.userId,
    required this.image,
    required this.context,
  });
}

class UpdateWatermarkPrintedFormats extends WatermarkEvent {
  final int watermarkId;

  UpdateWatermarkPrintedFormats({
    required this.watermarkId,
  });
}

class DeleteWatermark extends WatermarkEvent {
  final String userId;
  final BuildContext context;

  DeleteWatermark({
    required this.userId,
    required this.context,
  });
}
