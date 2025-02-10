// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:photo_app/data/auth/models/signin_req_params.dart';

import 'package:photo_app/data/auth/models/signup_req_params.dart';
import 'package:photo_app/data/auth/sources/auth_api_service.dart';
import 'package:photo_app/domain/auth/repositories/auth.dart';
import 'package:photo_app/service_locator.dart';

class AuthRepositoryImplementation extends AuthRepository {
  @override
  Future<Either> signUp(SignUpReqParams params) async {
    return await sl<AuthApiService>().signUp(params);
  }

  @override
  Future<Either> signIn(SignInReqParams params) async {
    return await sl<AuthApiService>().signIn(params);
  }
}
