import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/folder_settings/models/update_folder_settings_req_params.dart';
import 'package:photo_app/domain/folder_settings/repositories/folder_settings.dart';
import 'package:photo_app/service_locator.dart';

class UpdateFolderSettingsUseCase
    extends Usecase<Either, UpdateFolderSettingsReqParams> {
  @override
  Future<Either> call({UpdateFolderSettingsReqParams? params}) async {
    return await sl<FolderSettingsRepository>().updateFolderSettings(params!);
  }
}
