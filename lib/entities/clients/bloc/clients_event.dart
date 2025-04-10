import 'package:photo_app/data/clients/models/client.dart';

abstract class ClientsEvent {}

class LoadClients extends ClientsEvent {
  final String folderId;

  LoadClients({required this.folderId});
}

class LoadClientById extends ClientsEvent {
  final String clientId;

  LoadClientById({required this.clientId});
}

class UpdateClients extends ClientsEvent {
  final String folderId;
  final List<String> clients;

  UpdateClients({required this.folderId, required this.clients});
}

class SelectClient extends ClientsEvent {
  final Client client;

  SelectClient({required this.client});
}

class UpdateSelectedClient extends ClientsEvent {
  final String clientId;
  final bool orderDigital;

  UpdateSelectedClient({
    required this.clientId,
    required this.orderDigital,
  });
}

class ResetSelectedClient extends ClientsEvent {}
