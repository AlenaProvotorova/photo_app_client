import 'package:flutter/material.dart';
import 'package:photo_app/core/constants/print_sizes.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/image_print_selector.dart';

class ImagePrintSelectorContainer extends StatelessWidget {
  final int imageId;
  const ImagePrintSelectorContainer({super.key, required this.imageId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImagePrintSelector(
          size: PrintSizes.size10x15,
          imageId: imageId,
        ),
        ImagePrintSelector(
          size: PrintSizes.size15x21,
          imageId: imageId,
        ),
        ImagePrintSelector(
          size: PrintSizes.size20x30,
          imageId: imageId,
        ),
      ],
    );
  }
}
