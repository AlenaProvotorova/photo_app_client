import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/data/order/models/create_or_update_order_req_params.dart';
import 'package:photo_app/data/order/models/get_order_req_params.dart';
import 'package:photo_app/domain/order/usecases/get_order.dart';
import 'package:photo_app/domain/order/usecases/update_order.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';
import 'package:photo_app/entities/order/bloc/order_state.dart';
import 'package:photo_app/service_locator.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<LoadOrder>(_onLoadOrder);
    on<UpdateOrder>(_onUpdateOrder);
  }

  Future<void> _onLoadOrder(
    LoadOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final response = await sl<GetOrderUseCase>().call(
        params: GetOrderReqParams(
          folderId: int.parse(event.folderId),
          clientId: int.parse(event.clientId),
        ),
      );

      response.fold(
        (error) => emit(OrderError(error.toString())),
        (data) {
          if (data == null || data is! List) {
            throw Exception('Неверный формат данных от сервера');
          }

          // final order = Order.fromJson(data[0]);
          // emit(OrderLoaded(order));
        },
      );
    } catch (e) {
      emit(OrderError('Ошибка загрузки клиентов'));
    }
  }

  Future<void> _onUpdateOrder(
    UpdateOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final response = await sl<CreateOrUpdateOrderUseCase>().call(
        params: CreateOrUpdateOrderReqParams(
          fileId: int.parse(event.fileId),
          clientId: int.parse(event.clientId),
          folderId: int.parse(event.folderId),
          sizeId: int.parse(event.sizeId),
          count: int.parse(event.count),
        ),
      );

      response.fold(
        (error) => emit(OrderError(error.toString())),
        (data) {
          if (data == null) {
            throw Exception('Неверный формат данных от сервера');
          }
          // final order = Order.fromJson(data);
          // emit(OrderLoaded(order));
        },
      );
    } catch (e) {
      emit(OrderError('Ошибка изменения списка клиентов'));
    }
  }
}
