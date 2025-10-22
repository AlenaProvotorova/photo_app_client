import 'package:dartz/dartz.dart';
import 'package:photo_app/domain/clients/repositories/clients.dart';
import 'package:photo_app/service_locator.dart';

class DeleteClientByNameUseCase {
  Future<Either> call({
    required int folderId,
    required String clientName,
  }) async {
    return await sl<ClientsRepository>()
        .deleteClientByName(folderId, clientName);
  }
}
