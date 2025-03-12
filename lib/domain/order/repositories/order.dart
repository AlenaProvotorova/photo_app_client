import 'package:dartz/dartz.dart';
import 'package:photo_app/data/order/models/create_or_update_order_req_params.dart';
import 'package:photo_app/data/order/models/get_order_req_params.dart';

abstract class OrderRepository {
  Future<Either> createOrUpdateOrder(CreateOrUpdateOrderReqParams params);
  Future<Either> getOrder(GetOrderReqParams params);
}
