import 'package:flutter/material.dart';
import 'package:photo_app/data/image_picker/models/image_data.dart';

abstract class FilesEvent {}

class LoadFiles extends FilesEvent {
  final String folderId;

  LoadFiles({required this.folderId});
}

class UploadFiles extends FilesEvent {
  final String folderId;
  final List<ImageData> images;
  final BuildContext context;

  UploadFiles({
    required this.folderId,
    required this.images,
    required this.context,
  });
}

class UpdateFilePrintedFormats extends FilesEvent {
  final int fileId;
  final String sizeType;
  final String printFormat;

  UpdateFilePrintedFormats({
    required this.fileId,
    required this.sizeType,
    required this.printFormat,
  });
}
