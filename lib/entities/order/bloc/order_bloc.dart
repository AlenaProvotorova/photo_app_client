import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/data/order/models/create_or_update_order_req_params.dart';
import 'package:photo_app/data/order/models/get_order_req_params.dart';
import 'package:photo_app/domain/order/usecases/get_order.dart';
import 'package:photo_app/domain/order/usecases/update_order.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';
import 'package:photo_app/entities/order/bloc/order_state.dart';
import 'package:photo_app/entities/order/bloc/utils.dart';
import 'package:photo_app/service_locator.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitial()) {
    on<LoadOrder>(_onLoadOrder);
    on<UpdateOrder>((event, emit) {
      return _onUpdateOrder(event, emit);
    });
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
          clientId: event.clientId,
        ),
      );

      response.fold(
        (error) => emit(OrderError(error.toString())),
        (data) {
          if (data == null || data is! List) {
            throw Exception('Неверный формат данных от сервера');
          }
          final orderForCarusel = OrderUtils.getFullOrderForCarusel(data);
          print('orderForCaruseldata: $data');
          print('orderForCarusel: $orderForCarusel');
          final fullOrderForTable = OrderUtils.getFullOrderForTable(data);
          final fullOrderForSorting = OrderUtils.getFullOrderForSorting(data);

          emit(OrderLoaded(
            orderForCarusel,
            fullOrderForTable,
            fullOrderForSorting,
          ));
        },
      );
    } catch (e) {
      emit(OrderError('Ошибка загрузки заказа'));
    }
  }

  Future<void> _onUpdateOrder(
    UpdateOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(OrderLoading());
    try {
      final countValue = event.count == 'true' ? 1 : 0;
      final response = await sl<CreateOrUpdateOrderUseCase>().call(
        params: CreateOrUpdateOrderReqParams(
          fileId: int.parse(event.fileId),
          clientId: int.parse(event.clientId),
          folderId: int.parse(event.folderId),
          formatName: event.formatName,
          count: countValue,
        ),
      );

      response.fold(
        (error) {
          emit(OrderError(error.toString()));
        },
        (data) {
          if (data == null) {
            throw Exception('Неверный формат данных от сервера');
          }
          add(LoadOrder(
            folderId: event.folderId,
            clientId: int.parse(event.clientId),
          ));
        },
      );
    } catch (e) {
      emit(OrderError('Ошибка изменения списка клиентов'));
    }
  }
}
