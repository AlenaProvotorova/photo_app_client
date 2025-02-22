import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:photo_app/core/constants/api_url.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/service_locator.dart';

abstract class UserApiService {
  Future<Either> getUser();
}

class UserApiServiceImplementation extends UserApiService {
  @override
  Future<Either> getUser() async {
    try {
      var response = await sl<DioClient>().get(
        ApiUrl.userProfile,
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }
}
