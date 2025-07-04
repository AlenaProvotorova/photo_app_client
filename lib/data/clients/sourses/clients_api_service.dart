import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:photo_app/core/constants/api_url.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/data/clients/models/get_all_clients_req_params.dart';
import 'package:photo_app/data/clients/models/get_client_by_id_req_params.dart';
import 'package:photo_app/data/clients/models/update_clients_req_params.dart';
import 'package:photo_app/data/clients/models/update_selected_client_req_params.dart';
import 'package:photo_app/service_locator.dart';

abstract class ClientsApiService {
  Future<Either> getAllClients(GetAllClientsReqParams params);
  Future<Either> getClientById(GetClientByIdReqParams params);
  Future<Either> updateClients(UpdateClientsReqParams params);
  Future<Either> updateOrderDigital(UpdateSelectedClientReqParams params);
  Future<Either> updateOrderAlbum(UpdateSelectedClientReqParams params);
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
  Future<Either> getClientById(GetClientByIdReqParams params) async {
    try {
      var response = await sl<DioClient>().get(
        '${ApiUrl.clients}/${params.clientId}',
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
  Future<Either> updateOrderDigital(
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

  @override
  Future<Either> updateOrderAlbum(UpdateSelectedClientReqParams params) async {
    try {
      var response = await sl<DioClient>().put(
        '${ApiUrl.clients}/${params.clientId}/order-album',
        data: {
          'orderAlbum': params.orderAlbum,
        },
      );
      return Right(response.data);
    } on DioException catch (e) {
      return Left(e.response!.data['message']);
    }
  }
}
