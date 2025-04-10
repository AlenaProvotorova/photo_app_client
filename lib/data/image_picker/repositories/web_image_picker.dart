import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:photo_app/data/image_picker/models/image_data.dart';
import 'package:photo_app/domain/image_picker/repositories/image_picker.dart';

class WebImagePickerRepositoryImplementation implements ImagePickerRepository {
  @override
  Future<List<ImageData>> pickImages() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      return result.files
          .map((file) => ImageData(
                bytes: file.bytes,
                path: file.name,
              ))
          .toList();
    }
    return [];
  }

  @override
  Future<MultipartFile> createMultipartFile(ImageData image) async {
    return MultipartFile.fromBytes(
      image.bytes!,
      filename: image.path,
    );
  }
}
