import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_bloc.dart';
import 'package:photo_app/entities/clients/bloc/clients_state.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_additional_photos_container.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_print_selector_container.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/confirmation_button.dart';

class ImageOrderContainer extends StatefulWidget {
  final int imageId;
  final int folderId;

  const ImageOrderContainer({
    super.key,
    required this.imageId,
    required this.folderId,
  });

  @override
  State<ImageOrderContainer> createState() => _ImageOrderContainerState();
}

class _ImageOrderContainerState extends State<ImageOrderContainer> {
  bool _hasUnconfirmedChanges = false;
  VoidCallback? _photosConfirmCallback;
  VoidCallback? _sizesConfirmCallback;
  bool _isExpanded = true;

  bool _hasAnySettings(BuildContext context) {
    final folderSettingsState = context.read<FolderSettingsBloc>().state;
    final clientsState = context.read<ClientsBloc>().state;

    if (folderSettingsState is! FolderSettingsLoaded) {
      return false;
    }

    if (clientsState is! ClientsLoaded || clientsState.selectedClient == null) {
      return false;
    }

    final settings = folderSettingsState.folderSettings;
    final orderAlbum = clientsState.selectedClient!.orderAlbum;

    // Проверяем дополнительные фото
    bool hasAdditionalPhotos = false;
    if (orderAlbum == false) {
      hasAdditionalPhotos = settings.photoThree.show;
    } else {
      hasAdditionalPhotos = settings.photoOne.show ||
          settings.photoTwo.show ||
          settings.photoThree.show;
    }

    // Проверяем размеры печати
    bool hasSizes = settings.sizeOne.show ||
        settings.sizeTwo.show ||
        settings.sizeThree.show;

    return hasAdditionalPhotos || hasSizes;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClientsBloc, ClientsState>(
      builder: (context, clientsState) {
        return BlocBuilder<FolderSettingsBloc, FolderSettingsState>(
          builder: (context, settingsState) {
            final hasSettings = _hasAnySettings(context);

            return Column(
              children: [
                // Кнопка сворачивания
                InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: 3.14159, // 180 градусов в радианах
                          child: Icon(
                            _isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.grey,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  child: ClipRect(
                    child: _isExpanded
                        ? Column(
                            children: [
                              ImageAdditionalPhotosContainer(
                                imageId: widget.imageId,
                                folderId: widget.folderId,
                                onChangesMade: _onChangesMade,
                                onConfirmCallback: (callback) =>
                                    _photosConfirmCallback = callback,
                              ),
                              ImagePrintSelectorContainer(
                                imageId: widget.imageId,
                                folderId: widget.folderId,
                                onChangesMade: _onChangesMade,
                                onConfirmCallback: (callback) =>
                                    _sizesConfirmCallback = callback,
                              ),
                              if (hasSettings) ...[
                                const SizedBox(height: 16),
                                ConfirmationButton(
                                  hasUnconfirmedChanges: _hasUnconfirmedChanges,
                                  onConfirm: _confirmAllChanges,
                                ),
                              ] else
                                Container(
                                  margin: const EdgeInsets.only(top: 16),
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Text(
                                    'Нет форматов для выбора',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _onChangesMade() {
    setState(() {
      _hasUnconfirmedChanges = true;
    });
  }

  void _confirmAllChanges() {
    // Подтверждаем изменения в обоих контейнерах
    _photosConfirmCallback?.call();
    _sizesConfirmCallback?.call();

    setState(() {
      _hasUnconfirmedChanges = false;
    });
  }
}
