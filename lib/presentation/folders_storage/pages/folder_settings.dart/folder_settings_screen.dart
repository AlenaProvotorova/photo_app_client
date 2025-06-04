import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart' as router;
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/data/folder_settings/models/folder_settings.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_event.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_settings.dart/widgets/rename_setting.dart';

class FolderSettingsScreen extends StatelessWidget {
  final String folderId;
  final String folderPath;
  FolderSettingsScreen({
    super.key,
    required this.folderId,
    required this.folderPath,
  });

  final defaultSettingsList = [
    {
      'tileText': "Переключатель",
      'name': 'showSelectAllDigital',
      'showRenameButton': false,
    },
    {
      'tileText': 'Переключатель',
      'name': 'photoOne',
      'showRenameButton': true,
    },
    {
      'tileText': 'Переключатель',
      'name': 'photoTwo',
      'showRenameButton': true,
    },
    {
      'tileText': 'Переключатель',
      'name': 'photoThree',
      'showRenameButton': true,
    },
    {
      'tileText': 'Счетчик',
      'name': 'sizeOne',
      'showRenameButton': true,
    },
    {
      'tileText': 'Счетчик',
      'name': 'sizeTwo',
      'showRenameButton': true,
    },
    {
      'tileText': 'Счетчик',
      'name': 'sizeThree',
      'showRenameButton': true,
    },
  ];

  String getCheckboxTileName(setting, FolderSettings state) {
    final baseName = setting['tileText'];
    final tileName = setting['name'];
    final ruName = state.getRuNameProperty(tileName);

    if (ruName != null) {
      return '$baseName "$ruName"';
    } else {
      return '$baseName';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) =>
          FolderSettingsBloc()..add(LoadFolderSettings(folderId: folderId)),
      child: Scaffold(
        appBar: AppBarCustom(
          onPress: () {
            context.go('/home');
          },
          showLeading: true,
          title: 'Настройки папки',
        ),
        body: BlocBuilder<FolderSettingsBloc, FolderSettingsState>(
          builder: (context, state) {
            if (state is FolderSettingsLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is FolderSettingsLoaded) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Выберите необходимый функционал для клиента',
                      style: theme.textTheme.titleSmall,
                    ),
                    const SizedBox(height: 20),
                    ...defaultSettingsList.map((setting) => CheckboxListTile(
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          title: Text(
                            'Заказать фото ${getCheckboxTileName(setting, state.folderSettings)}',
                            style: theme.textTheme.titleMedium,
                          ),
                          value: state.folderSettings
                              .getShowProperty(setting['name'] as String),
                          onChanged: (bool? value) {
                            context
                                .read<FolderSettingsBloc>()
                                .add(UpdateFolderSettings(
                                  folderId: folderId,
                                  settings: {
                                    'settingName': setting['name'],
                                    'show': value,
                                  },
                                ));
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          secondary: setting['showRenameButton'] == true
                              ? RenameSetting(
                                  settingName: setting['name'] as String,
                                  onSave: (settingName, newName) {
                                    context
                                        .read<FolderSettingsBloc>()
                                        .add(UpdateFolderSettings(
                                          folderId: folderId,
                                          settings: {
                                            'settingName': setting['name'],
                                            'newName': newName,
                                          },
                                        ));
                                  },
                                )
                              : null,
                        )),
                  ],
                ),
              );
            }
            if (state is FolderSettingsError) {
              return Center(
                child: Text('Ошибка: ${state.message}'),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
