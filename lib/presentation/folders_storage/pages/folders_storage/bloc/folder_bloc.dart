import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/data/folders/models/folder.dart';
import 'package:photo_app/domain/folders/usecases/get_all_folders.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/bloc/folder_event.dart';
import 'package:photo_app/presentation/folders_storage/pages/folders_storage/bloc/folder_state.dart';
import 'package:photo_app/service_locator.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  FolderBloc() : super(FolderInitial()) {
    on<LoadFolders>(_onLoadFolders);
  }

  Future<void> _onLoadFolders(
    LoadFolders event,
    Emitter<FolderState> emit,
  ) async {
    emit(FolderLoading());
    try {
      final response = await sl<GetAllFoldersUseCase>().call();
      response.fold(
        (error) => emit(FolderError(error.toString())),
        (data) {
          if (data == null || data is! List) {
            throw Exception('Неверный формат данных от сервера');
          }
          final folders = data.map((json) => Folder.fromJson(json)).toList();
          emit(FolderLoaded(folders));
        },
      );
    } catch (e) {
      emit(FolderError('Ошибка загрузки папок'));
    }
  }
}
