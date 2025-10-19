import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/files/models/upload_files_batch_req_params.dart';
import 'package:photo_app/domain/files/repositories/files.dart';
import 'package:photo_app/service_locator.dart';

class UploadFilesBatchUseCase
    extends Usecase<Either, UploadFilesBatchReqParams> {
  @override
  Future<Either> call({UploadFilesBatchReqParams? params}) async {
    return await sl<FilesRepository>().uploadFilesBatch(params!);
  }
}
