import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/folders/models/edit_folder_req_params.dart';
import 'package:photo_app/domain/folders/repositories/folders.dart';
import 'package:photo_app/service_locator.dart';

class EditFolderUseCase extends Usecase<Either, EditFolderReqParams> {
  @override
  Future<Either> call({EditFolderReqParams? params}) async {
    return await sl<FoldersRepository>().editFolder(params!);
  }
}
