import 'package:dartz/dartz.dart';
import 'package:photo_app/data/clients/models/get_all_clients_req_params.dart';
import 'package:photo_app/data/clients/models/update_clients_req_params.dart';
import 'package:photo_app/data/clients/sourses/clients_api_service.dart';
import 'package:photo_app/domain/clients/repositories/clients.dart';
import 'package:photo_app/service_locator.dart';

class ClientsRepositoryImplementation extends ClientsRepository {
  @override
  Future<Either> getAllClients(GetAllClientsReqParams params) async {
    return await sl<ClientsApiService>().getAllClients(params);
  }

  @override
  Future<Either> updateClients(UpdateClientsReqParams params) async {
    return await sl<ClientsApiService>().updateClients(params);
  }
}
