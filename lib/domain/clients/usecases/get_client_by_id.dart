import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/clients/models/get_client_by_id_req_params.dart';
import 'package:photo_app/domain/clients/repositories/clients.dart';
import 'package:photo_app/service_locator.dart';

class GetClientByIdUseCase extends Usecase<Either, GetClientByIdReqParams> {
  @override
  Future<Either> call({GetClientByIdReqParams? params}) async {
    return await sl<ClientsRepository>().getClientById(params!);
  }
}
