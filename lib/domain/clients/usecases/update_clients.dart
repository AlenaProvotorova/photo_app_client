import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/clients/models/update_clients_req_params.dart';
import 'package:photo_app/domain/clients/repositories/clients.dart';
import 'package:photo_app/service_locator.dart';

class UpdateClientsUseCase extends Usecase<Either, UpdateClientsReqParams> {
  @override
  Future<Either> call({UpdateClientsReqParams? params}) async {
    return await sl<ClientsRepository>().updateClients(params!);
  }
}
