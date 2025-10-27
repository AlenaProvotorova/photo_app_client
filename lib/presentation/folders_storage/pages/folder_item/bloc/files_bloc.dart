import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/data/files/models/file.dart';
import 'package:photo_app/data/files/models/get_all_files_req_params.dart';
import 'package:photo_app/data/files/models/delete_all_files_req_params.dart';
import 'package:photo_app/data/files/models/delete_all_files_response.dart';
import 'package:photo_app/data/files/models/upload_file_req_params.dart';
import 'package:photo_app/data/files/models/upload_files_batch_req_params.dart';
import 'package:photo_app/data/files/services/file_upload_service.dart';
import 'package:photo_app/domain/files/usecases/delete_all_files.dart';
import 'package:photo_app/domain/files/usecases/get_all_files.dart';
import 'package:photo_app/domain/files/usecases/upload_file.dart';
import 'package:photo_app/domain/files/usecases/upload_files_batch.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_event.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_state.dart';
import 'package:photo_app/service_locator.dart';

class FilesBloc extends Bloc<FilesEvent, FilesState> {
  FilesBloc() : super(FilesLoading()) {
    on<LoadFiles>(_onLoadFiles);
    on<UploadFiles>(_onUploadFiles);
    on<UploadFilesBatch>(_onUploadFilesBatch);
    on<DeleteAllFiles>(_onDeleteAllFiles);
    on<RemoveFileLocally>(_onRemoveFileLocally);
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

  Future<void> _onUploadFilesBatch(
    UploadFilesBatch event,
    Emitter<FilesState> emit,
  ) async {
    // Валидация файлов
    final validationErrors = FileUploadService.validateFiles(event.images);
    if (validationErrors.isNotEmpty) {
      emit(FilesError(validationErrors.join(', ')));
      return;
    }

    // Получаем текущие файлы для отображения
    final currentState = state;
    List<File> existingFiles = [];
    if (currentState is FilesLoaded) {
      existingFiles = currentState.files;
    }

    // Сжимаем изображения
    final compressedImages =
        await FileUploadService.compressImages(event.images);

    // Разделяем на пакеты
    final batches = FileUploadService.splitIntoBatches(compressedImages);

    // Эмитим начальное состояние массовой загрузки
    emit(FilesBatchUploading(
      existingFiles: existingFiles,
      totalFiles: event.images.length,
      currentBatch: 0,
      totalBatches: batches.length,
      uploadedFiles: 0,
      failedFiles: 0,
    ));

    int totalUploadedCount = 0;
    int totalFailedCount = 0;

    for (int i = 0; i < batches.length; i++) {
      final batch = batches[i];

      // Обновляем состояние с текущим пакетом
      emit(FilesBatchUploading(
        existingFiles: existingFiles,
        totalFiles: event.images.length,
        currentBatch: i + 1,
        totalBatches: batches.length,
        uploadedFiles: totalUploadedCount,
        failedFiles: totalFailedCount,
      ));

      try {
        // Создаем FormData для пакета
        final formData = await FileUploadService.createBatchFormData(batch);

        // Загружаем пакет
        final result = await sl<UploadFilesBatchUseCase>().call(
          params: UploadFilesBatchReqParams(
            folderId: int.parse(event.folderId),
            formData: formData,
          ),
        );

        result.fold(
          (error) {
            totalFailedCount += batch.length;
            DisplayMessage.showMessage(event.context, error);
          },
          (success) {
            totalUploadedCount += batch.length;
          },
        );
      } catch (e) {
        totalFailedCount += batch.length;
        DisplayMessage.showMessage(
            event.context, 'Ошибка загрузки пакета ${i + 1}: $e');
      }
    }

    // После загрузки всех файлов перезагружаем список
    add(LoadFiles(folderId: event.folderId));
  }

  Future<void> _onDeleteAllFiles(
    DeleteAllFiles event,
    Emitter<FilesState> emit,
  ) async {
    // Показываем состояние удаления
    emit(FilesDeleting());

    try {
      final result = await sl<DeleteAllFilesUseCase>().call(
        params: DeleteAllFilesReqParams(
          folderId: int.parse(event.folderId),
        ),
      );

      result.fold(
        (error) {
          print('Delete all files error: $error');
          emit(FilesError('Ошибка удаления файлов: $error'));
          DisplayMessage.showMessage(event.context, error);
        },
        (success) {
          print('Delete all files success: $success');
          print('Success type: ${success.runtimeType}');

          // Проверяем, что success не null и не вызывает ошибок
          try {
            // Извлекаем информацию об удалении из ответа сервера
            String message = 'Все файлы успешно удалены';
            if (success is Map<String, dynamic>) {
              try {
                final response = DeleteAllFilesResponse.fromJson(success);
                message =
                    'Удалено ${response.deletedCount} из ${response.totalFiles} файлов';
                print('Delete response: $response');
              } catch (e) {
                print('Error parsing delete response: $e');
                // Fallback к старому способу
                final deletedCount = success['deletedCount'];
                final totalFiles = success['totalFiles'];
                final serverMessage = success['message'];

                if (deletedCount != null && totalFiles != null) {
                  message = 'Удалено $deletedCount из $totalFiles файлов';
                } else if (serverMessage != null) {
                  message = serverMessage;
                }
              }
            }

            // После успешного удаления перезагружаем список файлов
            add(LoadFiles(folderId: event.folderId));
            DisplayMessage.showMessage(event.context, message);
          } catch (e) {
            print('Error in success handler: $e');
            emit(FilesError('Ошибка обработки ответа: $e'));
            DisplayMessage.showMessage(
                event.context, 'Ошибка обработки ответа: $e');
          }
        },
      );
    } catch (e) {
      print('Delete all files exception: $e');
      emit(FilesError('Ошибка удаления файлов: $e'));
      DisplayMessage.showMessage(event.context, 'Ошибка удаления файлов: $e');
    }
  }

  void _onRemoveFileLocally(
    RemoveFileLocally event,
    Emitter<FilesState> emit,
  ) {
    final currentState = state;
    if (currentState is FilesLoaded) {
      final updatedFiles =
          currentState.files.where((file) => file.id != event.fileId).toList();
      emit(FilesLoaded(files: updatedFiles));
    }
  }
}
