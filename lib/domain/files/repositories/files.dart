import 'package:dartz/dartz.dart';
import 'package:photo_app/data/files/models/delete_all_files_req_params.dart';
import 'package:photo_app/data/files/models/get_all_files_req_params.dart';
import 'package:photo_app/data/files/models/remove_files_req_params.dart';
import 'package:photo_app/data/files/models/upload_file_req_params.dart';
import 'package:photo_app/data/files/models/upload_files_batch_req_params.dart';

abstract class FilesRepository {
  Future<Either> uploadFile(UploadFileReqParams params);
  Future<Either> uploadFilesBatch(UploadFilesBatchReqParams params);
  Future<Either> getAllFiles(GetAllFilesReqParams params);
  Future<Either> removeFiles(RemoveFilesReqParams params);
  Future<Either> deleteAllFiles(DeleteAllFilesReqParams params);
}
