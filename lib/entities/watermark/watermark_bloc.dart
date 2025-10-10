import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/core/helpers/message/display_message.dart';
import 'package:photo_app/data/watermarks/models/watermark.dart';
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
      print('Загружаем водяной знак для пользователя: ${event.userId}');
      final response = await sl<GetWatermarkUseCase>().call(
        params: GetAllWatermarksReqParams(
          userId: int.parse(event.userId),
        ),
      );

      response.fold(
        (error) {
          print('❌ ОШИБКА получения водяного знака: $error');
          emit(WatermarkError(error.toString()));
        },
        (data) {
          print('✅ УСПЕШНО получены данные от сервера');
          print('📊 Тип данных: ${data.runtimeType}');
          print('📊 Содержимое данных: $data');

          if (data == null) {
            print('⚠️ Данные null - водяной знак не найден');
            emit(WatermarkLoaded(watermark: null));
            return;
          }

          try {
            print('Тип данных: ${data.runtimeType}');
            print('Содержимое данных: $data');

            if (data is! List) {
              print('Данные не являются списком, тип: ${data.runtimeType}');
              emit(WatermarkError('Неверный формат данных: ожидается список'));
              return;
            }

            final watermarks = <Watermark>[];
            print('🔄 Начинаем обработку ${data.length} элементов');

            for (int i = 0; i < data.length; i++) {
              try {
                print('🔍 Парсим элемент $i: ${data[i]}');
                print('🔍 Тип элемента $i: ${data[i].runtimeType}');
                final watermark = Watermark.fromJson(data[i]);
                watermarks.add(watermark);
                print(
                    '✅ Успешно распарсен водяной знак: ${watermark.filename}');
                print('✅ URL водяного знака: ${watermark.url}');
              } catch (itemError) {
                print('❌ Ошибка парсинга элемента $i: $itemError');
                print('❌ Проблемный элемент: ${data[i]}');
                print('❌ Тип проблемного элемента: ${data[i].runtimeType}');
              }
            }

            print('Обработано водяных знаков: ${watermarks.length}');

            if (watermarks.isEmpty) {
              print('Список водяных знаков пуст - устанавливаем null');
              emit(WatermarkLoaded(watermark: null));
            } else {
              final watermark = watermarks[0];
              print('Выбран первый водяной знак: ${watermark.filename}');
              print('URL водяного знака: ${watermark.url}');
              print('URL пустой: ${watermark.url.isEmpty}');

              // Проверяем, что водяной знак валиден (имеет URL)
              if (watermark.url.isEmpty) {
                print('URL водяного знака пустой - считаем как отсутствующий');
                emit(WatermarkLoaded(watermark: null));
              } else {
                print('Водяной знак валиден - устанавливаем в состояние');
                emit(WatermarkLoaded(watermark: watermark));
              }
            }
          } catch (parseError) {
            print('Общая ошибка парсинга данных: $parseError');
            emit(WatermarkError(
                'Ошибка обработки данных водяного знака: ${parseError.toString()}'));
          }
        },
      );
    } catch (e) {
      print('Общая ошибка загрузки водяного знака: $e');
      emit(WatermarkError('Ошибка загрузки водяного знака: ${e.toString()}'));
    }
  }

  Future<void> _onUploadWatermark(
    UploadWatermark event,
    Emitter<WatermarkState> emit,
  ) async {
    emit(WatermarkLoading());
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
        (error) {
          emit(WatermarkError('Ошибка загрузки: $error'));
          DisplayMessage.showMessage(event.context, 'Ошибка загрузки: $error');
        },
        (success) {
          add(LoadWatermark(userId: event.userId));
          DisplayMessage.showMessage(
              event.context, 'Водяной знак успешно загружен');
        },
      );
    } catch (e) {
      final errorMessage = 'Ошибка загрузки водяного знака: ${e.toString()}';
      emit(WatermarkError(errorMessage));
      DisplayMessage.showMessage(event.context, errorMessage);
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
