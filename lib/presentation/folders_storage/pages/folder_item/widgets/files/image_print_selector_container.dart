import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_bloc.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/files/image_print_selector.dart';

class ImagePrintSelectorContainer extends StatelessWidget {
  final int imageId;
  const ImagePrintSelectorContainer({super.key, required this.imageId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SizesBloc, SizesState>(
      builder: (context, state) {
        if (state is SizesLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is SizesLoaded) {
          return ListView.builder(
            itemCount: state.sizes.length,
            itemBuilder: (context, index) {
              return ImagePrintSelector(
                size: state.sizes[index].name,
                imageId: imageId,
              );
            },
          );
        }
        return const Center(child: Text('Error'));
      },
    );
  }
}
