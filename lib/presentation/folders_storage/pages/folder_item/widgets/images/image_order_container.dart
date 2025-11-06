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
  final ValueChanged<bool>? onUnconfirmedChangesChanged;
  final bool? initialExpanded;
  final ValueChanged<bool>? onExpandedChanged;

  const ImageOrderContainer({
    super.key,
    required this.imageId,
    required this.folderId,
    this.onUnconfirmedChangesChanged,
    this.initialExpanded,
    this.onExpandedChanged,
  });

  @override
  State<ImageOrderContainer> createState() => _ImageOrderContainerState();
}

class _ImageOrderContainerState extends State<ImageOrderContainer> {
  bool _hasUnconfirmedChanges = false;
  VoidCallback? _photosConfirmCallback;
  VoidCallback? _sizesConfirmCallback;
  late bool _isExpanded;
  bool _photosHasChanges = false;
  bool _sizesHasChanges = false;
  Map<String, bool>? _savedPhotosChanges;
  Map<String, int>? _savedSizesChanges;
  final GlobalKey _photosContainerKey = GlobalKey();
  final GlobalKey _sizesContainerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded ?? true;
  }

  @override
  void didUpdateWidget(ImageOrderContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialExpanded != null &&
        widget.initialExpanded != oldWidget.initialExpanded) {
      setState(() {
        _isExpanded = widget.initialExpanded!;
      });
    }
  }

  void confirmChanges() {
    _confirmAllChanges();
  }

  void cancelChanges() {
    setState(() {
      _hasUnconfirmedChanges = false;
    });
    widget.onUnconfirmedChangesChanged?.call(false);
  }

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

    bool hasAdditionalPhotos = false;
    if (orderAlbum == false) {
      hasAdditionalPhotos = settings.photoThree.show;
    } else {
      hasAdditionalPhotos = settings.photoOne.show ||
          settings.photoTwo.show ||
          settings.photoThree.show;
    }

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
                InkWell(
                  onTap: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                    widget.onExpandedChanged?.call(_isExpanded);
                  },
                  child: Container(
                    padding: const EdgeInsets.only(top: 16, bottom: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.rotate(
                          angle: 3.14159,
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
                                key: _photosContainerKey,
                                imageId: widget.imageId,
                                folderId: widget.folderId,
                                onChangesMade: _onChangesMade,
                                onConfirmCallback: (callback) =>
                                    _photosConfirmCallback = callback,
                                onHasChangesChanged: _onPhotosHasChangesChanged,
                                savedPendingChanges: _savedPhotosChanges,
                                onPendingChangesChanged:
                                    _onPhotosPendingChangesChanged,
                              ),
                              ImagePrintSelectorContainer(
                                key: _sizesContainerKey,
                                imageId: widget.imageId,
                                folderId: widget.folderId,
                                onChangesMade: _onChangesMade,
                                onConfirmCallback: (callback) =>
                                    _sizesConfirmCallback = callback,
                                onHasChangesChanged: _onSizesHasChangesChanged,
                                savedPendingChanges: _savedSizesChanges,
                                onPendingChangesChanged:
                                    _onSizesPendingChangesChanged,
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
    _checkIfHasChanges();
  }

  void _onPhotosPendingChangesChanged(Map<String, bool> changes) {
    setState(() {
      if (changes.isNotEmpty) {
        _savedPhotosChanges = Map<String, bool>.from(changes);
      } else {
        _savedPhotosChanges = null;
      }
    });
  }

  void _onSizesPendingChangesChanged(Map<String, int> changes) {
    setState(() {
      if (changes.isNotEmpty) {
        _savedSizesChanges = Map<String, int>.from(changes);
      } else {
        _savedSizesChanges = null;
      }
    });
  }

  void _checkIfHasChanges() {
    final hasChanges = _photosHasChanges || _sizesHasChanges;

    setState(() {
      _hasUnconfirmedChanges = hasChanges;
    });
    widget.onUnconfirmedChangesChanged?.call(hasChanges);
  }

  void _onPhotosHasChangesChanged(bool hasChanges) {
    setState(() {
      _photosHasChanges = hasChanges;
    });
    _checkIfHasChanges();
  }

  void _onSizesHasChangesChanged(bool hasChanges) {
    setState(() {
      _sizesHasChanges = hasChanges;
    });
    _checkIfHasChanges();
  }

  void _confirmAllChanges() {
    _photosConfirmCallback?.call();
    _sizesConfirmCallback?.call();

    setState(() {
      _hasUnconfirmedChanges = false;
      _savedPhotosChanges = null;
      _savedSizesChanges = null;
    });
    widget.onUnconfirmedChangesChanged?.call(false);
  }
}
