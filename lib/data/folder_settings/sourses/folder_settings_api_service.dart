import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:photo_app/core/constants/api_url.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/data/folder_settings/models/get_folder_settings_req_params.dart';
import 'package:photo_app/data/folder_settings/models/update_folder_settings_req_params.dart';
import 'package:photo_app/service_locator.dart';

abstract class FolderSettingsApiService {
  Future<Either> getFolderSettings(GetFolderSettingsReqParams params);
  Future<Either> updateFolderSettings(UpdateFolderSettingsReqParams params);
}

class FolderSettingsApiServiceImplementation extends FolderSettingsApiService {
  @override
  Future<Either> getFolderSettings(GetFolderSettingsReqParams params) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.folderSettings}/${params.folderId}',
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> updateFolderSettings(
      UpdateFolderSettingsReqParams params) async {
    try {
      var response = await sl<DioClient>().patch(
        '${ApiUrl.folderSettings}/${params.folderId}',
        data: params.settings,
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }
}
