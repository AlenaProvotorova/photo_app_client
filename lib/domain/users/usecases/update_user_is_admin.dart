import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/domain/users/repositories/users.dart';
import 'package:photo_app/service_locator.dart';

class UpdateUserIsAdminParams {
  final int id;
  final bool isAdmin;
  UpdateUserIsAdminParams({required this.id, required this.isAdmin});
}

class UpdateUserIsAdminUseCase
    extends Usecase<Either, UpdateUserIsAdminParams> {
  @override
  Future<Either> call({UpdateUserIsAdminParams? params}) async {
    return await sl<UsersRepository>()
        .updateIsAdmin(id: params!.id, isAdmin: params.isAdmin);
  }
}
