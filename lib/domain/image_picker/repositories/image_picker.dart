import 'package:dio/dio.dart';
import 'package:photo_app/data/image_picker/models/image_data.dart';

abstract class ImagePickerRepository {
  Future<List<ImageData>> pickImages();
  Future<MultipartFile> createMultipartFile(ImageData image);
}
