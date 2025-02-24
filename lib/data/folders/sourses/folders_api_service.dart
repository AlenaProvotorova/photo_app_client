import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:photo_app/core/constants/api_url.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/data/folders/models/create_folder_req_params.dart';
import 'package:photo_app/data/folders/models/delete_folder_req_params.dart';
import 'package:photo_app/data/folders/models/edit_folder_req_params.dart';
import 'package:photo_app/service_locator.dart';

abstract class FoldersApiService {
  Future<Either> createFolder(CreateFolderReqParams params);
  Future<Either> getAllFolders();
  Future<Either> deleteFolder(DeleteFolderReqParams params);
  Future<Either> editFolder(EditFolderReqParams params);
}

class FoldersApiServiceImplementation extends FoldersApiService {
  @override
  Future<Either> createFolder(CreateFolderReqParams params) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrl.folders,
        data: params.toMap(),
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> getAllFolders() async {
    try {
      var response = await sl<DioClient>().get(
        ApiUrl.folders,
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> deleteFolder(DeleteFolderReqParams params) async {
    try {
      var response = await sl<DioClient>().delete(
        '${ApiUrl.folders}/${params.id}',
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> editFolder(EditFolderReqParams params) async {
    try {
      var response = await sl<DioClient>().patch(
        '${ApiUrl.folders}/${params.id}',
        data: params.toMap(),
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }
}
