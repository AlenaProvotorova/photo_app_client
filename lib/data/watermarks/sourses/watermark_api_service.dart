import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:photo_app/core/constants/api_url.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/data/watermarks/models/get_watermark_req_params.dart';
import 'package:photo_app/data/watermarks/models/remove_watermark_req_params.dart';
import 'package:photo_app/data/watermarks/models/upload_watermark_req_params.dart';
import 'package:photo_app/service_locator.dart';

abstract class WatermarkApiService {
  Future<Either> uploadWatermark(UploadWatermarkReqParams params);
  Future<Either> getWatermark(GetAllWatermarksReqParams params);
  Future<Either> removeWatermark(RemoveWatermarkReqParams params);
}

class WatermarkApiServiceImplementation extends WatermarkApiService {
  @override
  Future<Either> uploadWatermark(UploadWatermarkReqParams params) async {
    try {
      // Добавляем timestamp для предотвращения кэширования
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      var response = await sl<DioClient>().post(
        '${ApiUrl.watermarks}?userId=${params.userId}&_t=$timestamp',
        data: params.formData,
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
  Future<Either> getWatermark(GetAllWatermarksReqParams params) async {
    try {
      // Добавляем timestamp для предотвращения кэширования
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      var response = await sl<DioClient>().get(
        ApiUrl.watermarks,
        queryParameters: {
          'userId': params.userId,
          '_t': timestamp,
        },
      );
      print('=== ОТВЕТ СЕРВЕРА ДЛЯ ВОДЯНОГО ЗНАКА ===');
      print('Статус код: ${response.statusCode}');
      print('Тип данных: ${response.data.runtimeType}');
      print('Содержимое: ${response.data}');
      print(
          'Длина данных: ${response.data is List ? response.data.length : 'не список'}');
      print('==========================================');
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
  Future<Either<String, dynamic>> removeWatermark(
      RemoveWatermarkReqParams params) async {
    try {
      // Добавляем timestamp для предотвращения кэширования
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      var response = await sl<DioClient>().delete(
        ApiUrl.watermarks,
        queryParameters: {
          'userId': params.userId,
          '_t': timestamp,
        },
      );
      return Right(response);
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
