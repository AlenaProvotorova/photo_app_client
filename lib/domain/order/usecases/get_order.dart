import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/order/models/get_order_req_params.dart';
import 'package:photo_app/domain/order/repositories/order.dart';
import 'package:photo_app/service_locator.dart';

class GetOrderUseCase extends Usecase<Either, GetOrderReqParams> {
  @override
  Future<Either> call({GetOrderReqParams? params}) async {
    return await sl<OrderRepository>().getOrder(params!);
  }
}
