import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/clients/models/get_all_clients_req_params.dart';
import 'package:photo_app/domain/clients/repositories/clients.dart';
import 'package:photo_app/service_locator.dart';

class GetAllClientsUseCase extends Usecase<Either, GetAllClientsReqParams> {
  @override
  Future<Either> call({GetAllClientsReqParams? params}) async {
    return await sl<ClientsRepository>().getAllClients(params!);
  }
}
