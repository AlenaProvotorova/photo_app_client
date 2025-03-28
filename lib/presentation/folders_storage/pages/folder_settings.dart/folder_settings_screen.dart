import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart' as router;
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/data/folder_settings/models/folder_settings.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_event.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_settings.dart/widgets/add_description.dart';

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
      'nameRu': "Переключатель 'ВЫБРАТЬ ВСЕ ФОТО В ЦИФРОВОМ ВИДЕ'",
      'name': 'showSelectAllDigital',
    },
    {
      'nameRu': "Переключатель 'ФОТО 1'",
      'name': 'showPhotoOne',
    },
    {
      'nameRu': "Переключатель 'ФОТО 2'",
      'name': 'showPhotoTwo',
    },
    {
      'nameRu': "Счетчик 'Заказать фото 10Х15'",
      'name': 'showSize1',
      'descriptionName': 'sizeDescription1',
    },
    {
      'nameRu': "Счетчик 'Заказать фото 15Х21'",
      'name': 'showSize2',
      'descriptionName': 'sizeDescription2',
    },
    {
      'nameRu': "Счетчик 'Заказать фото 20Х30'",
      'name': 'showSize3',
      'descriptionName': 'sizeDescription3',
    },
  ];

  String getCheckboxTileName(setting, FolderSettings state) {
    final baseName = setting['nameRu'];
    final descName = setting['descriptionName']?.trim();

    if (descName == null) return baseName;

    final desc = state.getProperty(descName);
    return desc?.isNotEmpty == true ? '$baseName ($desc)' : baseName;
  }

  @override
  // ignore: avoid_renaming_method_parameters
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
                      style: theme.textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 20),
                    ...defaultSettingsList.map((setting) => CheckboxListTile(
                          checkboxShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4),
                          ),
                          title: Text(
                            getCheckboxTileName(setting, state.folderSettings),
                            style: theme.textTheme.titleMedium,
                          ),
                          value: state.folderSettings
                              .getProperty(setting['name'] ?? ''),
                          onChanged: (bool? value) {
                            context
                                .read<FolderSettingsBloc>()
                                .add(UpdateFolderSettings(
                                  folderId: folderId,
                                  settings: {
                                    setting['name']!: value ?? false,
                                  },
                                ));
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          secondary: setting['descriptionName'] != null
                              ? AddDescription(
                                  descriptionName: setting['descriptionName']!,
                                  onSave: (descriptionName, description) {
                                    context
                                        .read<FolderSettingsBloc>()
                                        .add(UpdateFolderSettings(
                                          folderId: folderId,
                                          settings: {
                                            descriptionName: description,
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
