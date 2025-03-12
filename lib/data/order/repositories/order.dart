import 'package:dartz/dartz.dart';
import 'package:photo_app/data/order/models/create_or_update_order_req_params.dart';
import 'package:photo_app/data/order/models/get_order_req_params.dart';
import 'package:photo_app/data/order/sourses/clients_api_service.dart';
import 'package:photo_app/domain/order/repositories/order.dart';
import 'package:photo_app/service_locator.dart';

class OrderRepositoryImplementation extends OrderRepository {
  @override
  Future<Either> createOrUpdateOrder(
      CreateOrUpdateOrderReqParams params) async {
    return await sl<OrderApiService>().createOrUpdateOrder(params);
  }

  @override
  Future<Either> getOrder(GetOrderReqParams params) async {
    return await sl<OrderApiService>().getOrder(params);
  }
}
