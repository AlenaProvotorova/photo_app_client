import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:photo_app/core/constants/api_url.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/service_locator.dart';

abstract class SizeApiService {
  Future<Either> getSizes();
}

class SizeApiServiceImplementation extends SizeApiService {
  @override
  Future<Either> getSizes() async {
    try {
      var response = await sl<DioClient>().get(
        ApiUrl.sizes,
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }
}
