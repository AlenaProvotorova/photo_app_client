import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:photo_app/core/constants/api_url.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/data/files/models/upload_file_req_params.dart';
import 'package:photo_app/service_locator.dart';

abstract class FilesApiService {
  Future<Either> uploadFile(UploadFileReqParams params);
  Future<Either> getAllFiles();
}

class FilesApiServiceImplementation extends FilesApiService {
  @override
  Future<Either> uploadFile(UploadFileReqParams params) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrl.files,
        data: params.formData,
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> getAllFiles() async {
    try {
      var response = await sl<DioClient>().get(
        ApiUrl.files,
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }
}
