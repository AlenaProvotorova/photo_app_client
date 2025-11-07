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

class _ImageOrderContainerState extends State<ImageOrderContainer>
    with SingleTickerProviderStateMixin {
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
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initialExpanded ?? true;
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );
    _animationController.value = _isExpanded ? 1.0 : 0.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ImageOrderContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialExpanded != null) {
      final targetExpanded = widget.initialExpanded!;
      if (targetExpanded != _isExpanded) {
        setState(() {
          _isExpanded = targetExpanded;
        });
        _animationController.animateTo(
          targetExpanded ? 1.0 : 0.0,
        );
      }
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

            return Stack(
              clipBehavior: Clip.none,
              children: [
                AnimatedBuilder(
                  animation: _slideAnimation,
                  builder: (context, child) {
                    final collapseValue = 1.0 - _slideAnimation.value;

                    const resizeButtonHeight = 56.0;
                    final minHeight = resizeButtonHeight;
                    final contentOpacity = _slideAnimation.value;

                    return Container(
                      constraints: BoxConstraints(
                        minHeight: minHeight,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                final newExpanded = !_isExpanded;
                                setState(() {
                                  _isExpanded = newExpanded;
                                });
                                _animationController.animateTo(
                                  newExpanded ? 1.0 : 0.0,
                                );
                                widget.onExpandedChanged?.call(newExpanded);
                              },
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 16,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      _isExpanded
                                          ? Icons.keyboard_double_arrow_down
                                          : Icons.keyboard_double_arrow_up,
                                      color: Colors.grey[700],
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Изменить размер',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[700],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          ClipRect(
                            child: SizeTransition(
                              sizeFactor: _slideAnimation,
                              axisAlignment: -1.0,
                              child: Opacity(
                                opacity: contentOpacity,
                                child: IgnorePointer(
                                  ignoring: collapseValue > 0.5,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            ImageAdditionalPhotosContainer(
                                              key: _photosContainerKey,
                                              imageId: widget.imageId,
                                              folderId: widget.folderId,
                                              onChangesMade: _onChangesMade,
                                              onConfirmCallback: (callback) =>
                                                  _photosConfirmCallback =
                                                      callback,
                                              onHasChangesChanged:
                                                  _onPhotosHasChangesChanged,
                                              savedPendingChanges:
                                                  _savedPhotosChanges,
                                              onPendingChangesChanged:
                                                  _onPhotosPendingChangesChanged,
                                            ),
                                            ImagePrintSelectorContainer(
                                              key: _sizesContainerKey,
                                              imageId: widget.imageId,
                                              folderId: widget.folderId,
                                              onChangesMade: _onChangesMade,
                                              onConfirmCallback: (callback) =>
                                                  _sizesConfirmCallback =
                                                      callback,
                                              onHasChangesChanged:
                                                  _onSizesHasChangesChanged,
                                              savedPendingChanges:
                                                  _savedSizesChanges,
                                              onPendingChangesChanged:
                                                  _onSizesPendingChangesChanged,
                                            ),
                                            if (hasSettings) ...[
                                              const SizedBox(height: 16),
                                              ConfirmationButton(
                                                hasUnconfirmedChanges:
                                                    _hasUnconfirmedChanges,
                                                onConfirm: _confirmAllChanges,
                                              ),
                                            ] else
                                              Container(
                                                margin: const EdgeInsets.only(
                                                    top: 16),
                                                padding:
                                                    const EdgeInsets.all(16),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(8),
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
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
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
