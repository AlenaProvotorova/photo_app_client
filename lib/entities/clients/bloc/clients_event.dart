abstract class ClientsEvent {}

class LoadClients extends ClientsEvent {
  final String folderId;

  LoadClients({required this.folderId});
}

class UpdateClients extends ClientsEvent {
  final String folderId;

  UpdateClients({required this.folderId});
}

class AddNewClient extends ClientsEvent {
  final String name;

  AddNewClient({required this.name});
}

class DeleteClient extends ClientsEvent {
  final String name;

  DeleteClient({required this.name});
}

class SelectClient extends ClientsEvent {
  final String name;

  SelectClient({required this.name});
}
