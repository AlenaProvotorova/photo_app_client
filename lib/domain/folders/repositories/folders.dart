import 'package:dartz/dartz.dart';
import 'package:photo_app/data/folders/models/create_folder_req_params.dart';

abstract class FoldersRepository {
  Future<Either> createFolder(CreateFolderReqParams params);
  Future<Either> getAllFolders();
}
