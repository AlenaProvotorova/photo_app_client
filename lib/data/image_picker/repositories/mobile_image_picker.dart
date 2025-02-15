import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_app/data/image_picker/models/image_data.dart';
import 'package:photo_app/domain/image_picker/repositories/image_picker.dart';

class MobileImagePickerRepositoryImplementation
    implements ImagePickerRepository {
  @override
  Future<List<ImageData>> pickImages() async {
    final picker = ImagePicker();
    final selectedFiles = await picker.pickMultiImage();

    if (selectedFiles.isNotEmpty) {
      return selectedFiles
          .map((file) => ImageData(
                path: file.path,
                bytes: null,
              ))
          .toList();
    }
    return [];
  }

  @override
  Future<MultipartFile> createMultipartFile(ImageData image) async {
    return MultipartFile.fromFile(
      image.path!,
      filename: image.path!,
    );
  }
}
