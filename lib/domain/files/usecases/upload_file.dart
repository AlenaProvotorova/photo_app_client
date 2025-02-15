import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/files/models/upload_file_req_params.dart';
import 'package:photo_app/domain/files/repositories/files.dart';
import 'package:photo_app/service_locator.dart';

class UploadFileUseCase extends Usecase<Either, UploadFileReqParams> {
  @override
  Future<Either> call({UploadFileReqParams? params}) async {
    return await sl<FilesRepository>().uploadFile(params!);
  }
}
