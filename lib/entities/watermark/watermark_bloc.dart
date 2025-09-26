import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/data/files/models/file.dart';
import 'package:photo_app/data/watermarks/models/get_watermark_req_params.dart';
import 'package:photo_app/data/watermarks/models/remove_watermark_req_params.dart';
import 'package:photo_app/data/watermarks/models/upload_watermark_req_params.dart';
import 'package:photo_app/domain/watermarks/usecases/get_watermark.dart';
import 'package:photo_app/domain/watermarks/usecases/remove_watermark.dart';
import 'package:photo_app/domain/watermarks/usecases/upload_watermark.dart';
import 'package:photo_app/entities/watermark/watermark_event.dart';
import 'package:photo_app/entities/watermark/watermark_state.dart';
import 'package:photo_app/service_locator.dart';

class WatermarkBloc extends Bloc<WatermarkEvent, WatermarkState> {
  WatermarkBloc() : super(WatermarkLoading()) {
    on<LoadWatermark>(_onLoadWatermark);
    on<UploadWatermark>(_onUploadWatermark);
    on<DeleteWatermark>(_onDeleteWatermark);
  }

  Future<void> _onLoadWatermark(
    LoadWatermark event,
    Emitter<WatermarkState> emit,
  ) async {
    emit(WatermarkLoading());
    try {
      final response = await sl<GetWatermarkUseCase>().call(
        params: GetAllWatermarksReqParams(
          userId: int.parse(event.userId),
        ),
      );
      response.fold(
        (error) => emit(WatermarkError(error.toString())),
        (data) {
          if (data == null) {
            emit(WatermarkLoaded(watermark: null));
            throw Exception('Неверный формат данных от сервера');
          }
          final watermarks = data.map((json) => File.fromJson(json)).toList();
          emit(WatermarkLoaded(
              watermark: watermarks.isEmpty ? null : watermarks[0]));
        },
      );
    } catch (e) {
      emit(WatermarkError('Ошибка загрузки водяного знака'));
    }
  }

  Future<void> _onUploadWatermark(
    UploadWatermark event,
    Emitter<WatermarkState> emit,
  ) async {
    try {
      final result = await sl<UploadWatermarkUseCase>().call(
        params: UploadWatermarkReqParams(
          userId: int.parse(event.userId),
          formData: FormData.fromMap({
            'file': kIsWeb
                ? MultipartFile.fromBytes(
                    event.image.bytes!,
                    filename: event.image.path,
                  )
                : await MultipartFile.fromFile(event.image.path!),
          }),
        ),
      );

      result.fold(
        (error) => DisplayMessage.showMessage(event.context, error),
        (success) {
          add(LoadWatermark(userId: event.userId));
        },
      );
    } catch (e) {
      emit(WatermarkError('Ошибка загрузки водяного знака'));
    }
  }

  Future<void> _onDeleteWatermark(
    DeleteWatermark event,
    Emitter<WatermarkState> emit,
  ) async {
    try {
      final result = await sl<RemoveWatermarkUseCase>().call(
        params: RemoveWatermarkReqParams(
          userId: int.parse(event.userId),
        ),
      );

      result.fold(
        (error) => DisplayMessage.showMessage(event.context, error),
        (success) {
          add(LoadWatermark(userId: event.userId));
        },
      );
    } catch (e) {
      emit(WatermarkError('Ошибка удаления водяного знака'));
    }
  }
}
