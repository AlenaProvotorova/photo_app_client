import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/folders/models/delete_folder_req_params.dart';
import 'package:photo_app/domain/folders/repositories/folders.dart';
import 'package:photo_app/service_locator.dart';

class DeleteFolderUseCase extends Usecase<Either, DeleteFolderReqParams> {
  @override
  Future<Either> call({DeleteFolderReqParams? params}) async {
    return await sl<FoldersRepository>().deleteFolder(params!);
  }
}
