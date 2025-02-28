import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/domain/sizes/usecases/get_sizes.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_event.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_state.dart';
import 'package:photo_app/service_locator.dart';

class SizesBloc extends Bloc<SizesEvent, SizesState> {
  SizesBloc() : super(SizesInitial()) {
    on<LoadSizes>(_onLoadSizes);
  }

  Future<void> _onLoadSizes(
    LoadSizes event,
    Emitter<SizesState> emit,
  ) async {
    emit(SizesLoading());
    try {
      final response = await sl<GetSizesUseCase>().call();
      response.fold(
        (error) => emit(SizesError(error.toString())),
        (data) {
          if (data == null) {
            throw Exception('Неверный формат данных от сервера');
          }
          final sizes = data;
          emit(SizesLoaded(sizes));
        },
      );
    } catch (e) {
      emit(SizesError('Ошибка загрузки размеров'));
    }
  }
}
