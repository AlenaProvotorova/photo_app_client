import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/auth/models/signup_req_params.dart';
import 'package:photo_app/domain/auth/repositories/auth.dart';
import 'package:photo_app/service_locator.dart';

class SignUpUseCase extends Usecase<Either, SignUpReqParams> {
  @override
  Future<Either> call({SignUpReqParams? params}) async {
    return await sl<AuthRepository>().signUp(params!);
  }
}
