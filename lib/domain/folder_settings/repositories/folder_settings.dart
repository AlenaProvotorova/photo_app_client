import 'package:dartz/dartz.dart';
import 'package:photo_app/data/folder_settings/models/get_folder_settings_req_params.dart';
import 'package:photo_app/data/folder_settings/models/update_folder_settings_req_params.dart';

abstract class FolderSettingsRepository {
  Future<Either> getFolderSettings(GetFolderSettingsReqParams params);
  Future<Either> updateFolderSettings(UpdateFolderSettingsReqParams params);
}
