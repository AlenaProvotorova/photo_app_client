import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/data/order/models/create_or_update_order_req_params.dart';
import 'package:photo_app/data/order/models/get_order_req_params.dart';
import 'package:photo_app/data/order/models/order.dart';
import 'package:photo_app/domain/order/usecases/get_order.dart';
import 'package:photo_app/domain/order/usecases/update_order.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';
import 'package:photo_app/entities/order/bloc/order_state.dart';
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
          final Map<String, Map<String, int>> orderForCarusel = {};
          for (final item in data) {
            try {
              final order = Order.fromJson(item);
              final fileId = order.file.id.toString();
              final sizeName = order.size.name;
              final count = order.count;
              if (!orderForCarusel.containsKey(fileId)) {
                orderForCarusel[fileId] = {};
              }
              orderForCarusel[fileId]![sizeName] = count;
            } catch (e) {}
          }
          final fullOrderForTable = <String, Map<String, dynamic>>{};
          for (final item in data) {
            try {
              final order = Order.fromJson(item);
              final fileIdentifier = '${order.file.id}_${order.client.name}';
              final fileName = order.file.originalName;
              final clientName = order.client.name;

              if (!fullOrderForTable.containsKey(fileIdentifier)) {
                fullOrderForTable[fileIdentifier] = {
                  'fileName': fileName,
                  'clientName': clientName,
                  'sizes': <String, int>{},
                };
              }
              fullOrderForTable[fileIdentifier]!['sizes'][order.size.name] =
                  order.count;
            } catch (e) {}
          }
          emit(OrderLoaded(orderForCarusel, fullOrderForTable));
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
      final response = await sl<CreateOrUpdateOrderUseCase>().call(
        params: CreateOrUpdateOrderReqParams(
          fileId: int.parse(event.fileId),
          clientId: int.parse(event.clientId),
          folderId: int.parse(event.folderId),
          sizeId: event.sizeId,
          count: int.parse(event.count),
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
        },
      );
    } catch (e) {
      emit(OrderError('Ошибка изменения списка клиентов'));
    }
  }
}
