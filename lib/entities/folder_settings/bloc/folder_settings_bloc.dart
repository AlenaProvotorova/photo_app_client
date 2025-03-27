import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/data/folder_settings/models/folder_settings.dart';
import 'package:photo_app/data/folder_settings/models/get_folder_settings_req_params.dart';
import 'package:photo_app/data/folder_settings/models/update_folder_settings_req_params.dart';
import 'package:photo_app/domain/folder_settings/usecases/get_folder_settings.dart';
import 'package:photo_app/domain/folder_settings/usecases/update_folder_settings.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_event.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'package:photo_app/service_locator.dart';

class FolderSettingsBloc
    extends Bloc<FolderSettingsEvent, FolderSettingsState> {
  FolderSettingsBloc() : super(FolderSettingsInitial()) {
    on<LoadFolderSettings>(_onLoadFolderSettings);
    on<UpdateFolderSettings>(_onUpdateFolderSettings);
  }

  Future<void> _onLoadFolderSettings(
    LoadFolderSettings event,
    Emitter<FolderSettingsState> emit,
  ) async {
    emit(FolderSettingsLoading());
    try {
      final response = await sl<GetFolderSettingsUseCase>().call(
        params: GetFolderSettingsReqParams(
          folderId: int.parse(event.folderId),
        ),
      );

      response.fold(
        (error) => emit(FolderSettingsError(message: error.toString())),
        (data) {
          if (data == null) {
            throw Exception('Неверный формат данных от сервера');
          }

          final settings = FolderSettings.fromJson(data);
          emit(FolderSettingsLoaded(folderSettings: settings));
        },
      );
    } catch (e) {
      emit(
        const FolderSettingsError(message: 'Ошибка загрузки настроек папки'),
      );
    }
  }

  Future<void> _onUpdateFolderSettings(
    UpdateFolderSettings event,
    Emitter<FolderSettingsState> emit,
  ) async {
    emit(FolderSettingsLoading());
    try {
      final response = await sl<UpdateFolderSettingsUseCase>().call(
        params: UpdateFolderSettingsReqParams(
          folderId: int.parse(event.folderId),
          settings: event.settings,
        ),
      );

      response.fold(
        (error) => emit(FolderSettingsError(message: error.toString())),
        (data) {
          if (data == null) {
            throw Exception('Неверный формат данных от сервера');
          }
          final settings = FolderSettings.fromJson(data);
          emit(FolderSettingsLoaded(folderSettings: settings));
        },
      );
    } catch (e) {
      emit(
        const FolderSettingsError(message: 'Ошибка изменения настроек папки'),
      );
    }
  }
}
