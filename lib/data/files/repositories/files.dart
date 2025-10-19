import 'package:dartz/dartz.dart';
import 'package:photo_app/data/files/models/delete_all_files_req_params.dart';
import 'package:photo_app/data/files/models/get_all_files_req_params.dart';
import 'package:photo_app/data/files/models/remove_files_req_params.dart';
import 'package:photo_app/data/files/models/upload_file_req_params.dart';
import 'package:photo_app/data/files/models/upload_files_batch_req_params.dart';
import 'package:photo_app/data/files/sourses/files_api_service.dart';
import 'package:photo_app/domain/files/repositories/files.dart';
import 'package:photo_app/service_locator.dart';

class FilesRepositoryImplementation extends FilesRepository {
  @override
  Future<Either> uploadFile(UploadFileReqParams params) async {
    return await sl<FilesApiService>().uploadFile(params);
  }

  @override
  Future<Either> uploadFilesBatch(UploadFilesBatchReqParams params) async {
    return await sl<FilesApiService>().uploadFilesBatch(params);
  }

  @override
  Future<Either> getAllFiles(GetAllFilesReqParams params) async {
    return await sl<FilesApiService>().getAllFiles(params);
  }

  @override
  Future<Either> removeFiles(RemoveFilesReqParams params) async {
    return await sl<FilesApiService>().removeFiles(params);
  }

  @override
  Future<Either> deleteAllFiles(DeleteAllFilesReqParams params) async {
    return await sl<FilesApiService>().deleteAllFiles(params);
  }
}
