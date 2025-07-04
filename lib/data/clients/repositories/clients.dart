import 'package:dartz/dartz.dart';
import 'package:photo_app/data/clients/models/get_all_clients_req_params.dart';
import 'package:photo_app/data/clients/models/get_client_by_id_req_params.dart';
import 'package:photo_app/data/clients/models/update_clients_req_params.dart';
import 'package:photo_app/data/clients/models/update_selected_client_req_params.dart';
import 'package:photo_app/data/clients/sourses/clients_api_service.dart';
import 'package:photo_app/domain/clients/repositories/clients.dart';
import 'package:photo_app/service_locator.dart';

class ClientsRepositoryImplementation extends ClientsRepository {
  @override
  Future<Either> getAllClients(GetAllClientsReqParams params) async {
    return await sl<ClientsApiService>().getAllClients(params);
  }

  @override
  Future<Either> getClientById(GetClientByIdReqParams params) async {
    return await sl<ClientsApiService>().getClientById(params);
  }

  @override
  Future<Either> updateClients(UpdateClientsReqParams params) async {
    return await sl<ClientsApiService>().updateClients(params);
  }

  @override
  Future<Either> updateOrderDigital(
      UpdateSelectedClientReqParams params) async {
    return await sl<ClientsApiService>().updateOrderDigital(params);
  }

  @override
  Future<Either> updateOrderAlbum(UpdateSelectedClientReqParams params) async {
    return await sl<ClientsApiService>().updateOrderAlbum(params);
  }
}
