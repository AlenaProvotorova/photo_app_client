import 'package:dartz/dartz.dart';
import 'package:photo_app/data/clients/models/get_all_clients_req_params.dart';
import 'package:photo_app/data/clients/models/update_clients_req_params.dart';

abstract class ClientsRepository {
  Future<Either> getAllClients(GetAllClientsReqParams params);
  Future<Either> updateClients(UpdateClientsReqParams params);
}
