import 'package:dartz/dartz.dart';
import 'package:photo_app/core/usecase/usecase.dart';
import 'package:photo_app/data/clients/models/update_selected_client_req_params.dart';
import 'package:photo_app/domain/clients/repositories/clients.dart';
import 'package:photo_app/service_locator.dart';

class UpdateOrderDigitalUseCase
    extends Usecase<Either, UpdateSelectedClientReqParams> {
  @override
  Future<Either> call({UpdateSelectedClientReqParams? params}) async {
    return await sl<ClientsRepository>().updateOrderDigital(params!);
  }
}
