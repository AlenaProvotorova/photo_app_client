abstract class UsersEvent {}

class LoadUsers extends UsersEvent {}

class UpdateUserIsAdmin extends UsersEvent {
  final int id;
  final bool isAdmin;
  UpdateUserIsAdmin({required this.id, required this.isAdmin});
}
