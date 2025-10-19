import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/files/models/delete_all_files_req_params.dart';
import 'package:photo_app/domain/files/repositories/files.dart';
import 'package:photo_app/service_locator.dart';

class DeleteAllFilesUseCase extends Usecase<Either, DeleteAllFilesReqParams> {
  @override
  Future<Either> call({DeleteAllFilesReqParams? params}) async {
    return await sl<FilesRepository>().deleteAllFiles(params!);
  }
}
