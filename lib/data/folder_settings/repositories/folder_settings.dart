import 'package:dartz/dartz.dart';
import 'package:photo_app/data/folder_settings/models/get_folder_settings_req_params.dart';
import 'package:photo_app/data/folder_settings/models/update_folder_settings_req_params.dart';
import 'package:photo_app/data/folder_settings/sourses/folder_settings_api_service.dart';
import 'package:photo_app/domain/folder_settings/repositories/folder_settings.dart';
import 'package:photo_app/service_locator.dart';

class FolderSettingsRepositoryImplementation extends FolderSettingsRepository {
  @override
  Future<Either> getFolderSettings(GetFolderSettingsReqParams params) async {
    return await sl<FolderSettingsApiService>().getFolderSettings(params);
  }

  @override
  Future<Either> updateFolderSettings(
      UpdateFolderSettingsReqParams params) async {
    return await sl<FolderSettingsApiService>().updateFolderSettings(params);
  }
}
