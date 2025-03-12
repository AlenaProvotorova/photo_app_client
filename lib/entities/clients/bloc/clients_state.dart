import 'package:equatable/equatable.dart';
import 'package:photo_app/data/clients/models/client.dart';

abstract class ClientsState extends Equatable {
  const ClientsState();

  @override
  List<Object?> get props => [];
}

class ClientsInitial extends ClientsState {}

class ClientsLoading extends ClientsState {}

class ClientsLoaded extends ClientsState {
  final List<Client> namesList;
  final Client? selectedClient;

  const ClientsLoaded({
    required this.namesList,
    this.selectedClient,
  });

  @override
  List<Object?> get props => [namesList, selectedClient];
}

class ClientSelected extends ClientsState {
  final Client? client;

  const ClientSelected({required this.client});

  @override
  List<Object?> get props => [client];
}

class ClientsError extends ClientsState {
  final String message;

  const ClientsError({required this.message});

  @override
  List<Object?> get props => [message];
}
