import 'package:flutter/material.dart';
import 'package:photo_app/data/image_picker/models/image_data.dart';

abstract class FilesEvent {}

class LoadFiles extends FilesEvent {
  final String folderId;

  LoadFiles({required this.folderId});
}

class UploadImage extends FilesEvent {
  final ImageData image;
  final BuildContext context;
  final String folderId;

  UploadImage({
    required this.image,
    required this.context,
    required this.folderId,
  });
}
