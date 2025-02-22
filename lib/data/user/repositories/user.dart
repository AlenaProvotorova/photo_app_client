// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:photo_app/data/user/sources/user_api_service.dart';
import 'package:photo_app/domain/user/repositories/user.dart';
import 'package:photo_app/service_locator.dart';

class UserRepositoryImplementation extends UserRepository {
  @override
  Future<Either> getUser() async {
    return await sl<UserApiService>().getUser();
  }
}
