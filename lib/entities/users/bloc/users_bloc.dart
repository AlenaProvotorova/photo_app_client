import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/data/users/models/user_list_item.dart';
import 'package:photo_app/domain/users/usecases/get_all_users.dart';
import 'package:photo_app/domain/users/usecases/update_user_is_admin.dart';
import 'package:photo_app/entities/users/bloc/users_event.dart';
import 'package:photo_app/entities/users/bloc/users_state.dart';
import 'package:photo_app/service_locator.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersInitial()) {
    on<LoadUsers>(_onLoadUsers);
    on<UpdateUserIsAdmin>(_onUpdateUserIsAdmin);
  }

  Future<void> _onLoadUsers(
    LoadUsers event,
    Emitter<UsersState> emit,
  ) async {
    emit(UsersLoading());
    try {
      final response = await sl<GetAllUsersUseCase>().call();

      response.fold(
        (error) {
          emit(UsersError(error.toString()));
        },
        (data) {
          if (data == null) {
            emit(UsersLoaded(users: []));
            return;
          }

          try {
            final users = <UserListItem>[];
            for (int i = 0; i < data.length; i++) {
              try {
                final user = UserListItem.fromJson(data[i]);
                users.add(user);
              } catch (itemError) {
                print('❌ Проблемный элемент: ${data[i]}');
              }
            }

            emit(UsersLoaded(users: users));
          } catch (parseError) {
            emit(UsersError(
                'Ошибка обработки данных пользователей: ${parseError.toString()}'));
          }
        },
      );
    } catch (e) {
      emit(UsersError('Ошибка загрузки пользователей: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateUserIsAdmin(
    UpdateUserIsAdmin event,
    Emitter<UsersState> emit,
  ) async {
    try {
      final currentState = state;
      if (currentState is UsersLoaded) {
        final updated = currentState.users.map((u) {
          if (u.id == event.id) {
            return UserListItem(
              id: u.id,
              email: u.email,
              name: u.name,
              isAdmin: event.isAdmin,
              isSuperUser: u.isSuperUser,
              createdAt: u.createdAt,
              updatedAt: u.updatedAt,
            );
          }
          return u;
        }).toList();
        emit(UsersLoaded(users: updated));
      }

      final res = await sl<UpdateUserIsAdminUseCase>().call(
        params: UpdateUserIsAdminParams(id: event.id, isAdmin: event.isAdmin),
      );
      res.fold(
        (error) {
          if (currentState is UsersLoaded) {
            emit(currentState);
          }
          add(LoadUsers());
        },
        (_) {
          add(LoadUsers());
        },
      );
    } catch (_) {
      add(LoadUsers());
    }
  }
}
