import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:photo_app/core/constants/api_url.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/data/clients/models/get_all_clients_req_params.dart';
import 'package:photo_app/data/clients/models/update_clients_req_params.dart';
import 'package:photo_app/data/clients/models/update_selected_client_req_params.dart';
import 'package:photo_app/service_locator.dart';

abstract class ClientsApiService {
  Future<Either> getAllClients(GetAllClientsReqParams params);
  Future<Either> updateClients(UpdateClientsReqParams params);
  Future<Either> updateSelectedClient(UpdateSelectedClientReqParams params);
}

class ClientsApiServiceImplementation extends ClientsApiService {
  @override
  Future<Either> getAllClients(GetAllClientsReqParams params) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.clients}/folder/${params.folderId}',
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> updateClients(UpdateClientsReqParams params) async {
    try {
      var response = await sl<DioClient>().put(
        '${ApiUrl.clients}/folder/${params.folderId}',
        data: params.clients,
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }

  @override
  Future<Either> updateSelectedClient(
      UpdateSelectedClientReqParams params) async {
    try {
      var response = await sl<DioClient>().put(
        '${ApiUrl.clients}/${params.clientId}/order-digital',
        data: {
          'orderDigital': params.orderDigital,
        },
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }
}
