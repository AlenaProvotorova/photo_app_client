import 'package:flutter/material.dart';
import 'package:photo_app/data/image_picker/models/image_data.dart';

abstract class FilesEvent {}

class LoadFiles extends FilesEvent {}

class AddImages extends FilesEvent {
  final List<ImageData> images;
  final BuildContext context;

  AddImages(this.images, this.context);
}

class UploadImage extends FilesEvent {
  final ImageData image;
  final BuildContext context;

  UploadImage(this.image, this.context);
}
