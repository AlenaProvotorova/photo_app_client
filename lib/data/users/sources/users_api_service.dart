import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:photo_app/core/constants/api_url.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/service_locator.dart';

abstract class UsersApiService {
  Future<Either> getAllUsers();
  Future<Either> updateIsAdmin({required int id, required bool isAdmin});
}

class UsersApiServiceImplementation extends UsersApiService {
  @override
  Future<Either> getAllUsers() async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      var response = await sl<DioClient>().get(
        '${ApiUrl.users}?_t=$timestamp',
      );
      return Right(response.data);
    } on DioException catch (e) {
      String errorMessage = 'Неизвестная ошибка';

      if (e.response != null) {
        if (e.response!.data is Map<String, dynamic>) {
          errorMessage = e.response!.data['message'] ??
              e.response!.data['error'] ??
              'Ошибка сервера';
        } else {
          errorMessage = e.response!.data.toString();
        }
      } else {
        errorMessage = 'Ошибка сети: ${e.message}';
      }

      return Left(errorMessage);
    } catch (e) {
      return Left('Неожиданная ошибка: ${e.toString()}');
    }
  }

  @override
  Future<Either> updateIsAdmin({required int id, required bool isAdmin}) async {
    try {
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final response = await sl<DioClient>().patch(
        '${ApiUrl.users}/$id?_t=$timestamp',
        data: {
          'isAdmin': isAdmin,
        },
      );

      return Right(response.data);
    } on DioException catch (e) {
      String errorMessage = 'Неизвестная ошибка';

      if (e.response != null) {
        if (e.response!.data is Map<String, dynamic>) {
          errorMessage = e.response!.data['message'] ??
              e.response!.data['error'] ??
              'Ошибка сервера';
        } else {
          errorMessage = e.response!.data.toString();
        }
      } else {
        errorMessage = 'Ошибка сети: ${e.message}';
      }

      return Left(errorMessage);
    } catch (e) {
      return Left('Неожиданная ошибка: ${e.toString()}');
    }
  }
}
