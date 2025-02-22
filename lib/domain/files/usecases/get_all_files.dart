import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/files/models/get_all_files_req_params.dart';
import 'package:photo_app/domain/files/repositories/files.dart';
import 'package:photo_app/service_locator.dart';

class GetAllFilesUseCase extends Usecase<Either, GetAllFilesReqParams> {
  @override
  Future<Either> call({GetAllFilesReqParams? params}) async {
    return await sl<FilesRepository>().getAllFiles(params!);
  }
}
