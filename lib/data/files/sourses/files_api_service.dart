import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:photo_app/core/constants/api_url.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/data/files/models/get_all_files_req_params.dart';
import 'package:photo_app/data/files/models/remove_files_req_params.dart';
import 'package:photo_app/data/files/models/upload_file_req_params.dart';
import 'package:photo_app/service_locator.dart';

abstract class FilesApiService {
  Future<Either> uploadFile(UploadFileReqParams params);
  Future<Either> getAllFiles(GetAllFilesReqParams params);
  Future<Either> removeFiles(RemoveFilesReqParams params);
}

class FilesApiServiceImplementation extends FilesApiService {
  @override
  Future<Either> uploadFile(UploadFileReqParams params) async {
    try {
      var response = await sl<DioClient>().post(
        '${ApiUrl.files}?folderId=${params.folderId}',
        data: params.formData,
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> getAllFiles(GetAllFilesReqParams params) async {
    try {
      var response = await sl<DioClient>().get(
        ApiUrl.files,
        queryParameters: {
          'folderId': params.folderId,
        },
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either<String, dynamic>> removeFiles(
      RemoveFilesReqParams params) async {
    try {
      var response = await sl<DioClient>().delete(
        ApiUrl.files,
        queryParameters: {
          'ids': params.ids,
          'folderId': params.folderId,
        },
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }
}
