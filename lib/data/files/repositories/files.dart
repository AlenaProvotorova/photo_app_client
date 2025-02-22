import 'package:dartz/dartz.dart';
import 'package:photo_app/data/files/models/get_all_files_req_params.dart';
import 'package:photo_app/data/files/models/upload_file_req_params.dart';
import 'package:photo_app/data/files/sourses/files_api_service.dart';
import 'package:photo_app/domain/files/repositories/files.dart';
import 'package:photo_app/service_locator.dart';

class FilesRepositoryImplementation extends FilesRepository {
  @override
  Future<Either> uploadFile(UploadFileReqParams params) async {
    return await sl<FilesApiService>().uploadFile(params);
  }

  @override
  Future<Either> getAllFiles(GetAllFilesReqParams params) async {
    return await sl<FilesApiService>().getAllFiles(params);
  }
}
