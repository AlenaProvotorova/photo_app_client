import 'package:flutter/material.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImageAdditionalPhotosContainer(
          imageId: widget.imageId,
          folderId: widget.folderId,
          onChangesMade: _onChangesMade,
          onConfirmCallback: (callback) => _photosConfirmCallback = callback,
        ),
        ImagePrintSelectorContainer(
          imageId: widget.imageId,
          folderId: widget.folderId,
          onChangesMade: _onChangesMade,
          onConfirmCallback: (callback) => _sizesConfirmCallback = callback,
        ),
        const SizedBox(height: 16),
        ConfirmationButton(
          hasUnconfirmedChanges: _hasUnconfirmedChanges,
          onConfirm: _confirmAllChanges,
        ),
      ],
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
