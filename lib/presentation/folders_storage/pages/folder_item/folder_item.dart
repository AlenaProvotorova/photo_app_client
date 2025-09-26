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
      _filesBloc.add(UploadFiles(
        folderId: widget.folderId,
        images: selectedImages,
        context: context,
      ));
    }
  }

  Future<void> _selectDirectory() async {
    _orderBloc.add(LoadOrder(folderId: widget.folderId));

    String? path = await FilePicker.platform.getDirectoryPath(
      lockParentWindow: false,
    );

    if (path != null) {
      final state = _orderBloc.state;
      if (state is OrderLoaded) {
        final order = state.fullOrderForSorting;
        final orderClients = order.keys.toList();

        for (final client in orderClients) {
          final newClientDirectory = Directory('$path/$client');

          if (!await newClientDirectory.exists()) {
            await newClientDirectory.create();
          }

          final sizes = order[client]?.keys.toList() ?? [];
          for (final size in sizes) {
            final newSizeDirectory = Directory('$path/$client/$size');

            if (!await newSizeDirectory.exists()) {
              await newSizeDirectory.create();
            }

            final orderFiles = order[client]?[size] ?? [];
            for (final file in orderFiles) {
              final sourceFile = File('$path/${file['fileName']}');
              if (await sourceFile.exists()) {
                final countText =
                    file['count'] > 1 ? '${file['count']}шт ' : '';
                final destinationPath =
                    '${newSizeDirectory.path}/$countText${client}_${file['fileName']}';
                await sourceFile.copy(destinationPath);
              }
            }
          }
        }
      }
    }
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
                    return TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        side: BorderSide(color: theme.colorScheme.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: _selectDirectory,
                      child: const Text('Отсортировать'),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(8),
            height: 36,
            child: TextButton(
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
                const OrderAlbum()
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
