import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart' as router;
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/data/folder_settings/models/folder_settings.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_event.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_settings.dart/widgets/rename_setting.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_settings.dart/widgets/date_selector.dart';

class FolderSettingsScreen extends StatefulWidget {
  final String folderId;
  final String folderPath;
  FolderSettingsScreen({
    super.key,
    required this.folderId,
    required this.folderPath,
  });

  @override
  State<FolderSettingsScreen> createState() => _FolderSettingsScreenState();
}

class _FolderSettingsScreenState extends State<FolderSettingsScreen> {
  final Map<String, bool> _localSettings = {};
  bool _hasChanges = false;
  bool _applyingChanges = false;
  FolderSettingsBloc? _bloc;

  void _resetChanges() {
    setState(() {
      _localSettings.clear();
      _hasChanges = false;
      _applyingChanges = false;
    });
  }

  void _updateLocalSetting(String settingName, bool value) {
    setState(() {
      _localSettings[settingName] = value;
      _hasChanges = _localSettings.isNotEmpty;
    });
  }

  void _applyChanges(FolderSettings currentSettings) {
    if (_localSettings.isEmpty) return;
    if (_bloc == null) {
      return;
    }

    setState(() {
      _applyingChanges = true;
    });

    final changesToApply = Map<String, bool>.from(_localSettings);

    for (var entry in changesToApply.entries) {
      _bloc!.add(
        UpdateFolderSettings(
          folderId: widget.folderId,
          settings: {
            'settingName': entry.key,
            'show': entry.value,
          },
        ),
      );
    }
  }

  bool _isCheckboxChecked(String settingName, FolderSettings currentSettings) {
    return _localSettings[settingName] ??
        currentSettings.getShowProperty(settingName) as bool;
  }

  @override
  void dispose() {
    _bloc?.close();
    super.dispose();
  }

  final defaultSettingsList = [
    {
      'tileText': "Переключатель",
      'name': 'showSelectAllDigital',
      'showRenameButton': true,
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
    final price = state.getPriceProperty(tileName);

    if (ruName != null) {
      String result = '$baseName "$ruName"';
      if (price != null && price != 0) {
        result += ' - $price ₽';
      }
      return result;
    } else {
      return '$baseName';
    }
  }

  void _openFolder(BuildContext context) {
    router.GoRouter.of(context).go('/folder/${widget.folderPath}');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_bloc == null) {
      _bloc = FolderSettingsBloc()
        ..add(LoadFolderSettings(folderId: widget.folderId));
    }

    return BlocProvider(
      create: (context) => _bloc!,
      child: BlocListener<FolderSettingsBloc, FolderSettingsState>(
        listener: (context, state) {
          if (state is FolderSettingsLoaded && _applyingChanges) {
            _resetChanges();
          }
        },
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
                            activeColor: theme.colorScheme.primary,
                            title: Text(
                              getCheckboxTileName(
                                  setting, state.folderSettings),
                              style: theme.textTheme.titleMedium,
                            ),
                            value: _isCheckboxChecked(setting['name'] as String,
                                state.folderSettings),
                            onChanged: (bool? value) {
                              _updateLocalSetting(
                                  setting['name'] as String, value!);
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            secondary: setting['showRenameButton'] == true
                                ? RenameSetting(
                                    settingName: setting['name'] as String,
                                    currentName: state.folderSettings
                                        .getRuNameProperty(
                                            setting['name'] as String),
                                    price: state.folderSettings
                                        .getPriceProperty(
                                            setting['name'] as String),
                                    onSave: (settingName, newName) {
                                      _bloc?.add(UpdateFolderSettings(
                                        folderId: widget.folderId,
                                        settings: {
                                          'settingName': setting['name'],
                                          'newName': newName,
                                        },
                                      ));
                                    },
                                    onSavePrice: (settingName, price) {
                                      int? priceValue;
                                      if (price.isNotEmpty) {
                                        final normalizedPrice =
                                            price.replaceAll(',', '.');
                                        priceValue =
                                            double.tryParse(normalizedPrice)
                                                ?.round();
                                      }

                                      _bloc?.add(UpdateFolderSettings(
                                        folderId: widget.folderId,
                                        settings: {
                                          'settingName': setting['name'],
                                          'price': priceValue,
                                        },
                                      ));
                                    },
                                  )
                                : null,
                          )),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          onPressed: (_hasChanges && !_applyingChanges)
                              ? () {
                                  _applyChanges(state.folderSettings);
                                }
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (_hasChanges && !_applyingChanges)
                                ? theme.colorScheme.primary
                                : Colors.grey,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: _applyingChanges
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Применить'),
                        ),
                      ),
                      const SizedBox(height: 20),
                      DateSelector(
                        initialDate: state.folderSettings.getDateSelectTo(),
                        onDateChanged: (date) {},
                        onApply: (date) {
                          _bloc?.add(UpdateFolderSettings(
                            folderId: widget.folderId,
                            settings: {
                              'dateSelectTo': date?.toIso8601String(),
                            },
                          ));
                        },
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _openFolder(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Text('Перейти в папку'),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ),
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
      ),
    );
  }
}
