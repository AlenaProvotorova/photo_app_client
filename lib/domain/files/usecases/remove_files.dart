import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/files/models/remove_files_req_params.dart';
import 'package:photo_app/domain/files/repositories/files.dart';
import 'package:photo_app/service_locator.dart';

class RemoveFilesUseCase extends Usecase<Either, RemoveFilesReqParams> {
  @override
  Future<Either> call({RemoveFilesReqParams? params}) async {
    return await sl<FilesRepository>().removeFiles(params!);
  }
}
