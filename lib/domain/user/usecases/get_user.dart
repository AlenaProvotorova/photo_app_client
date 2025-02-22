import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/domain/user/repositories/user.dart';
import 'package:photo_app/service_locator.dart';

class GetUserUseCase extends Usecase<Either, void> {
  @override
  Future<Either> call({void params}) async {
    return await sl<UserRepository>().getUser();
  }
}
