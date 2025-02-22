import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_event.dart';
import 'package:photo_app/entities/user/bloc/user_state.dart';
import 'package:photo_app/data/user/models/user.dart';
import 'package:photo_app/domain/user/usecases/get_user.dart';
import 'package:photo_app/service_locator.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(UserInitial()) {
    on<LoadUser>(_onLoadUser);
  }

  Future<void> _onLoadUser(
    LoadUser event,
    Emitter<UserState> emit,
  ) async {
    emit(UserLoading());
    try {
      final response = await sl<GetUserUseCase>().call();
      response.fold(
        (error) => emit(UserError(error.toString())),
        (data) {
          if (data == null) {
            throw Exception('Неверный формат данных от сервера');
          }
          final user = User.fromJson(data);
          emit(UserLoaded(user));
        },
      );
    } catch (e) {
      emit(UserError('Ошибка загрузки пользователя'));
    }
  }
}
