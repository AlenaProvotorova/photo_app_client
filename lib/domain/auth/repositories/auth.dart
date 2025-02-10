import 'package:dartz/dartz.dart';
import 'package:photo_app/data/auth/models/signin_req_params.dart';
import 'package:photo_app/data/auth/models/signup_req_params.dart';

abstract class AuthRepository {
  Future<Either> signUp(SignUpReqParams params);
  Future<Either> signIn(SignInReqParams params);
}
