import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/data/files/models/file.dart';
import 'package:photo_app/data/files/models/upload_file_req_params.dart';
import 'package:photo_app/domain/files/usecases/get_all_files.dart';
import 'package:photo_app/domain/files/usecases/upload_file.dart';
import 'package:photo_app/domain/image_picker/repositories/image_picker.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_event.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_state.dart';
import 'package:photo_app/service_locator.dart';

class FilesBloc extends Bloc<FilesEvent, FilesState> {
  final ImagePickerRepository imagePickerService;
  final UploadFileUseCase uploadFileUseCase;

  FilesBloc({
    required this.imagePickerService,
    required this.uploadFileUseCase,
  }) : super(FilesLoading()) {
    on<LoadFiles>(_onLoadFiles);
    on<AddImages>((event, emit) => _onAddImages(event, emit, event.context));
    on<UploadImage>(
        (event, emit) => _onUploadImage(event, emit, event.context));
  }

  Future<void> _onLoadFiles(
    LoadFiles event,
    Emitter<FilesState> emit,
  ) async {
    emit(FilesLoading());
    try {
      final response = await sl<GetAllFilesUseCase>().call();
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

  Future<void> _onAddImages(
      AddImages event, Emitter<FilesState> emit, BuildContext context) async {
    final currentState = state;
    if (currentState is FilesLoaded) {
      emit(FilesLoaded(
        files: currentState.files,
        images: [...currentState.images, ...event.images],
      ));

      for (var image in event.images) {
        add(UploadImage(image, context));
      }
    }
  }

  Future<void> _onUploadImage(
      UploadImage event, Emitter<FilesState> emit, context) async {
    try {
      final multipartFile =
          await imagePickerService.createMultipartFile(event.image);
      final formData = FormData.fromMap({
        'file': multipartFile,
      });

      final result = await sl<UploadFileUseCase>().call(
        params: UploadFileReqParams(formData: formData),
      );

      result.fold(
        (error) => DisplayMessage.showMessage(context, error),
        (success) {
          DisplayMessage.showMessage(context, 'Files uploaded successfully');
        },
      );
    } catch (e) {
      emit(FilesError(e.toString()));
    }
  }
}
