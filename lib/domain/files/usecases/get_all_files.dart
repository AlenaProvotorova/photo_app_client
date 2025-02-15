import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/domain/files/repositories/files.dart';
import 'package:photo_app/service_locator.dart';

class GetAllFilesUseCase extends Usecase<Either, void> {
  @override
  Future<Either> call({void params}) async {
    return await sl<FilesRepository>().getAllFiles();
  }
}
