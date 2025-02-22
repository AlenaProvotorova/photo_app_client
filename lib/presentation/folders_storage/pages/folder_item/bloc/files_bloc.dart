import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/data/files/models/file.dart';
import 'package:photo_app/data/files/models/get_all_files_req_params.dart';
import 'package:photo_app/domain/files/usecases/get_all_files.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_event.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_state.dart';
import 'package:photo_app/service_locator.dart';

class FilesBloc extends Bloc<FilesEvent, FilesState> {
  FilesBloc() : super(FilesLoading()) {
    on<LoadFiles>(_onLoadFiles);
  }

  Future<void> _onLoadFiles(
    LoadFiles event,
    Emitter<FilesState> emit,
  ) async {
    emit(FilesLoading());
    try {
      final response = await sl<GetAllFilesUseCase>().call(
        params: GetAllFilesReqParams(
          folderId: int.parse(event.folderId),
        ),
      );
      response.fold(
        (error) => emit(FilesError(error.toString())),
        (data) {
          if (data == null || data is! List) {
            throw Exception('Неверный формат данных от сервера');
          }
          final files = data.map((json) => File.fromJson(json)).toList();
          emit(FilesLoaded(files: files));
        },
      );
    } catch (e) {
      emit(FilesError('Ошибка загрузки файлов'));
    }
  }
}
