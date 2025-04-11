import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_bloc.dart';
import 'package:photo_app/entities/folder_settings/bloc/folder_settings_state.dart';
import 'package:photo_app/entities/order/bloc/order_bloc.dart';
import 'package:photo_app/entities/order/bloc/order_state.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_bloc.dart';
import 'package:photo_app/entities/sizes/bloc/sizes_state.dart';
import 'package:photo_app/presentation/folders_storage/pages/folder_item/widgets/images/image_print_selector.dart';

class ImagePrintSelectorContainer extends StatelessWidget {
  final int imageId;
  final int folderId;
  ImagePrintSelectorContainer({
    super.key,
    required this.imageId,
    required this.folderId,
  });

  final Map<dynamic, dynamic> sizesNames = {
    0: 'showSize1',
    1: 'showSize2',
    2: 'showSize3',
  };

  final Map<dynamic, dynamic> sizesDescriptionNames = {
    0: 'sizeDescription1',
    1: 'sizeDescription2',
    2: 'sizeDescription3',
  };

  @override
  Widget build(BuildContext context) {
    final sizesBloc = context.read<SizesBloc>();
    final orderBloc = context.read<OrderBloc>();
    int getDefaultQuantity(String sizeName) {
      if (orderBloc.state is! OrderLoaded) return 0;

      final orders =
          (orderBloc.state as OrderLoaded).orderForCarusel[imageId.toString()];
      if (orders == null) return 0;

      final result = orders.entries
          .where((element) => element.key == sizeName)
          .fold(0, (sum, entry) => sum + entry.value);
      return result;
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: sizesBloc),
        BlocProvider.value(value: orderBloc),
      ],
      child: BlocBuilder<FolderSettingsBloc, FolderSettingsState>(
        builder: (context, folderSettingsState) {
          return BlocBuilder<SizesBloc, SizesState>(
            builder: (context, state) {
              if (state is SizesLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SizesLoaded &&
                  folderSettingsState is FolderSettingsLoaded) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: state.sizes.map((size) {
                      return BlocBuilder<FolderSettingsBloc,
                          FolderSettingsState>(
                        builder: (context, settingsState) {
                          if (settingsState is FolderSettingsLoaded &&
                              !settingsState.folderSettings.getProperty(
                                  sizesNames[state.sizes.indexOf(size)] ??
                                      '')) {
                            return const SizedBox.shrink();
                          }
                          return ImagePrintSelector(
                            size: size,
                            imageId: imageId,
                            folderId: folderId,
                            description: folderSettingsState.folderSettings
                                .getProperty(sizesDescriptionNames[
                                        state.sizes.indexOf(size)] ??
                                    ''),
                            defaultQuantity: getDefaultQuantity(size.name),
                          );
                        },
                      );
                    }).toList(),
                  ),
                );
              }
              return const Center(child: Text('Error'));
            },
          );
        },
      ),
    );
  }
}
