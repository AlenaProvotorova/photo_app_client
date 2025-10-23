import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_app/core/components/app_bar_custom.dart';
import 'package:photo_app/data/image_picker/repositories/desktop_image_picker.dart';
import 'package:photo_app/data/image_picker/repositories/mobile_image_picker.dart';
import 'package:photo_app/data/image_picker/repositories/web_image_picker.dart';
import 'package:photo_app/domain/image_picker/repositories/image_picker.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_event.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_event.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
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
      // Если файлов больше 10, используем массовую загрузку
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

        final retouchDirectory = Directory('$selectedPath/РЕТУШЬ');
        if (!await retouchDirectory.exists()) {
          await retouchDirectory.create();
        }

        final Set<String> orderFileNames = {};
        for (final client in order.keys) {
          for (final size in order[client]?.keys ?? []) {
            for (final file in order[client]?[size] ?? []) {
              orderFileNames.add(file['fileName']);
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
          return orderFileNames.contains(fileName);
        }

        for (final fileEntity in sourceFiles) {
          if (fileEntity is File) {
            final fileName = fileEntity.path.split('/').last;

            if (isFileInOrder(fileName)) {
              matchedFiles++;

              final destinationFile =
                  File('${retouchDirectory.path}/$fileName');

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

        final orderDirectory = Directory('$selectedPath/ЗАКАЗ');
        if (!await orderDirectory.exists()) {
          await orderDirectory.create();
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
          final sizeDirectory = Directory('${orderDirectory.path}/$ruName');

          if (!await sizeDirectory.exists()) {
            await sizeDirectory.create();
          }

          final Map<String, Map<String, dynamic>> filesForThisSize = {};
          for (final client in order.keys) {
            final files = order[client]?[size] ?? [];
            for (final file in files) {
              final fileName = file['fileName'];
              filesForThisSize[fileName] = {
                'client': client,
                'count': file['count'] ?? 1,
                'originalFileName': fileName,
              };
            }
          }

          final retouchDirectory = Directory('$selectedPath/РЕТУШЬ');
          if (await retouchDirectory.exists()) {
            final retouchFiles = await retouchDirectory.list().toList();

            for (final fileEntity in retouchFiles) {
              if (fileEntity is File) {
                final fileName = fileEntity.path.split('/').last;

                if (filesForThisSize.containsKey(fileName)) {
                  final fileInfo = filesForThisSize[fileName]!;
                  final client = fileInfo['client'] as String;
                  final count = fileInfo['count'] as int;

                  String newFileName;
                  if (count > 1) {
                    newFileName = '${count}_${client}_$fileName';
                  } else {
                    newFileName = '${client}_$fileName';
                  }

                  final destinationFile =
                      File('${sizeDirectory.path}/$newFileName');

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
    return Scaffold(
      appBar: AppBarCustom(
        title: '',
        onPress: () => context.go('/home'),
        showLeading: true,
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
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            side: BorderSide(color: theme.colorScheme.primary),
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
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            side: BorderSide(color: theme.colorScheme.primary),
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
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          style: IconButton.styleFrom(
                            backgroundColor:
                                theme.colorScheme.error.withOpacity(0.1),
                            side: BorderSide(color: theme.colorScheme.error),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () => _showDeleteAllFilesDialog(context),
                          icon: Icon(
                            Icons.delete_outline,
                            color: theme.colorScheme.error,
                          ),
                          tooltip: 'Удалить все файлы',
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
                      context.go('/folder/${widget.folderPath}/full-order');
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
        child: Column(
          children: [
            ClientSelector(
              folderId: widget.folderId,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border.all(color: theme.colorScheme.primary),
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
            Expanded(
              child: FilesList(
                showSelected: _showSelected,
                folderId: widget.folderId,
                orderBloc: _orderBloc,
                clientsBloc: _clientsBloc,
              ),
            ),
            UploadFileButton(
              pickImages: (context) async {
                await _pickImages(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
