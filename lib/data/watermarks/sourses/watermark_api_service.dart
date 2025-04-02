import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:photo_app/core/constants/api_url.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/data/watermarks/models/get_watermark_req_params.dart';
import 'package:photo_app/data/watermarks/models/remove_watermark_req_params.dart';
import 'package:photo_app/data/watermarks/models/upload_watermark_req_params.dart';
import 'package:photo_app/service_locator.dart';

abstract class WatermarkApiService {
  Future<Either> uploadWatermark(UploadWatermarkReqParams params);
  Future<Either> getWatermark(GetAllWatermarksReqParams params);
  Future<Either> removeWatermark(RemoveWatermarkReqParams params);
}

class WatermarkApiServiceImplementation extends WatermarkApiService {
  @override
  Future<Either> uploadWatermark(UploadWatermarkReqParams params) async {
    try {
      var response = await sl<DioClient>().post(
        '${ApiUrl.watermarks}?userId=${params.userId}',
        data: params.formData,
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> getWatermark(GetAllWatermarksReqParams params) async {
    try {
      var response = await sl<DioClient>().get(
        ApiUrl.watermarks,
        queryParameters: {
          'userId': params.userId,
        },
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either<String, dynamic>> removeWatermark(
      RemoveWatermarkReqParams params) async {
    try {
      var response = await sl<DioClient>().delete(
        ApiUrl.watermarks,
        queryParameters: {
          'userId': params.userId,
        },
      );
      return Right(response);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }
}
