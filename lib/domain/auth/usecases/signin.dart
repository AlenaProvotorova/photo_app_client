import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/auth/models/signin_req_params.dart';
import 'package:photo_app/domain/auth/repositories/auth.dart';
import 'package:photo_app/service_locator.dart';

class SignInUseCase extends Usecase<Either, SignInReqParams> {
  @override
  Future<Either> call({SignInReqParams? params}) async {
    return await sl<AuthRepository>().signIn(params!);
  }
}
