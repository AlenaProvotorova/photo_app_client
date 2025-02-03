import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:photo_app/repositories/user/user_repository.dart';

part 'user_block_event.dart';
part 'user_block_state.dart';

class UserBlockBloc extends Bloc<UserBlockEvent, UserBlockState> {
  UserBlockBloc() : super(UserBlockInitial()) {
    on<FetchUser>((event, emit) async {
      emit(UserBlockLoading());
      try {
        final UserRepository userRepository = UserRepository();
        final user = await userRepository.getUserProfile();
        emit(UserBlockSuccess(user));
      } catch (e) {
        emit(UserBlockFailure());
      }
    });
  }
}
