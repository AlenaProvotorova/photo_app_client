import 'package:equatable/equatable.dart';

abstract class ClientsState extends Equatable {
  const ClientsState();

  @override
  List<Object?> get props => [];
}

class ClientsInitial extends ClientsState {}

class ClientsLoading extends ClientsState {}

class ClientsLoaded extends ClientsState {
  final List<String> namesList;
  final String? selectedClient;

  const ClientsLoaded({
    required this.namesList,
    this.selectedClient,
  });

  @override
  List<Object?> get props => [namesList, selectedClient];
}

class ClientSelected extends ClientsState {
  final String? name;

  const ClientSelected({required this.name});

  @override
  List<Object?> get props => [name];
}

class ClientsError extends ClientsState {
  final String message;

  const ClientsError({required this.message});

  @override
  List<Object?> get props => [message];
}
