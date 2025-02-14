import 'package:dartz/dartz.dart';
import 'package:photo_app/data/folders/models/create_folder_req_params.dart';
import 'package:photo_app/data/folders/models/delete_folder_req_params.dart';
import 'package:photo_app/data/folders/sourses/folders_api_service.dart';
import 'package:photo_app/domain/folders/repositories/folders.dart';
import 'package:photo_app/service_locator.dart';

class FoldersRepositoryImplementation extends FoldersRepository {
  @override
  Future<Either> createFolder(CreateFolderReqParams params) async {
    return await sl<FoldersApiService>().createFolder(params);
  }

  @override
  Future<Either> getAllFolders() async {
    return await sl<FoldersApiService>().getAllFolders();
  }

  @override
  Future<Either> deleteFolder(DeleteFolderReqParams id) async {
    return await sl<FoldersApiService>().deleteFolder(id);
  }
}
