import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/folder_settings/models/get_folder_settings_req_params.dart';
import 'package:photo_app/domain/folder_settings/repositories/folder_settings.dart';
import 'package:photo_app/service_locator.dart';

class GetFolderSettingsUseCase
    extends Usecase<Either, GetFolderSettingsReqParams> {
  @override
  Future<Either> call({GetFolderSettingsReqParams? params}) async {
    return await sl<FolderSettingsRepository>().getFolderSettings(params!);
  }
}
