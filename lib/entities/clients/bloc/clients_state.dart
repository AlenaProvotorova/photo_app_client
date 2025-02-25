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

  const ClientsLoaded({required this.namesList});

  @override
  List<Object?> get props => [namesList];
}

class ClientsError extends ClientsState {
  final String message;

  const ClientsError({required this.message});

  @override
  List<Object?> get props => [message];
}
