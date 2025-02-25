abstract class ClientsState {}

class ClientsInitial extends ClientsState {}

class ClientsLoading extends ClientsState {}

class ClientsLoaded extends ClientsState {
  final List<String> namesList;

  ClientsLoaded({required this.namesList});
}

class ClientsError extends ClientsState {
  final String message;

  ClientsError({required this.message});
}
