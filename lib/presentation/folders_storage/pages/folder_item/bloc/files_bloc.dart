import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/data/files/models/file.dart';
import 'package:photo_app/data/files/models/get_all_files_req_params.dart';
import 'package:photo_app/data/files/models/upload_file_req_params.dart';
import 'package:photo_app/domain/files/usecases/get_all_files.dart';
import 'package:photo_app/domain/files/usecases/upload_file.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_event.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_state.dart';
import 'package:photo_app/service_locator.dart';

class FilesBloc extends Bloc<FilesEvent, FilesState> {
  FilesBloc() : super(FilesLoading()) {
    on<LoadFiles>(_onLoadFiles);
    on<UploadFiles>(_onUploadFiles);
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

  Future<void> _onUploadFiles(
    UploadFiles event,
    Emitter<FilesState> emit,
  ) async {
    // Получаем текущие файлы для отображения
    final currentState = state;
    List<File> existingFiles = [];
    if (currentState is FilesLoaded) {
      existingFiles = currentState.files;
    }

    // Эмитим начальное состояние загрузки
    emit(FilesUploading(
      existingFiles: existingFiles,
      totalFiles: event.images.length,
      uploadedFiles: 0,
      failedFiles: 0,
    ));

    int uploadedCount = 0;
    int failedCount = 0;

    for (var image in event.images) {
      final result = await sl<UploadFileUseCase>().call(
        params: UploadFileReqParams(
          folderId: int.parse(event.folderId),
          formData: FormData.fromMap({
            'file': kIsWeb
                ? MultipartFile.fromBytes(
                    image.bytes!,
                    filename: image.path,
                  )
                : await MultipartFile.fromFile(image.path!),
          }),
        ),
      );

      result.fold(
        (error) {
          failedCount++;
          DisplayMessage.showMessage(event.context, error);
          // Обновляем состояние с прогрессом
          emit(FilesUploading(
            existingFiles: existingFiles,
            totalFiles: event.images.length,
            uploadedFiles: uploadedCount,
            failedFiles: failedCount,
          ));
        },
        (success) {
          uploadedCount++;
          // Обновляем состояние с прогрессом
          emit(FilesUploading(
            existingFiles: existingFiles,
            totalFiles: event.images.length,
            uploadedFiles: uploadedCount,
            failedFiles: failedCount,
          ));
        },
      );
    }

    // После загрузки всех файлов перезагружаем список
    add(LoadFiles(folderId: event.folderId));
  }
}
