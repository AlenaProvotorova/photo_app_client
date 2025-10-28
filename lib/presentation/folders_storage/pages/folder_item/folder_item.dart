import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/core/constants/api_url.dart';
import 'package:photo_app/core/network/dio_client.dart';
import 'package:photo_app/data/image_picker/repositories/desktop_image_picker.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_event.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'package:photo_app/service_locator.dart';
import 'package:photo_app/data/image_picker/repositories/mobile_image_picker.dart';
import 'package:photo_app/data/image_picker/repositories/web_image_picker.dart';
import 'package:photo_app/domain/image_picker/repositories/image_picker.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_event.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_event.dart';
import 'package:photo_app/entities/order/bloc/order_state.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_bloc.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_event.dart';
import 'package:photo_app/entities/user/bloc/user_bloc.dart';
import 'package:photo_app/entities/user/bloc/user_event.dart';
import 'package:photo_app/entities/user/bloc/user_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_bloc.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/bloc/files_event.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/client_selector.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/date_selection_info.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/files/files_list.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/order_album.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/show_selected_button.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/switch_all_digital.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/upload_file_button.dart';
import 'package:file_picker/file_picker.dart';

class FolderItemScreen extends StatefulWidget {
  final String folderId;
  final String folderPath;
  const FolderItemScreen({
    super.key,
    required this.folderId,
    required this.folderPath,
  });

  @override
  FolderItemScreenState createState() => FolderItemScreenState();
}

class FolderItemScreenState extends State<FolderItemScreen> {
  late final ImagePickerRepository _imagePickerService;
  late final FilesBloc _filesBloc;
  late final UserBloc _userBloc;
  late final ClientsBloc _clientsBloc;
  late final SizesBloc _sizesBloc;
  late final OrderBloc _orderBloc;
  late final FolderSettingsBloc _folderSettingsBloc;
  bool _showSelected = false;
  bool _hasUpdatedFirstSettingsAlert = false;
  @override
  void initState() {
    super.initState();
    _userBloc = UserBloc()..add(LoadUser());
    _imagePickerService = kIsWeb
        ? WebImagePickerRepositoryImplementation()
        : Platform.isAndroid || Platform.isIOS
            ? MobileImagePickerRepositoryImplementation()
            : DesktopImagePickerRepositoryImplementation();
    _filesBloc = FilesBloc()..add(LoadFiles(folderId: widget.folderId));
    _clientsBloc = ClientsBloc()..add(LoadClients(folderId: widget.folderId));
    _folderSettingsBloc = FolderSettingsBloc()
      ..add(LoadFolderSettings(folderId: widget.folderId));
    _sizesBloc = SizesBloc()..add(LoadSizes());
    _orderBloc = OrderBloc()..add(LoadOrder(folderId: widget.folderId));
  }

  Future<void> _pickImages(context) async {
    final selectedImages = await _imagePickerService.pickImages();
    if (selectedImages.isNotEmpty) {
      if (selectedImages.length > 10) {
        _filesBloc.add(UploadFilesBatch(
          folderId: widget.folderId,
          images: selectedImages,
          context: context,
        ));
      } else {
        _filesBloc.add(UploadFiles(
          folderId: widget.folderId,
          images: selectedImages,
          context: context,
        ));
      }
    }
  }

