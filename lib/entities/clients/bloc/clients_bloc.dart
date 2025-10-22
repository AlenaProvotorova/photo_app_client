import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/data/clients/models/client.dart';
import 'package:photo_app/data/clients/models/get_all_clients_req_params.dart';
import 'package:photo_app/data/clients/models/get_client_by_id_req_params.dart';
import 'package:photo_app/data/clients/models/update_clients_req_params.dart';
import 'package:photo_app/data/clients/models/update_selected_client_req_params.dart';
import 'package:photo_app/domain/clients/usecases/get_all_clients.dart';
import 'package:photo_app/domain/clients/usecases/get_client_by_id.dart';
import 'package:photo_app/domain/clients/usecases/update_clients.dart';
import 'package:photo_app/domain/clients/usecases/delete_client_by_name.dart';
import 'package:photo_app/domain/clients/usecases/update_order_album.dart';
import 'package:photo_app/domain/clients/usecases/update_order_digital.dart';
import 'package:photo_app/entities/clients/bloc/clients_event.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/service_locator.dart';

class ClientsBloc extends Bloc<ClientsEvent, ClientsState> {
  List<Client> _namesList = [];
  Client? _selectedClient;

  ClientsBloc() : super(ClientsInitial()) {
    on<LoadClients>(_onLoadClients);
    on<LoadClientById>(_onLoadClientById);
    on<UpdateClients>(_onUpdateClients);
    on<DeleteClientByName>(_onDeleteClientByName);
    on<SelectClient>(_onSelectClient);
    on<UpdateOrderDigital>(_onUpdateOrderDigital);
    on<UpdateOrderAlbum>(_onUpdateOrderAlbum);
    on<ResetSelectedClient>(_onResetSelectedClient);
  }

  Future<void> _onLoadClients(
    LoadClients event,
    Emitter<ClientsState> emit,
  ) async {
    emit(ClientsLoading());
    try {
      final response = await sl<GetAllClientsUseCase>().call(
        params: GetAllClientsReqParams(
          folderId: int.parse(event.folderId),
        ),
      );

      response.fold(
        (error) => emit(ClientsError(message: error.toString())),
        (data) {
          if (data == null || data is! List) {
            throw Exception('Неверный формат данных от сервера');
          }

          final clients = data.map((json) => Client.fromJson(json)).toList();
          _namesList = clients;
          emit(ClientsLoaded(namesList: _namesList));
        },
      );
    } catch (e) {
      emit(const ClientsError(message: 'Ошибка загрузки клиентов'));
    }
  }

  Future<void> _onLoadClientById(
    LoadClientById event,
    Emitter<ClientsState> emit,
  ) async {
    try {
      final response = await sl<GetClientByIdUseCase>().call(
        params: GetClientByIdReqParams(
          clientId: int.parse(event.clientId),
        ),
      );

      response.fold(
        (error) => emit(ClientsError(message: error.toString())),
        (data) {
          if (data == null) {
            throw Exception('Неверный формат данных от сервера');
          }

          final client = Client.fromJson(data);
          _selectedClient = client;
          emit(ClientsLoaded(
            namesList: _namesList,
            selectedClient: _selectedClient,
          ));
        },
      );
    } catch (e) {
      emit(const ClientsError(message: 'Ошибка загрузки клиентов'));
    }
  }

  Future<void> _onUpdateClients(
    UpdateClients event,
    Emitter<ClientsState> emit,
  ) async {
    emit(ClientsLoading());
    try {
      final response = await sl<UpdateClientsUseCase>().call(
        params: UpdateClientsReqParams(
          folderId: int.parse(event.folderId),
          clients: event.clients.map((name) => {'name': name}).toList(),
        ),
      );

      response.fold(
        (error) => emit(ClientsError(message: error.toString())),
        (data) {
          if (data == null || data is! List) {
            throw Exception('Неверный формат данных от сервера');
          }
          // После успешного обновления перезагружаем список клиентов
          add(LoadClients(folderId: event.folderId));
        },
      );
    } catch (e) {
      emit(const ClientsError(message: 'Ошибка изменения списка клиентов'));
    }
  }

  Future<void> _onDeleteClientByName(
    DeleteClientByName event,
    Emitter<ClientsState> emit,
  ) async {
    print(
        '_onDeleteClientByName вызван: folderId=${event.folderId}, clientName=${event.clientName}');
    emit(ClientsLoading());
    try {
      final response = await sl<DeleteClientByNameUseCase>().call(
        folderId: int.parse(event.folderId),
        clientName: event.clientName,
      );

      response.fold(
        (error) {
          print('Ошибка удаления клиента: $error');
          emit(ClientsError(
              message: error is String ? error : error.toString()));
        },
        (data) {
          print('Клиент успешно удален: $data');
          // После успешного удаления перезагружаем список клиентов
          add(LoadClients(folderId: event.folderId));
        },
      );
    } catch (e) {
      print('Исключение при удалении клиента: $e');
      emit(const ClientsError(message: 'Ошибка удаления клиента'));
    }
  }

  Future<void> _onUpdateOrderDigital(
    UpdateOrderDigital event,
    Emitter<ClientsState> emit,
  ) async {
    try {
      final response = await sl<UpdateOrderDigitalUseCase>().call(
        params: UpdateSelectedClientReqParams(
          clientId: int.parse(event.clientId),
          orderDigital: event.orderDigital,
        ),
      );

      response.fold(
        (error) => emit(ClientsError(message: error.toString())),
        (data) {},
      );
    } catch (e) {
      emit(const ClientsError(message: 'Ошибка выбора цифрового заказа'));
    }
  }

  Future<void> _onUpdateOrderAlbum(
    UpdateOrderAlbum event,
    Emitter<ClientsState> emit,
  ) async {
    print(
        '_onUpdateOrderAlbum вызван с clientId: ${event.clientId}, orderAlbum: ${event.orderAlbum}');
    try {
      final response = await sl<UpdateOrderAlbumUseCase>().call(
        params: UpdateSelectedClientReqParams(
          clientId: int.parse(event.clientId),
          orderAlbum: event.orderAlbum,
        ),
      );

      response.fold(
        (error) {
          print('Ошибка в _onUpdateOrderAlbum: $error');
          emit(ClientsError(message: error.toString()));
        },
        (data) {
          print('Успешное обновление orderAlbum: $data');
          // После успешного обновления перезагружаем клиента с актуальными данными
          add(LoadClientById(clientId: event.clientId));
        },
      );
    } catch (e) {
      print('Исключение в _onUpdateOrderAlbum: $e');
      emit(ClientsError(message: 'Ошибка выбора альбомного заказа: $e'));
    }
  }

  void _onSelectClient(
    SelectClient event,
    Emitter<ClientsState> emit,
  ) {
    _selectedClient = event.client;
    emit(ClientsLoaded(
      namesList: _namesList,
      selectedClient: _selectedClient,
    ));
  }

  void _onResetSelectedClient(
    ResetSelectedClient event,
    Emitter<ClientsState> emit,
  ) {
    if (state is ClientsLoaded) {
      final currentState = state as ClientsLoaded;
      emit(ClientsLoaded(
        namesList: currentState.namesList,
        selectedClient: null,
      ));
    }
  }
}
