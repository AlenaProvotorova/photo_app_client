import 'package:dartz/dartz.dart';
import 'package:photo_app/data/users/sources/users_api_service.dart';
import 'package:photo_app/domain/users/repositories/users.dart';
import 'package:photo_app/service_locator.dart';

class UsersRepositoryImplementation extends UsersRepository {
  @override
  Future<Either> getAllUsers() async {
    return await sl<UsersApiService>().getAllUsers();
  }

  @override
  Future<Either> updateIsAdmin({required int id, required bool isAdmin}) async {
    return await sl<UsersApiService>().updateIsAdmin(id: id, isAdmin: isAdmin);
  }
}