  Future<void> _inRetouching() async {
    _orderBloc.add(LoadOrder(folderId: widget.folderId));

    String? selectedPath = await FilePicker.platform.getDirectoryPath(
      lockParentWindow: false,
    );

    if (selectedPath != null) {
      await Future.delayed(const Duration(milliseconds: 500));

      final state = _orderBloc.state;

      if (state is OrderLoaded) {
        final order = state.fullOrderForSorting;

        final retouchDirectory = Directory(path.join(selectedPath, 'РЕТУШЬ'));
        if (!await retouchDirectory.exists()) {
          await retouchDirectory.create(recursive: true);
        }

        final Set<String> orderFileNames = {};
        for (final client in order.keys) {
          for (final size in order[client]?.keys ?? []) {
            for (final file in order[client]?[size] ?? []) {
              final fileName = file['fileName'];
              final nameWithoutExtension = fileName.split('.').first;
              orderFileNames.add(nameWithoutExtension);
            }
          }
        }

        if (orderFileNames.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('В заказе нет файлов для копирования'),
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        final sourceDir = Directory(selectedPath);
        if (!await sourceDir.exists()) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Выбранная папка не найдена'),
              duration: Duration(seconds: 3),
            ),
          );
          return;
        }

        final sourceFiles = await sourceDir.list().toList();

        int copiedFiles = 0;
        int matchedFiles = 0;

        bool isFileInOrder(String fileName) {
          final nameWithoutExtension = fileName.split('.').first;
          return orderFileNames.contains(nameWithoutExtension);
        }

        for (final fileEntity in sourceFiles) {
          if (fileEntity is File) {
            final fileName = path.basename(fileEntity.path);

            if (isFileInOrder(fileName)) {
              matchedFiles++;

              final destinationFile =
                  File(path.join(retouchDirectory.path, fileName));

              if (!await destinationFile.exists()) {
                try {
                  await fileEntity.copy(destinationFile.path);
                  copiedFiles++;
                } catch (e) {}
              }
            }
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Найдено совпадений: $matchedFiles, скопировано файлов: $copiedFiles'),
            duration: const Duration(seconds: 5),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Заказ не загружен. Попробуйте еще раз.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _sortingRetouching() async {
    _orderBloc.add(LoadOrder(folderId: widget.folderId));
    _folderSettingsBloc.add(LoadFolderSettings(folderId: widget.folderId));

    String? selectedPath = await FilePicker.platform.getDirectoryPath(
      lockParentWindow: false,
    );

    if (selectedPath != null) {
      await Future.delayed(const Duration(milliseconds: 500));

      final orderState = _orderBloc.state;
      final settingsState = _folderSettingsBloc.state;

      if (orderState is OrderLoaded && settingsState is FolderSettingsLoaded) {
        final order = orderState.fullOrderForSorting;
        final settings = settingsState.folderSettings;

        final orderDirectory = Directory(path.join(selectedPath, 'ЗАКАЗ'));
        if (!await orderDirectory.exists()) {
          await orderDirectory.create(recursive: true);
        }

        final Set<String> orderSizes = {};
        for (final client in order.keys) {
          for (final size in order[client]?.keys ?? []) {
            orderSizes.add(size.toString());
          }
        }

        final Map<String, String> sizeToRuName = {};
        sizeToRuName['sizeOne'] = settings.sizeOne.ruName;
        sizeToRuName['sizeTwo'] = settings.sizeTwo.ruName;
        sizeToRuName['sizeThree'] = settings.sizeThree.ruName;
        sizeToRuName['photoOne'] = settings.photoOne.ruName;
        sizeToRuName['photoTwo'] = settings.photoTwo.ruName;
        sizeToRuName['photoThree'] = settings.photoThree.ruName;

        int totalCopiedFiles = 0;

        for (final size in orderSizes) {
          final ruName = sizeToRuName[size] ?? size;
          final sizeDirectory =
              Directory(path.join(orderDirectory.path, ruName));

          if (!await sizeDirectory.exists()) {
            await sizeDirectory.create(recursive: true);
          }
        }

        final Map<String, Map<String, dynamic>> allOrderFiles = {};
        for (final client in order.keys) {
          for (final size in order[client]?.keys ?? []) {
            final files = order[client]?[size] ?? [];
            for (final file in files) {
              final fileName = file['fileName'];
              final nameWithoutExtension = fileName.split('.').first;
              final fileCount = file['count'] ?? 1;

              if (!allOrderFiles.containsKey(nameWithoutExtension)) {
                allOrderFiles[nameWithoutExtension] = {
                  'client': client,
                  'originalFileName': fileName,
                  'sizes': <String, int>{},
                };
              }
              allOrderFiles[nameWithoutExtension]!['sizes'][size.toString()] =
                  fileCount;
            }
          }
        }

        final sourceDirectory = Directory(selectedPath);
        if (await sourceDirectory.exists()) {
          final sourceFiles = await sourceDirectory.list().toList();

          for (final fileEntity in sourceFiles) {
            if (fileEntity is File) {
              final fileName = path.basename(fileEntity.path);
              final nameWithoutExtension = fileName.split('.').first;

              if (allOrderFiles.containsKey(nameWithoutExtension)) {
                final fileInfo = allOrderFiles[nameWithoutExtension]!;
                final client = fileInfo['client'] as String;
                final sizes = fileInfo['sizes'] as Map<String, int>;

                for (final sizeEntry in sizes.entries) {
                  final size = sizeEntry.key;
                  final count = sizeEntry.value;

                  final ruName = sizeToRuName[size] ?? size;
                  final sizeDirectory =
                      Directory(path.join(orderDirectory.path, ruName));

                  String newFileName;
                  final intCount = int.tryParse(count.toString()) ?? 1;

                  if (intCount > 1) {
                    newFileName = '${intCount}_${client}_$fileName';
                  } else {
                    newFileName = '${client}_$fileName';
                  }

                  final destinationFile =
                      File(path.join(sizeDirectory.path, newFileName));

                  if (!await destinationFile.exists()) {
                    try {
                      await fileEntity.copy(destinationFile.path);
                      totalCopiedFiles++;
                    } catch (e) {}
                  }
                }
              }
            }
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Создано папок размеров/фото: ${orderSizes.length}, скопировано файлов: $totalCopiedFiles'),
            duration: const Duration(seconds: 5),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Не удалось загрузить данные заказа или настроек'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _updateFirstSettingsAlert() async {
    if (_hasUpdatedFirstSettingsAlert) return;

    _hasUpdatedFirstSettingsAlert = true;
    try {
      await sl<DioClient>().patch(
        '${ApiUrl.folderSettings}/${widget.folderId}',
        data: {'firstSettingsAlert': true},
      );
    } catch (e) {
      // Ошибка обновления игнорируется
    }
  }

  void _showDeleteAllFilesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Удалить все файлы'),
          content: const Text(
            'Вы уверены, что хотите удалить все файлы в этой папке? Это действие нельзя отменить.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Отмена'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _filesBloc.add(DeleteAllFiles(
                  folderId: widget.folderId,
                  context: context,
                ));
              },
              style: TextButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
              ),
              child: const Text('Удалить'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider.value(
      value: _userBloc,
      child: BlocBuilder<UserBloc, UserState>(
        builder: (context, userState) {
          final isAdmin = userState is UserLoaded && userState.user.isAdmin;

          return Scaffold(
            appBar: AppBarCustom(
              title: '',
              onPress: () => context.go('/home'),
              showLeading: isAdmin,
              actions: [
                Container(
                  margin: const EdgeInsets.all(8),
                  height: 36,
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(create: (context) => _userBloc),
                      BlocProvider(create: (context) => _orderBloc),
                    ],
                    child: BlocBuilder<UserBloc, UserState>(
                      builder: (context, state) {
                        if (state is UserLoaded && state.user.isAdmin) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  side: BorderSide(
                                      color: theme.colorScheme.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: _inRetouching,
                                child: const Text('В ретушь'),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  side: BorderSide(
                                      color: theme.colorScheme.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: _sortingRetouching,
                                child: const Text('Сортировка ретуши'),
                              ),
                              const SizedBox(width: 8),
                              TextButton(
                                style: TextButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  side: BorderSide(
                                      color: theme.colorScheme.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  context.go(
                                      '/folder/${widget.folderPath}/full-order');
                                },
                                child: const Text('Весь заказ'),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                style: IconButton.styleFrom(
                                  backgroundColor: theme.colorScheme.primary
                                      .withOpacity(0.1),
                                  side: BorderSide(
                                      color: theme.colorScheme.primary),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onPressed: () {
                                  context.go(
                                      '/folder/${widget.folderPath}/settings');
                                },
                                icon: Icon(
                                  Icons.settings_outlined,
                                  color: theme.colorScheme.primary,
                                ),
                                tooltip: 'Настройки папки',
                              ),
                            ],
                          );
                        }
                        return TextButton(
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            side: BorderSide(color: theme.colorScheme.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            context
                                .go('/folder/${widget.folderPath}/full-order');
                          },
                          child: const Text('Весь заказ'),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            body: MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => _userBloc),
                BlocProvider(create: (context) => _filesBloc),
                BlocProvider(create: (context) => _clientsBloc),
                BlocProvider(create: (context) => _folderSettingsBloc),
                BlocProvider(create: (context) => _sizesBloc),
                BlocProvider(create: (context) => _orderBloc),
              ],
              child: BlocBuilder<UserBloc, UserState>(
                builder: (context, userState) {
                  final isAdmin =
                      userState is UserLoaded && userState.user.isAdmin;

                  return BlocConsumer<FolderSettingsBloc, FolderSettingsState>(
                    listener: (context, state) {},
                    builder: (context, folderState) {
                      final showAlert = isAdmin &&
                          folderState is FolderSettingsLoaded &&
                          folderState.folderSettings.firstSettingsAlert ==
                              false;

                      if (showAlert) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _updateFirstSettingsAlert();
                        });
                      }

                      return Column(
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  if (showAlert)
                                    Container(
                                      margin: const EdgeInsets.all(16),
                                      padding: const EdgeInsets.all(16),
                                      decoration: BoxDecoration(
                                        color: Colors.amber.withOpacity(0.1),
                                        border: Border.all(color: Colors.amber),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            color: Colors.amber.shade700,
                                            size: 24,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Text(
                                              'Вам необходимо установить настройки для папки, прежде чем поделитесь ссылкой на нее с клиентами.',
                                              style: TextStyle(
                                                color: Colors.amber.shade800,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          TextButton(
                                            onPressed: () {
                                              context.go(
                                                  '/folder/${widget.folderPath}/settings');
                                            },
                                            child: Text(
                                              'Перейти в настройки',
                                              style: TextStyle(
                                                color: Colors.amber.shade800,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ClientSelector(
                                    folderId: widget.folderId,
                                  ),
                                  DateSelectionInfo(
                                    folderId: widget.folderId,
                                  ),
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: theme.colorScheme.primary),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(children: [
                                      SwitchAllDigital(
                                        folderId: widget.folderId,
                                      ),
                                      OrderAlbum(
                                        folderId: widget.folderId,
                                      )
                                    ]),
                                  ),
                                  ShowSelectedButton(
                                    showSelected: _showSelected,
                                    onPressed: () {
                                      setState(() {
                                        _showSelected = !_showSelected;
                                      });
                                    },
                                  ),
                                  FilesList(
                                    showSelected: _showSelected,
                                    folderId: widget.folderId,
                                    orderBloc: _orderBloc,
                                    clientsBloc: _clientsBloc,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          UploadFileButton(
                            pickImages: (context) async {
                              await _pickImages(context);
                            },
                            onDeleteAll: (context) =>
                                _showDeleteAllFilesDialog(context),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
