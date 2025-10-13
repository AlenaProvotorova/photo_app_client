import 'package:dartz/dartz.dart';

abstract class UsersRepository {
  Future<Either> getAllUsers();
  Future<Either> updateIsAdmin({required int id, required bool isAdmin});
}
