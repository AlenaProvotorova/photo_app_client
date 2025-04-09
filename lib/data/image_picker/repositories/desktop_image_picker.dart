import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:photo_app/data/image_picker/models/image_data.dart';
import 'package:photo_app/domain/image_picker/repositories/image_picker.dart';

class DesktopImagePickerRepositoryImplementation
    implements ImagePickerRepository {
  @override
  Future<List<ImageData>> pickImages() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
        lockParentWindow: true,
      );

      if (result == null || result.files.isEmpty) {
        return [];
      }

      return result.files
          .map((file) => ImageData(
                path: file.path,
                bytes: null,
              ))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<MultipartFile> createMultipartFile(ImageData image) async {
    return MultipartFile.fromFile(
      image.path!,
      filename: image.path!,
    );
  }
}
