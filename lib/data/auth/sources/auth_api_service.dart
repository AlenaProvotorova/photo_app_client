import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:photo_app/core/constants/api_url.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/core/utils/token_storage.dart';
import 'package:photo_app/data/auth/models/signin_req_params.dart';
import 'package:photo_app/data/auth/models/signup_req_params.dart';
import 'package:photo_app/service_locator.dart';

abstract class AuthApiService {
  Future<Either> signUp(SignUpReqParams params);
  Future<Either> signIn(SignInReqParams params);
}

class AuthApiServiceImplementation extends AuthApiService {
  @override
  Future<Either> signUp(SignUpReqParams params) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrl.signUp,
        data: params.toMap(),
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> signIn(SignInReqParams params) async {
    try {
      var response = await sl<DioClient>().post(
        ApiUrl.signIn,
        data: params.toMap(),
      );
      TokenStorage.saveToken(response.data['token']);
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }
}
