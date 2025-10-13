import 'package:photo_app/data/users/models/user_list_item.dart';

abstract class UsersState {}

class UsersInitial extends UsersState {}

class UsersLoading extends UsersState {}

class UsersLoaded extends UsersState {
  final List<UserListItem> users;

  UsersLoaded({
    required this.users,
  });
}

class UsersError extends UsersState {
  final String message;
  UsersError(this.message);
}
