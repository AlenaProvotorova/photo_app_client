import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/order/models/create_or_update_order_req_params.dart';
import 'package:photo_app/domain/order/repositories/order.dart';
import 'package:photo_app/service_locator.dart';

class CreateOrUpdateOrderUseCase
    extends Usecase<Either, CreateOrUpdateOrderReqParams> {
  @override
  Future<Either> call({CreateOrUpdateOrderReqParams? params}) async {
    return await sl<OrderRepository>().createOrUpdateOrder(params!);
  }
}
