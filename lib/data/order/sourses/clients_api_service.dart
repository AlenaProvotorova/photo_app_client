import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:photo_app/core/constants/api_url.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/data/order/models/create_or_update_order_req_params.dart';
import 'package:photo_app/data/order/models/get_order_req_params.dart';
import 'package:photo_app/service_locator.dart';

abstract class OrderApiService {
  Future<Either> createOrUpdateOrder(CreateOrUpdateOrderReqParams params);
  Future<Either> getOrder(GetOrderReqParams params);
}

class OrderApiServiceImplementation extends OrderApiService {
  @override
  Future<Either> createOrUpdateOrder(
      CreateOrUpdateOrderReqParams params) async {
    try {
      var response = await sl<DioClient>().put(
        '$ApiUrl.orders',
        data: params.toMap(),
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> getOrder(GetOrderReqParams params) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.orders}/folder${params.folderId}',
        queryParameters: {
          'clientId': params.clientId,
        },
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }
}
