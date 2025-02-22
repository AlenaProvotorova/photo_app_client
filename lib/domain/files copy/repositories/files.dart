import 'package:dartz/dartz.dart';
import 'package:photo_app/data/files/models/get_all_files_req_params.dart';
import 'package:photo_app/data/files/models/upload_file_req_params.dart';

abstract class FilesRepository {
  Future<Either> uploadFile(UploadFileReqParams params);
  Future<Either> getAllFiles(GetAllFilesReqParams params);
}
