import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/folders/models/create_folder_req_params.dart';
import 'package:photo_app/domain/folders/repositories/folders.dart';
import 'package:photo_app/service_locator.dart';

class CreateFolderUseCase extends Usecase<Either, CreateFolderReqParams> {
  @override
  Future<Either> call({CreateFolderReqParams? params}) async {
    return await sl<FoldersRepository>().createFolder(params!);
  }
}
