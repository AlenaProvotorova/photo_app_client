import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:photo_app/core/constants/api_url.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/data/folders/models/create_folder_req_params.dart';
import 'package:photo_app/service_locator.dart';

abstract class FoldersApiService {
  Future<Either> createFolder(CreateFolderReqParams params);
  Future<Either> getAllFolders();
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
}
